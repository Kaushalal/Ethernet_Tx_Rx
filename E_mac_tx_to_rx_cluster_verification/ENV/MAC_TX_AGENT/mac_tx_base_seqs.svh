/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = mac_tx_base_seqs.svh
//  ENGINEER  = Muskan Thakur 
//  VERSION   = 1.0 
//  DESCRIPTION = this file is responsible to genereate stimulus   
//
/////////////////////////////////////////////////////

`ifndef MAC_TX_BASE_SEQS
`define MAC_TX_BASE_SEQS

class mac_tx_base_seqs extends uvm_sequence#(mac_tx_seq_item);

  `uvm_object_utils(mac_tx_base_seqs)

  mac_tx_seq_item mac_pkt;
  
  rand bit [7:0][5:0] temp_da[$];  //// because without que it was taking same da and sa for every packet  
  rand bit [7:0][5:0] temp_sa[$];

  rand bit [7:0][1:0] temp_Etype;

  randc bit [11:0] vlan_q[$];
  
  rand int min_payload_size;
  rand int max_payload_size;
  
  rand int no_of_packet;

  constraint no_of_pkt_c { soft no_of_packet == 10 ;}
  constraint min_payload_size_c { soft min_payload_size == 46 ;}
  constraint max_payload_size_c { soft max_payload_size == 1500 ;}
  constraint da_c { soft temp_da.size == no_of_packet ;}
  constraint sa_c { soft temp_sa.size == no_of_packet ;}
  
  constraint vlan_q_c { soft vlan_q.size() == no_of_packet ;}
  
  constraint Etype_c { soft temp_Etype inside { 16'h0800, 16'h8100 }; }

  function new (string name = "mac_base_seqs");
  super.new(name);
  starting_phase = new("starting_phase");
  endfunction

  task pre_start();
   if(!uvm_config_db #(uvm_phase)::get(null,"", "run_phase_set",starting_phase))
       `uvm_fatal("STARTING_PHASE"," Failed to get phase at tx_base_seqs" )
  if( starting_phase != null ) begin 
      starting_phase.raise_objection(null,"RAISED_Objection at mac_tx_base_seqs",no_of_packet );
  end 
  endtask

  task body ();
  int i = 0;
  `uvm_create(mac_pkt)
  
  $display("BODY");
  repeat(no_of_packet) begin
      
     `uvm_rand_send_with( mac_pkt, { payload_q.size inside { [min_payload_size:max_payload_size] };
                                sa    inside {temp_sa};
                                da    inside {temp_da};
                                Etype == temp_Etype;
                                (i<vlan_q.size())->(vlan == vlan_q[i]) ; (i>=vlan_q.size())->(vlan inside {vlan_q}) ; } )
      i++;
     `uvm_info( "MAC_PKT",$sformatf(mac_pkt.sprint()),UVM_DEBUG)

  end

  endtask 

endclass

`endif
