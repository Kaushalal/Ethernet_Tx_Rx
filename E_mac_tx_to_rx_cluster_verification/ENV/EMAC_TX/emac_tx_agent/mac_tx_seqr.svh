/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = mac_tx_seqr.svh
//  ENGINEER  = Muskan Thakur 
//  VERSION   = 1.0 
//  DESCRIPTION = this file is responsible to genereate stimulus   
//
/////////////////////////////////////////////////////

`ifndef MAC_TX_SEQR
`define MAC_TX_SEQR

class mac_tx_seqr extends uvm_sequencer#(mac_tx_seq_item);

   `uvm_component_utils(mac_tx_seqr)

   function new( string name = "mac_tx_seqr", uvm_component parent = null);
   super.new(name,parent);
   endfunction 

endclass

`endif
