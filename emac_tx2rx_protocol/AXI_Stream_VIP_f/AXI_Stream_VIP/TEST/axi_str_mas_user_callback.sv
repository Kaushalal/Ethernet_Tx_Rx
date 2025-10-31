/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_mas_user_callback.sv

* Purpose :

* Creation Date : 09-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_MAS_USER_CALLBACK_SV
`define AXI_STR_MAS_USER_CALLBACK_SV
typedef axi_str_mas_driver; 
`include "axis_define.sv"
class axi_str_mas_user_callback extends axi_str_mas_drv_callback; 
 
  `uvm_object_utils(axi_str_mas_user_callback) 
   axi_str_mas_driver #(.DATA_SIZE(`DATA_WIDTH),.USER_SIZE(`USER_WIDTH)) drv_h;

   function new (string name="axi_str_mas_user_callback"); 
      super.new(name); 
   endfunction: new 
   
  /* function void tvalid_drv_random(byte unsigned packet_count,output tvalid_drv_mode_enum tvalid_drv_mode, output shortint unsigned min_itr, max_itr);//, tvalid_drv_mode_enum tvalid_mode);
      //if(pkt_count == 1)
	   tvalid_drv_mode = RANDOM;
	   min_itr = 2;
	   max_itr = 5;
   endfunction : tvalid_drv_random*/

   function void tvalid_drv_user(byte unsigned packet_count,beats_count,  output byte unsigned n_cycle_delay);//, tvalid_drv_mode_enum tvalid_mode);
	  //if(packet_count == 2 && beats_count == 2)
        //n_cycle_delay = 2;
      
    //$display($time," : this is master driver callback mathod of wait transfer packet_count=%0d | beats_count=%0d | n_cycle_delay=%0d",packet_count,beats_count,n_cycle_delay);
   endfunction : tvalid_drv_user
endclass : axi_str_mas_user_callback


`endif
