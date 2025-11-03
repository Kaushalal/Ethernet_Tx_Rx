/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_slv_drv_callback.sv

* Purpose :

* Creation Date : 10-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_SLV_DRV_CALLBACK_SV
`define AXI_STR_SLV_DRV_CALLBACK_SV

class axi_str_slv_drv_callback extends uvm_callback; 
 
  `uvm_object_utils(axi_str_slv_drv_callback) 
   
  typedef tready_drv_mode_enum tready_drv_mode;

  function new (string name="axi_str_slv_drv_callback"); 
    super.new(name); 
  endfunction: new 
   
  //To set tready drive mode to RANDOM mode
  //'packet_count' indicates the packet number, which can be used to set RAMDOM MODE for perticular packet
  virtual function void tready_drv_random(byte unsigned packet_count, output tready_drv_mode tready_delay_mode, output shortint unsigned min_itr, max_itr);
  endfunction : tready_drv_random

   //To set tready drive mode to MANUAL mode
   //'packet_count' : indicates the packet number
   //'beats_count' : indicates the beats number of a packet
   //'n_cycle_delay' : To deaasert tready for number of cycle
   virtual function void tready_drv_user(byte unsigned packet_count, beats_count, output byte unsigned n_cycle_delay);
  endfunction : tready_drv_user

endclass : axi_str_slv_drv_callback

`endif
