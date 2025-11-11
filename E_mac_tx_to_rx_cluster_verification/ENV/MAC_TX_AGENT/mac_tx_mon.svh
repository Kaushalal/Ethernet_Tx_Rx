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

////-------------------------------------------------------------------------------------////
////-------------------------------------------------------------------------------------////
////                NEW FUNTION 
////-------------------------------------------------------------------------------------////
////-------------------------------------------------------------------------------------////

   function new( string name = "mac_tx_mon", uvm_component parent = null);
   super.new(name,parent);

   mac_tx_mon_imp = new("mac_tx_mon_imp",this);
   endfunction

////-------------------------------------------------------------------------------------////
////-------------------------------------------------------------------------------------////
////                WRITE FUNTION 
////-------------------------------------------------------------------------------------////
////-------------------------------------------------------------------------------------////


   function void write (axi_str_mas_seq_item#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)) axi_s_mseq_item );
    bit[31:0] temp_fcs;
    
    $cast(axi_s_sampled_item,axi_s_mseq_item.clone()) ;
    `uvm_info("MAC_MON_AXI_TDATA",axi_s_sampled_item.sprint(),UVM_FULL)
    
    ////-------------------------------------------------------------------------------------////
    ////                CONVERT TDATA TO PKT  
    ////-------------------------------------------------------------------------------------////

    mac_item = new("mac_item");
    
    foreach(axi_s_sampled_item.tdata_q[i])begin
    `uvm_info("TDATA_TO_PKT",$sformatf("BEFORE Converision : Tdata_q[%0d] = %h ",i,axi_s_sampled_item.tdata_q[i]),UVM_FULL)
     axi_s_sampled_item.tdata_q[i] = {<<8{axi_s_sampled_item.tdata_q[i]}};
    `uvm_info("TDATA_TO_PKT",$sformatf("AFTER Converision : Tdata_q[%0d] = %h ",i,axi_s_sampled_item.tdata_q[i]),UVM_FULL)
    end 

    {>>{mac_item.da, mac_item.sa, mac_item.tci, mac_item.Etype, mac_item.payload_q, mac_item.fcs }} = axi_s_sampled_item.tdata_q ;
    {>>{mac_item.dei,mac_item.pri,mac_item.vlan}} = mac_item.tci;

    foreach( axi_s_sampled_item.tkeep_q[i,j] ) begin
         if( axi_s_sampled_item.tkeep_q[i][j] == 0 ) begin
             mac_item.fcs = mac_item.fcs >> 8;
             mac_item.fcs[$left(mac_item.fcs)] = mac_item.payload_q[$] ;
             mac_item.payload_q.pop_back();
         end
     end 

    `uvm_info("MAC_MON_MAC_PKT",mac_item.sprint(),UVM_MEDIUM)

   endfunction 

endclass

`endif
