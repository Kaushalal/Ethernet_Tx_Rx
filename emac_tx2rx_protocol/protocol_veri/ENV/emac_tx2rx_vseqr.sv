`ifndef EMAC_TX2RX_VSEQR_SV
`define EMAC_TX2RX_VSEQR_SV

class emac_tx2rx_vseqr extends uvm_sequencer#(emac_tx_seqs_item);

	emac_tx_config tx_cfg;
	emac_tx_seqr   tx_seqr[];

	`uvm_component_utils_begin(emac_tx2rx_vseqr)
	`uvm_component_utils_end

	function new(string name = "emac_tx2rx_vseqr",uvm_component parent = null);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(emac_tx_config)::get(this,"","no_ports",tx_cfg))
			`uvm_fatal(get_full_name(),"unable to retrieve no of ports")
		tx_seqr = new[tx_cfg.no_of_ports];
	endfunction : build_phase

endclass : emac_tx2rx_vseqr

`endif 

