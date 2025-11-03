/*------------------------------------------------------------------------
                          Name      : Jyoti Vishwakarma
                          File Name : tx2rx_cluster_ral_pkg.sv
                          Date      : Oct 9
------------------------------------------------------------------------ */

`ifndef RAL_PKG
`define RAL_PKG

package tx2rx_cluster_ral_pkg;

`include"uvm_macros.svh"
import uvm_pkg::*;
import slv_axi_pkg::*;
import mas_axi_pkg::*;

import axi4_lite_pkg::*;

`include"tx2rx_cluster_reg_adapter.sv"
`include"tx2rx_cluster_register.sv"
`include"tx2rx_cluster_reg_block.sv"


`include"tx2rx_cluster_reg_base_seq.sv"
endpackage

`endif 
