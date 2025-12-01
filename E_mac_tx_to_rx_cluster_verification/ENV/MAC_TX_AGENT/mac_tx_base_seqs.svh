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
  
  rand bit [7:0][5:0] temp_da;
  rand bit [7:0][5:0] temp_sa;

  rand bit [7:0][1:0] temp_Etype;

  randc bit [11:0] vlan_q[$];
  
  rand int min_payload_size;
  rand int max_payload_size;
  
  rand int no_of_packet;

  constraint no_of_pkt_c { soft no_of_packet == 10 ;}
  constraint min_payload_size_c { soft min_payload_size == 46 ;}
  constraint max_payload_size_c { soft max_payload_size == 1500 ;}
  
  constraint vlan_q_c { soft vlan_q.size() == no_of_packet ;}
  
  constraint Etype_c { soft temp_Etype inside { 16'h0800, 16'h8100 }; }

  function new (string name = "mac_base_seqs");
  super.new(name);
  endfunction

  task body ();
  `uvm_create(mac_pkt);
  
  repeat(no_of_packet) begin
      
     `uvm_rand_send_with( mac_pkt, { payload_q.size inside { [min_payload_size:max_payload_size] };
                                sa    == temp_sa;
                                da    == temp_da;
                                Etype == temp_Etype;
                                vlan inside {vlan_q} ;    } )
      
     `uvm_info( "MAC_PKT",$sformatf(mac_pkt.sprint()),UVM_DEBUG)

  end

  endtask 

endclass

`endif
