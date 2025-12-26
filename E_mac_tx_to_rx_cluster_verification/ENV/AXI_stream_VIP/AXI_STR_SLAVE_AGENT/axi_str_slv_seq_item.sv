/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_slv_seq_item.sv

* Purpose : transection class

* Creation Date : 08-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_SLV_SEQ_ITEM_SV
`define AXI_STR_SLV_SEQ_ITEM_SV

class axi_str_slv_seq_item #(shortint DATA_SIZE=32,int USER_SIZE=32) extends uvm_sequence_item; 
 
 //keep tuser information
 bit [(USER_SIZE-1):0] tuser;
 
 //queue, contains all payloads/data for entire transfer
 bit [(DATA_SIZE-1):0] tdata_q [$];
 
 //queue, contains all byte enables for entire transfer
 bit [((DATA_SIZE/8)-1):0] tkeep_q [$];
 
 //indicates length of a packet (in terms of beats)
 int pkt_len;
 
 //indicates packet number (shows packet number is currently in transfer on axi stream)
 int pkt_num;
 
 //indicates start time of a packet (when a packet initiated)
 realtime pkt_end_time_ps;
 
 //indicates end time of a packet (when a packet end)
 realtime pkt_start_time_ps;
  

  `uvm_object_param_utils_begin(axi_str_slv_seq_item #(DATA_SIZE,USER_SIZE))
    `uvm_field_real(pkt_start_time_ps,UVM_ALL_ON | UVM_DEC)
    `uvm_field_real(pkt_end_time_ps,UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(pkt_len,UVM_ALL_ON | UVM_DEC)
    `uvm_field_queue_int(tdata_q,UVM_ALL_ON | UVM_HEX)
    `uvm_field_queue_int(tkeep_q,UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(tuser,UVM_ALL_ON | UVM_HEX)
  `uvm_object_utils_end

   function new (string name="axi_str_slv_seq_item"); 
      super.new(name); 
   endfunction: new 
                   
endclass : axi_str_slv_seq_item

`endif
