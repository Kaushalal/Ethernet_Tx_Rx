/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_mas_pkg.sv

* Purpose : make package of file

* Creation Date : 04-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_MAS_PKG_SV
`define AXI_STR_MAS_PKG_SV

`include "axi_str_mas_inf.sv"

package axi_str_mas_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

//typedef enum bit { MANUAL, RANDOM} tvalid_drv_mode_enum;
//typedef enum bit {SEQ,NON_SEQ} trans_type;
  `include "axi_str_mas_define.sv"
  //typedef virtual axi_str_mas_inf #(.DATA_SIZE(512),.USER_SIZE(1)) vinf;

  `include "axi_str_mas_config.sv"
  
  //master components
  `include "axi_str_mas_seq_item.sv"
  `include "axi_str_mas_sequencer.sv"
  `include "axi_str_mas_drv_callback.sv"
  //`include "axi_str_mas_user_callback.sv"
  `include "axi_str_mas_driver.sv"
  `include "axi_str_mas_monitor.sv"
  `include "axi_str_mas_agent.sv"
  `include "axi_str_mas_base_seqs.sv"

endpackage

`endif
