package emac_tx2rx_test_pkg;

	`include "uvm_macros.svh"
	import uvm_pkg::*;

	import axi_str_mas_pkg::*;
	import axi_str_slv_pkg::*;
	import axi_str_env_pkg::*;
	import axi_str_pkg::*;

	import axi_lite_pkg::*;

	import emac_tx_pkg::emac_tx_config;
	import emac_rx_pkg::emac_rx_config;
	import emac_tx_pkg::emac_tx_seqs;
	import emac_tx2rx_reg_pkg::*;
	import emac_tx2rx_env_pkg::*;

	`include "emac_tx2rx_base_test.sv"
	`include "emac_tx2rx_sanity_test.sv"

endpackage : emac_tx2rx_test_pkg 
