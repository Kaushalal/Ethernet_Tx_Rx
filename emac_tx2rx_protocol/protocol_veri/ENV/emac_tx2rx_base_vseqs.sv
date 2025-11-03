`ifndef EMAC_TX2RX_BASE_VSEQS_SV
`define EMAC_TX2RX_BASE_VSEQS_SV

class emac_tx2rx_base_vseqs extends uvm_sequence#(emac_tx_seqs_item);

	`uvm_declare_p_sequencer(emac_tx2rx_vseqr)

	`uvm_object_utils_begin(emac_tx2rx_base_vseqs)
	`uvm_object_utils_end

	function new(string name = "emac_tx2rx_base_vseqs");
		super.new(name);
	endfunction : new

	virtual task body();
	endtask : body

endclass : emac_tx2rx_base_vseqs

`endif 
