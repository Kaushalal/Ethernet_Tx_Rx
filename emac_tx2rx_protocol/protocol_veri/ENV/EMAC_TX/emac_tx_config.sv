`ifndef EMAC_TX_CONFIG_SV
`define EMAC_TX_CONFIG_SV

class emac_tx_config extends uvm_object;
	
	uvm_active_passive_enum is_active   = UVM_ACTIVE;
	int unsigned 				no_of_ports = 1;
	int unsigned 				id;
	
	`uvm_object_utils_begin(emac_tx_config) 
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_PRINT | UVM_STRING)
    `uvm_field_int(no_of_ports, 							  	  UVM_PRINT | UVM_DEC)
    `uvm_field_int(id, 											  UVM_PRINT | UVM_DEC)
  `uvm_object_utils_end 

	function new(string name = "emac_tx_config");
		super.new(name);
	endfunction : new

endclass : emac_tx_config 

`endif

