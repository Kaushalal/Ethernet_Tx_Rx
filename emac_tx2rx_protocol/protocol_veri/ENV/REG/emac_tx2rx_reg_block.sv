`ifndef EMAC_TX2RX_REG_BLOCK_SV
`define EMAC_TX2RX_REG_BLOCK_SV

class emac_tx2rx_reg_block extends uvm_reg_block;

	rand conn_config_reg conn_config_reg_h[];
	rand outport_sel_reg outport_sel_reg_h[];
	rand crc_reg 			crc_reg_h;
	rand vcid_config_reg vcid_config_reg_h[];

	uvm_reg_map	config_reg_map;
	uvm_reg_map misc_reg_map;

	`uvm_object_utils(emac_tx2rx_reg_block)

	function new(string name = "emac_tx2rx_reg_block");
		super.new(name);
	endfunction : new

	function void build();
		conn_config_reg_h = new[2**15];    //addr = {port_id,vlanid} : 15bit
		foreach(conn_config_reg_h[i]) begin
			conn_config_reg_h[i] = conn_config_reg::type_id::create($sformatf("conn_config_reg_h[%0d]",i));
			conn_config_reg_h[i].configure(this);
			conn_config_reg_h[i].build();
		end

		outport_sel_reg_h = new[32];       //addr = connection_id : 5bit
		foreach(outport_sel_reg_h[i]) begin
			outport_sel_reg_h[i] = outport_sel_reg::type_id::create($sformatf("outport_sel_reg_h[%0d]",i));
			outport_sel_reg_h[i].configure(this);
			outport_sel_reg_h[i].build();
		end

		crc_reg_h = crc_reg::type_id::create("crc_reg_h");
		crc_reg_h.configure(this);
		crc_reg_h.build();
	
		vcid_config_reg_h = new[32];       //addr = connection_id : 5bit
		foreach(vcid_config_reg_h[i]) begin
			vcid_config_reg_h[i] = vcid_config_reg::type_id::create($sformatf("vcid_config_reg_h[%0d]",i));
			vcid_config_reg_h[i].configure(this);
			vcid_config_reg_h[i].build();
		end

		config_reg_map = create_map(.name("config_reg_map"),
											 .base_addr('h4000),
											 .n_bytes(4),
											 .endian(UVM_LITTLE_ENDIAN));
	
		misc_reg_map = create_map(.name("misc_reg_map"),
										  .base_addr('h3000),
										  .n_bytes(4),
										  .endian(UVM_LITTLE_ENDIAN));

		foreach(conn_config_reg_h[i])
			config_reg_map.add_reg(.rg(conn_config_reg_h[i]),
										  .offset(i));

		foreach(outport_sel_reg_h[i])
			misc_reg_map.add_reg(.rg(outport_sel_reg_h[i]),
										.offset(i));

		misc_reg_map.add_reg(.rg(crc_reg_h),
									.offset('h30));

		foreach(vcid_config_reg_h[i])
			config_reg_map.add_reg(.rg(vcid_config_reg_h[i]),
										  .offset(i+'h800A));

		lock_model();

	endfunction : build

endclass : emac_tx2rx_reg_block

`endif
