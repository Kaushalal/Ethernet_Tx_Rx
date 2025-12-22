/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_slv_user_callback.sv

* Purpose : override method of driver callback

* Creation Date : 10-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_SLV_USER_CALLBACK_SV
`define AXI_STR_SLV_USER_CALLBACK_SV

class axi_str_slv_user_callback extends axi_str_slv_drv_callback; 
 
  `uvm_object_utils(axi_str_slv_user_callback) 
   
     
   function new (string name="axi_str_slv_user_callback"); 
      super.new(name); 
   endfunction: new 
   
   /*function void tready_drv_random(byte unsigned packet_count, output tready_drv_mode tready_delay_mode, output shortint unsigned min_itr, max_itr);
      tready_delay_mode = SLV_RANDOM;
      min_itr = 2;
      max_itr = 5;
   endfunction : tready_drv_random*/

   function void tready_drv_user(shortint unsigned packet_count,beats_count, output int  n_cycle_delay);
      if(packet_count ==1 && beats_count == 0)
        n_cycle_delay = 512;
      `uvm_info("axi_str_slv_usr_callback",$sformatf(" :slave driver callback tready toggle : packet_count=%0d | beats_count=%0d | n_cycle_delay=%0d",packet_count,beats_count,n_cycle_delay),UVM_LOW)
   endfunction : tready_drv_user

endclass : axi_str_slv_user_callback

`endif
