/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_mas_seq_item.sv

* Purpose : transection class

* Creation Date : 04-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_MAS_SEQ_ITEM_SV
`define AXI_STR_MAS_SEQ_ITEM_SV

class axi_str_mas_seq_item #(int DATA_SIZE=32,int USER_SIZE=32) extends uvm_sequence_item; 
 
  //total bytes in a transafer
  rand int unsigned total_bytes;
 
  //number of bytes in each beats
  rand int unsigned no_of_bytes;
 
  //drive tuser 
  rand bit [(USER_SIZE-1):0] tuser;
  
  //queue, contains all payloads/data for entire transfer
  rand bit [(DATA_SIZE-1):0] tdata_q [$];

  //queue, contains all byte enables for entire transfer
  bit [((DATA_SIZE/8)-1):0] tkeep_q [$];
  
  //indicates length of a packet (in terms of beats)
  int pkt_len;
  
  //indicates packet number (shows packet number is currently in transfer on axi stream)
  int pkt_num;
  
  //indicates start time of a packet (when a packet initiated)
  realtime pkt_start_time_ps;
  
  //indicates end time of a packet (when a packet end)
  realtime pkt_end_time_ps;

  //indicates start of new packet
  event pkt_started_ev;

  //indicates end of current packet
  event pkt_end_ev;
  

  `uvm_object_param_utils_begin(axi_str_mas_seq_item #(DATA_SIZE,USER_SIZE))
    `uvm_field_real(pkt_start_time_ps,UVM_ALL_ON | UVM_DEC)
    `uvm_field_real(pkt_end_time_ps,UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(total_bytes,UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(no_of_bytes,UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(pkt_len,UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(pkt_num,UVM_ALL_ON | UVM_HEX)
    `uvm_field_queue_int(tdata_q,UVM_ALL_ON | UVM_HEX)
    `uvm_field_queue_int(tkeep_q,UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(tuser,UVM_ALL_ON | UVM_HEX)
  `uvm_object_utils_end
   

  constraint data_que_size { 
                            tdata_q.size() == (((total_bytes%no_of_bytes)==0) ?  (int'(total_bytes/no_of_bytes)) :
                                                                                 (int'(total_bytes/no_of_bytes) + 1'b1));
                            solve tdata_q.size before tdata_q;
                            solve total_bytes before tdata_q.size;
                           } //set size of write data queue array

  constraint NO_OF_BYTES {
                          soft no_of_bytes==(DATA_SIZE/8);
                          solve no_of_bytes before tdata_q.size;
						 }  //set number of bytes in each beats 
					   

  function new (string name="axi_str_mas_seq_item"); 
    super.new(name); 
  endfunction: new 
  
  
  function void post_randomize();
    tkeep_cal();
  endfunction : post_randomize

  //calculate packet length and tkeep based on total_bytes and no_of_bytes
  virtual protected function void tkeep_cal();
    int total_bytes_temp,j;
	bit keep_q [];
	   
    pkt_len = ((total_bytes%no_of_bytes) == 0) ? (total_bytes/no_of_bytes) :
                                                 (total_bytes/no_of_bytes + 1);
												 
    total_bytes_temp = total_bytes;	
    tkeep_q.delete();	  
    for(int itr=0;itr<pkt_len;itr++) begin
      j = no_of_bytes;
      if (total_bytes_temp < no_of_bytes) j = total_bytes_temp;
		
	  keep_q = new[DATA_SIZE/8];
	  for (int i=0;i<j;i++)
        keep_q[i] = 1'b1;
		
      tkeep_q.push_back({<<{keep_q}});
      total_bytes_temp-=no_of_bytes;
    end
  endfunction
  
endclass : axi_str_mas_seq_item

`endif
