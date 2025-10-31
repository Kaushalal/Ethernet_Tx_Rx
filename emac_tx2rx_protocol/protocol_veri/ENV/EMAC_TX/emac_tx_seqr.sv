`ifndef EMAC_TX_SEQR_SV
`define EMAC_TX_SEQR_SV

class emac_tx_seqr#(
	shortint PAYLOAD_DATA_WIDTH = 8,
	shortint FRAME_DATA_WIDTH   = 32
	) extends uvm_sequencer#(emac_tx_seqs_item#(
									 .PAYLOAD_DATA_WIDTH(PAYLOAD_DATA_WIDTH),
									 .FRAME_DATA_WIDTH(FRAME_DATA_WIDTH)));

	`uvm_component_param_utils_begin(emac_tx_seqr#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH))
	`uvm_component_utils_end
	
	function new(string name = "emac_tx_seqr",uvm_component parent=null);
		super.new(name,parent);
	endfunction : new
	
endclass : emac_tx_seqr

`endif
