/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_mas_drv_callback.sv

* Purpose : overite driver mathod (for wait transfer)

* Creation Date : 08-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_MAS_DRV_CALLBACK_SV
`define AXI_STR_MAS_DRV_CALLBACK_SV
`include "axi_str_mas_define.sv" //TODO
virtual class axi_str_mas_drv_callback extends uvm_callback; 
 
  `uvm_object_utils(axi_str_mas_drv_callback); 
  typedef tvalid_drv_mode_enum tvalid_drv_mode;
   
   function new (string name="axi_str_mas_drv_callback"); 
      super.new(name); 
   endfunction: new 

   //To set tvalid drive mode to RANDOM mode
   //'packet_count' indicates the packet number, which can be used to set RAMDOM MODE for perticular packet
   virtual function void tvalid_drv_random(byte unsigned packet_count,output tvalid_drv_mode tvalid_delay_mode, output shortint unsigned min_itr, max_itr);//, tvalid_drv_mode_enum tvalid_mode);
   endfunction : tvalid_drv_random

   //To set tvalid drive mode to MANUAL mode
   //'packet_count' : indicates the packet number
   //'beats_count' : indicates the beats number of a packet
   //'n_cycle_delay' : To deaasert tvalid for number of cycle
   virtual function void tvalid_drv_user(byte unsigned packet_count, beats_count, output byte unsigned n_cycle_delay);
   endfunction : tvalid_drv_user
   
endclass : axi_str_mas_drv_callback

`endif
