/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_env_pkg.sv

* Purpose : make package of file

* Creation Date : 04-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_ENV_PKG_SV
`define AXI_STR_ENV_PKG_SV

`include "axi_str_mas_inf.sv"
`include "axi_str_slv_inf.sv"
package axi_str_env_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "axis_define.sv"
  import axi_str_mas_pkg::*;
  import axi_str_slv_pkg::*;
//`include "axi_str_scoreboard.sv"
endpackage

`endif
