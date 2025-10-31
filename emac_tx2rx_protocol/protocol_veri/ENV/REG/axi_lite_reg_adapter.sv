`ifndef AXI_LITE_REG_ADAPTER_SV
`define AXI_LITE_REG_ADAPTER_SV

class axi_lite_reg_adapter#(
	shortint ADDR_WIDTH = 32,
	shortint DATA_WIDTH = 32) extends uvm_reg_adapter;

	`uvm_object_param_utils(axi_lite_reg_adapter#(ADDR_WIDTH,DATA_WIDTH))

	function new(string name = "axi_lite_reg_adapter");
		super.new(name);
	endfunction : new

	function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
		axi_lite_mas_seqs_item#(ADDR_WIDTH,DATA_WIDTH) seqs_item;
		seqs_item = axi_lite_mas_seqs_item#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("seqs_item");
		seqs_item.axi_op_e = (rw.kind == UVM_WRITE) ? AXI_LITE_WRITE : AXI_LITE_READ;
		seqs_item.addr = (rw.kind == UVM_WRITE)  ? rw.addr : 'd0;
		seqs_item.r_addr = (rw.kind == UVM_READ) ? rw.addr : 'd0;
		seqs_item.w_data = (rw.kind == UVM_WRITE) ? rw.data : 'd0;
		seqs_item.r_data = (rw.kind == UVM_READ)  ? rw.data : 'd0;
		return seqs_item;
	endfunction : reg2bus

	function void bus2reg(uvm_sequence_item bus_item,ref uvm_reg_bus_op rw);
		axi_lite_mas_seqs_item#(ADDR_WIDTH,DATA_WIDTH) seqs_item;
		if(!$cast(seqs_item,bus_item))
			`uvm_fatal(get_full_name(),"bus_item is not of type seqs_item")
		rw.kind = (seqs_item.axi_op_e == AXI_LITE_WRITE) ? UVM_WRITE : UVM_READ;
		rw.addr = (seqs_item.axi_op_e == AXI_LITE_WRITE) ? seqs_item.addr : seqs_item.r_addr;
		rw.data = (seqs_item.axi_op_e == AXI_LITE_WRITE) ? seqs_item.w_data : seqs_item.r_data;
	endfunction : bus2reg

endclass : axi_lite_reg_adapter

`endif 	
