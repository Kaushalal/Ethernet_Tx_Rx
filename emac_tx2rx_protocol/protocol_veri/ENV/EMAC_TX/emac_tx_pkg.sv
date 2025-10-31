package emac_tx_pkg;

	localparam shortint DATA_SIZE = 32;
	localparam shortint USER_SIZE = 32;

	`include "uvm_macros.svh"
	import uvm_pkg::*;

	//VIP
	import axi_str_mas_pkg::*;
	import axi_str_slv_pkg::*;
	import axi_str_env_pkg::*;
	import axi_str_pkg::*;

	`include "emac_tx_config.sv"
	`include "emac_tx_seqs_item.sv"
	`include "emac_tx_seqs.sv"
	`include "emac_tx_seqr.sv"
	`include "emac_2_axistr_seqs.sv"
	`include "emac_tx_mon.sv"
	`include "emac_tx_agent.sv"
	`include "emac_tx_uvc.sv"

endpackage : emac_tx_pkg 
