`ifndef EMAC_TX2RX_REG_SV
`define EMAC_TX2RX_REG_SV

/*------------------------------------------------------------------------
							CONNECTION_CONFIGURE_REGISTER
------------------------------------------------------------------------*/

class conn_config_reg extends uvm_reg;

	rand uvm_reg_field conn_val;
	rand uvm_reg_field rsvd;
	rand uvm_reg_field conn_id;
	rand uvm_reg_field rsvd2;

	`uvm_object_utils(conn_config_reg)

	function new(string name = "emac_tx2rx_reg");
		super.new(name,32,UVM_NO_COVERAGE); //name,no_of_bits,has_coverage
	endfunction : new

	function void build();
		conn_val = uvm_reg_field::type_id::create("conn_val");
		conn_val.configure(.parent(this),
								 .size(1),
								 .lsb_pos(7),
								 .access("RW"),
								 .volatile(0),
								 .reset(0),
								 .has_reset(1),
								 .is_rand(1),
								 .individually_accessible(1));

		rsvd = uvm_reg_field::type_id::create("rsvd");
		rsvd.configure(.parent(this),
							.size(2),
							.lsb_pos(5),
							.access("RO"),
							.volatile(0),
							.reset(0),
							.has_reset(1),
							.is_rand(0),
							.individually_accessible(0));

		conn_id = uvm_reg_field::type_id::create("conn_id");
		conn_id.configure(.parent(this),
							   .size(5),
								.lsb_pos(0),
								.access("RW"),
								.volatile(0),
								.reset(0),
								.has_reset(1),
								.is_rand(1),
								.individually_accessible(1));

		rsvd2 = uvm_reg_field::type_id::create("rsvd2");
		rsvd2.configure(.parent(this),
							 .size(24),
							 .lsb_pos(8),
							 .access("RO"),
							 .volatile(0),
							 .reset(0),
							 .has_reset(1),
							 .is_rand(0),
							 .individually_accessible(0));
	endfunction : build

endclass : conn_config_reg

/*------------------------------------------------------------------------
							OUTPUT_PORT_SELECT_REGISTER
------------------------------------------------------------------------*/

class outport_sel_reg extends uvm_reg;

	rand uvm_reg_field outport_sel;
	rand uvm_reg_field rsvd;

	`uvm_object_utils(outport_sel_reg)

	function new(string name = "outport_sel_reg");
		super.new(name,32,UVM_NO_COVERAGE);
	endfunction : new

	function void build();
		outport_sel = uvm_reg_field::type_id::create("outport_sel");
		outport_sel.configure(.parent(this),
									 .size(4),
									 .lsb_pos(0),
									 .access("RW"),
									 .volatile(0),
									 .reset(0),
									 .has_reset(1),
									 .is_rand(1),
									 .individually_accessible(1));

		rsvd = uvm_reg_field::type_id::create("rsvd");
		rsvd.configure(.parent(this),
							.size(28),
							.lsb_pos(4),
							.access("RO"),
							.volatile(0),
							.reset(0),
							.has_reset(1),
							.is_rand(0),
							.individually_accessible(0));

	endfunction : build

endclass : outport_sel_reg

/*------------------------------------------------------------------------
							       CRC_REGISTER
------------------------------------------------------------------------*/

class crc_reg extends uvm_reg;

	rand uvm_reg_field crc;

	`uvm_object_utils(crc_reg)

	function new(string name = "crc_reg");
		super.new(name,32,UVM_NO_COVERAGE);
	endfunction : new

	function void build();
		crc = uvm_reg_field::type_id::create("crc");
		crc.configure(.parent(this),
						  .size(32),
						  .lsb_pos(0),
						  .access("RW"),
						  .volatile(0),
						  .reset(0),
						  .has_reset(1),
						  .is_rand(1),
						  .individually_accessible(1));
	endfunction : build

endclass : crc_reg

/*------------------------------------------------------------------------
							VCID_CONFIGURE_REGISTER
------------------------------------------------------------------------*/

class vcid_config_reg extends uvm_reg;

	rand uvm_reg_field vcid;
	rand uvm_reg_field rsvd;

	`uvm_object_utils(vcid_config_reg)

	function new(string name = "vcid_config_reg");
		super.new(name,32,UVM_NO_COVERAGE);
	endfunction : new

	function void build();
		vcid = uvm_reg_field::type_id::create("vcid");
		vcid.configure(.parent(this),
						   .size(8),
							.lsb_pos(0),
							.access("RW"),
							.volatile(0),
							.reset(0),
							.has_reset(1),
							.is_rand(1),
							.individually_accessible(1));

		rsvd = uvm_reg_field::type_id::create("rsvd");
		rsvd.configure(.parent(this),
						   .size(24),
							.lsb_pos(8),
							.access("RO"),
							.volatile(0),
							.reset(0),
							.has_reset(1),
							.is_rand(0),
							.individually_accessible(0));
	endfunction : build

endclass : vcid_config_reg

`endif 
