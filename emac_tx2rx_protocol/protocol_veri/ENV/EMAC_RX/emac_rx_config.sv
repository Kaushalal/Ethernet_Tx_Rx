`ifndef EMAC_RX_CONFIG_SV
`define EMAC_RX_CONFIG_SV

class emac_rx_config extends uvm_object;
	
	int unsigned no_of_ports = 1;
	int unsigned id;
	
	`uvm_object_utils_begin(emac_rx_config) 
    `uvm_field_int(no_of_ports, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(id, 		     UVM_ALL_ON | UVM_DEC)
  `uvm_object_utils_end 

	function new(string name = "emac_rx_config");
		super.new(name);
	endfunction : new

endclass : emac_rx_config 

`endif

