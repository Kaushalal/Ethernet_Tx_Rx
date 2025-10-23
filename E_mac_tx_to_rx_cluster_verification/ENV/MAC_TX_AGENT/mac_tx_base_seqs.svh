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
  
  rand bit [7:0][5:0] da;
  rand bit [7:0][5:0] sa;

  rand bit [7:0][1:0] Etype;

  rand bit [11:0] vlan;
  
  rand int min_payload_size;
  rand int max_payload_size;
  
  rand int no_of_packet;

  constraint no_of_pkt_c { soft no_of_packet == 10 ;}
  constraint min_payload_size_c { soft min_payload_size == 46 ;}
  constraint max_payload_size_c { soft max_payload_size == 1500 ;}

  function new (string name = "mac_base_seqs");
  super.new(name);
  endfunction

  task body ();

  repeat(no_of_packet) begin
      
     `uvm_create(mac_pkt);
     `uvm_do_with( mac_pkt, { payload_q.size inside { [min_payload_size:max_payload_size] };
                                sa    == this.sa;
                                da    == this.da;
                                Etype == this.Etype;
                                vlan  == this.vlan ;    } ) 
  end

  endtask 

endclass

`endif
