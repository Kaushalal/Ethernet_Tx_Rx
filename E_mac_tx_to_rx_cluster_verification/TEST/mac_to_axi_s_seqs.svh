/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = mac_to_axi_s_seqs.svh
//  ENGINEER  = Muskan Thakur 
//  VERSION   = 1.0 
//  DESCRIPTION = this file is responsible to convert the ethernet packet to axi_s data format.   
//
/////////////////////////////////////////////////////

`ifndef MAC_TO_AXI_S_SEQS
`define MAC_TO_AXI_S_SEQS

class mac_to_axi_s_seqs extends axi_str_mas_base_sequence #(32,32);

   `uvm_object_utils(mac_to_axi_s_seqs)

   mac_tx_seqr mac_tx_seqr_conv;
   mac_tx_seq_item req_mac;
   
   axi_str_mas_seq_item #(32,32) req_axi;

   function new (string name="mac_to_axi_s_seqs"); 
      super.new(name); 
   endfunction : new

   task body();

   forever begin 
    mac_tx_seqr_conv.get_next_item(req_mac);
   req_mac.print();
   `uvm_do_with(req_axi, { total_bytes == 2 ;} )
   mac_tx_seqr_conv.item_done();
   end 

   endtask 

endclass

`endif
