`ifndef AXI_LITE_PKG
`define AXI_LITE_PKG

`include"axi_lite_mas_inf.sv"

package axi_lite_pkg;

	localparam int ADDR_WIDTH=32;
	localparam int DATA_WIDTH=32;
	import uvm_pkg::*;

	`include "uvm_macros.svh"
	`include "axi_lite_define.sv"
	`include"axi_lite_mas_seqs_item.sv"
	`include"axi_lite_seqs.sv"
	`include"axi_lite_mas_seqr.sv"
	`include"axi_lite_mas_drv.sv"
	`include"axi_lite_mas_mon.sv"

	`include "axi_lite_mas_cfg.sv"
	`include	"axi_lite_mas_agent.sv"
	`include "axi_lite_mas_uvc.sv"

	`include	"axi_lite_env.sv"
	`include "axi_lite_test.sv"

endpackage : axi_lite_pkg
`endif
