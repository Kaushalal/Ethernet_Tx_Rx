`ifndef EMAC_TX2RX_REF_MODEL_SV
`define EMAC_TX2RX_REF_MODEL_SV

class emac_tx2rx_ref_model extends uvm_component;

	uvm_analysis_imp#(emac_tx_seqs_item#(8,32),emac_tx2rx_ref_model) txmon_analysis_imp;

	`uvm_component_utils_begin(emac_tx2rx_ref_model)
	`uvm_component_utils_end

	function new(string name = "emac_tx2rx_ref_model",uvm_component parent = null);
		super.new(name,parent);
		txmon_analysis_imp = new("txmon_analysis_imp",this);
	endfunction : new

	virtual function void write(emac_tx_seqs_item#(8,32) tx_seqs_item);
		`uvm_info(get_full_name(),tx_seqs_item.sprint(),UVM_MEDIUM)
	endfunction : write

endclass : emac_tx2rx_ref_model

`endif 	
	
