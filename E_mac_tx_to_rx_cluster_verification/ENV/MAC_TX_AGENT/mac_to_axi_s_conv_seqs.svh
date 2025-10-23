/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = mac_to_axi_s_conv_seqs.svh
//  ENGINEER  = Muskan Thakur 
//  VERSION   = 1.0 
//  DESCRIPTION = this file is responsible to convert the ethernet packet to axi_s data format.   
//
/////////////////////////////////////////////////////

`ifndef MAC_TO_AXI_S_CONV_SEQS
`define MAC_TO_AXI_S_CONV_SEQS

class mac_to_axi_s_conv_seqs extends axi_str_mas_base_seqs #(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE));

   `uvm_object_utils(mac_to_axi_s_conv_seqs)

   mac_tx_seqr mac_tx_seqr_conv;
   mac_tx_seq_item req_mac;

   rand bit[(`AXI_STR_DATA_SIZE-1):0] data_q[$];

   local int total_no_of_bytes;
   
   axi_str_mas_seq_item #(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)) req_axi_s;

////--------------------------------------------------------------------////
////--------------------------------------------------------------------////
////                NEW 
////--------------------------------------------------------------------////
////--------------------------------------------------------------------////
   
   function new (string name="mac_to_axi_s_seqs"); 
      super.new(name); 
   endfunction : new

////--------------------------------------------------------------------////
////--------------------------------------------------------------------////
////                CONVERT_PKT_TO_DATA 
////--------------------------------------------------------------------////
////--------------------------------------------------------------------////
   
   function void convert_pkt_to_data(mac_tx_seq_item req_mac_item);
   data_q = {};
   //data_q = {>>{req_mac_item.fcs, req_mac_item.payload_q, req_mac_item.Etype, req_mac_item.tci, req_mac_item.sa, req_mac_item.da } };
   data_q = {>>{req_mac_item.da, req_mac_item.sa, req_mac_item.tci, req_mac_item.Etype, req_mac_item.payload_q, req_mac_item.fcs } };
   
   foreach( data_q[i] ) begin
   data_q[i] = {<<8{data_q[i]}};
   `uvm_info( "DATA_Q",$sformatf(" data_q[%0d] = %b | %h ",i,data_q[i],data_q[i]),UVM_FULL)
   end 
   
   this.total_no_of_bytes = $size(req_mac_item.da) + $size(req_mac_item.sa) + $size(req_mac_item.tci) + $size(req_mac_item.Etype) + $size(req_mac_item.payload_q) + $size(req_mac_item.fcs);
   $display(" Total bytes = %0d || data_q.size = %0d || da = %0d || sa = %0d || tci = %0d || Etype = %0d || payload_q = %0d || fcs = %0d ",total_no_of_bytes,data_q.size,$size(req_mac_item.da), $size(req_mac_item.sa) , $size(req_mac_item.tci) , $size(req_mac_item.Etype) , $size(req_mac_item.payload_q) , $size(req_mac_item.fcs) ); 

   endfunction 
   
////--------------------------------------------------------------------////
////--------------------------------------------------------------------////
////                BODY 
////--------------------------------------------------------------------////
////--------------------------------------------------------------------////
   
   task body();

   forever begin 
    mac_tx_seqr_conv.get_next_item(req_mac);
    req_mac.print();
    
    //// CONVERSION LOGIC 
    convert_pkt_to_data( req_mac );
    `uvm_create(req_axi_s)
    `uvm_rand_send_with(req_axi_s, { total_bytes == total_no_of_bytes;  foreach(data_q[i]) {req_axi_s.tdata_q[i] == data_q[i];}})
    
    $display(" Converted data");
    req_axi_s.print();
    mac_tx_seqr_conv.item_done();
   end 

   endtask


endclass

`endif
