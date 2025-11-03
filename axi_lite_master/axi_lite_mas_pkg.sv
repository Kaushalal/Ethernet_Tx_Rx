`ifndef AXI_LITE_MAS_PKG 
`define AXI_LITE_MAS_PKG
`include"axi_lite_mas_interface.sv"
package axi_lite_mas_pkg;

localparam int ADDR_WIDTH=32;
localparam int DATA_WIDTH=32;
  import uvm_pkg::*;
`include "uvm_macros.svh"
`include "axi_lite_define.sv"
`include"axi_lite_mas_sequence_item.sv"
//`include"axi_lite_mas_sequence.sv"
`include"axi_lite_mas_sequencer.sv"
`include"axi_lite_mas_driver.sv"
`include"axi_lite_mas_monitor.sv"
`include "axi_lite_mas_cfg.sv"
`include"axi_lite_mas_agent.sv"
`include "axi_lite_mas_uvc.sv"
//`include"axi_lite_mas_scoreboard.sv"
//`include"axi_lite_mas_env.sv"

// `include"axi_lite_mas_interface.sv"
// `include "axi_lite_slv_driver.sv"
//`include "register.sv"
//`include "emac_tx_rx_reg_block.sv"
//`include "axi_lite_adapter.sv"
//`include"axi_lite_mas_env.sv"
//`include "ral_base_sequence.sv"
//`include"axi_lite_mas_env.sv"
//`include "axi_lite_mas_test.sv"

//`include "axi_slave_uvc.sv"
endpackage
`endif
