/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-

*	File_Name     : emac_rx_pkg.sv
*	Purpose       : Provides all components and configuration for monitoring 
						 and verifying received Ethernet frames in the EMAC RX VIP.
*  Created By    : Meet_Patel

-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-. */

package emac_rx_pkg;

	localparam shortint USER_SIZE = 32;
	localparam shortint DATA_SIZE = 32;

	`include "uvm_macros.svh"
	import uvm_pkg::*;

	//VIP
	import axi_str_slv_pkg::*;

	`include "emac_rx_config.sv"
	`include "emac_rx_seqs_item.sv"
	`include "emac_rx_mon.sv"
	`include "emac_rx_agent.sv"

endpackage : emac_rx_pkg 
