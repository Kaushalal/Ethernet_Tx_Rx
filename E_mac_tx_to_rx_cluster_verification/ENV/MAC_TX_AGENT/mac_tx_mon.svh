/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = mac_tx_mon.svh
//  ENGINEER  = Muskan Thakur 
//  VERSION   = 1.0 
//  DESCRIPTION = this file is responsible to sample the data ( in this project we will be getting the the sampled data from axi_str_mon )   
//
/////////////////////////////////////////////////////

`ifndef MAC_TX_MON
`define MAC_TX_MON

class mac_tx_mon extends uvm_monitor;

   `uvm_component_utils(mac_tx_mon)

   uvm_analysis_imp#(axi_str_mas_seq_item#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)) , mac_tx_mon ) mac_tx_mon_imp;

   axi_str_mas_seq_item#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)) axi_s_sampled_item;
   
   mac_tx_seq_item mac_item;

   function new( string name = "mac_tx_mon", uvm_component parent = null);
   super.new(name,parent);

   mac_tx_mon_imp = new("mac_tx_mon_imp",this);
   endfunction

   function void write (axi_str_mas_seq_item#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)) axi_s_mseq_item );
    $cast(axi_s_sampled_item,axi_s_mseq_item.clone()) ;
    axi_s_sampled_item.print();
    
    mac_item = new("mac_item");

//// DATA to PKT pending 
/*
    {<<{mac_item.da, mac_item.sa, mac_item.tci, mac_item.Etype, mac_item.payload_q, mac_item.fcs }} = axi_s_sampled_item.tdata_q ;   
    $display(" MAC_MON");
    mac_item.print();
*/
   endfunction 

endclass

`endif
