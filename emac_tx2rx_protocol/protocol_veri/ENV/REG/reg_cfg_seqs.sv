`ifndef REG_CFG_SEQS_SV
`define REG_CFG_SEQS_SV

class reg_cfg_seqs extends uvm_sequence;

	rand bit [11:0] vlan_id;
	rand bit [2:0]  port_id;

	rand bit        conn_val;
	rand bit [4:0]  conn_id;

	rand bit [3:0]  outport_sel;
	rand bit [31:0] crc_val;

	rand bit [7:0]  vcid;

	emac_tx2rx_reg_block reg_blk;

	`uvm_object_utils_begin(reg_cfg_seqs)
		`uvm_field_int(vlan_id,     UVM_ALL_ON | UVM_HEX)
		`uvm_field_int(port_id,     UVM_ALL_ON | UVM_HEX)
		`uvm_field_int(conn_val,    UVM_ALL_ON)
		`uvm_field_int(conn_id,     UVM_ALL_ON)
		`uvm_field_int(outport_sel, UVM_ALL_ON)
		`uvm_field_int(crc_val,     UVM_ALL_ON)
		`uvm_field_int(vcid,        UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "reg_cfg_seqs");
		super.new(name);
	endfunction : new

	constraint VALID_CNSTR {soft conn_val == 1;
									soft port_id inside {[3:5]};}

	virtual task pre_body();
  		super.pre_body();
  		if (!uvm_config_db#(emac_tx2rx_reg_block)::get(get_sequencer(),"","reg_blk",reg_blk)) begin
    		`uvm_error("REG_CFG_SEQ", "reg_blk not set via config_db")
  		end
	endtask : pre_body
	
	task body();
		uvm_status_e status;
		//STEP -1 : CONNECTION_CONFIG_REG connection_valid and connection_id setup -> addr - {port,vlan}
		reg_blk.conn_config_reg_h[{port_id,vlan_id}].conn_val.write(status,this.conn_val);
		reg_blk.conn_config_reg_h[{port_id,vlan_id}].conn_id.write(status,this.conn_id);

		//STEP -2  : OUTPUT_PORT -> addr - connection_id
		reg_blk.outport_sel_reg_h[conn_id].outport_sel.write(status,this.outport_sel);

		//STEP -3  : CRC -> addr - connection_id
		reg_blk.crc_reg_h.crc.write(status,this.crc_val);

		//STEP -4  : VCID_CONFIG_REG vcid_setup -> addr - connection_id
		reg_blk.vcid_config_reg_h[conn_id].vcid.write(status,this.vcid);
		`uvm_info(get_full_name(),this.sprint(),UVM_MEDIUM)	
	endtask : body 

endclass : reg_cfg_seqs

`endif

