/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_slv_pkg.sv

* Purpose : make package of file

* Creation Date : 04-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_SLV_PKG_SV
`define AXI_STR_SLV_PKG_SV

`include "axi_str_slv_inf.sv"
package axi_str_slv_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"


  `include "axi_str_slv_define.sv" 
  //`include "axi_str_mas_define.sv"  //TODO
  // typedef virtual axi_str_slv_inf vinf;
  `include "axi_str_slv_config.sv"
 
   //slave components

  `include "axi_str_slv_seq_item.sv"
  `include "axi_str_slv_sequencer.sv"
  `include "axi_str_slv_drv_callback.sv"
  `include "axi_str_slv_user_callback.sv"
  `include "axi_str_slv_driver.sv"
  `include "axi_str_slv_monitor.sv"
  `include "axi_str_slv_agent.sv"
  `include "axi_str_slv_uvc.sv"



endpackage

`endif
