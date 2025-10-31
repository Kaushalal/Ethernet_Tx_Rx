package emac_tx2rx_env_pkg;

	`include "uvm_macros.svh"
	import uvm_pkg::*;

	import axi_str_mas_pkg::*;
	import axi_str_slv_pkg::*;
	import axi_str_env_pkg::*;
	import axi_str_pkg::*;

	import axi_lite_pkg::*;

	import emac_tx_pkg::*;
	import emac_rx_pkg::*;

	import emac_tx2rx_reg_pkg::*;
	`include "axi_lite_reg_adapter.sv"
	
	`include "emac_tx2rx_vseqr.sv"
	`include "emac_tx2rx_base_vseqs.sv"

	`include "emac_tx2rx_env.sv"

endpackage : emac_tx2rx_env_pkg 
