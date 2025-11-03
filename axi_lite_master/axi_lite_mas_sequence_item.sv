`ifndef AXI_LITE_MAS_SEQUENCE_ITEM
`define AXI_LITE_MAS_SEQUENCE_ITEM

class axi_lite_mas_sequence_item#(int ADDR_WIDTH=32,int DATA_WIDTH=32) extends uvm_sequence_item;

  rand bit[ADDR_WIDTH-1:0] r_addr;
  rand bit [ADDR_WIDTH-1:0] addr; // AWADDR
  rand bit [DATA_WIDTH-1:0] w_data;
  bit [DATA_WIDTH-1:0] r_data;
 /// trans_kind_e axi_op_e;
  rand trans_kind_e axi_op_e;
  int trans_ctr;
  `uvm_object_param_utils_begin(axi_lite_mas_sequence_item#(ADDR_WIDTH,DATA_WIDTH))
  `uvm_field_int(trans_ctr, UVM_DEC)
  `uvm_field_int(addr, UVM_DEC)
  `uvm_field_int(r_addr, UVM_DEC)
  `uvm_field_int(w_data, UVM_DEC)
  `uvm_field_int(r_data, UVM_DEC)
  `uvm_field_enum(trans_kind_e,axi_op_e,UVM_ALL_ON)
  `uvm_object_utils_end
 
  
  function new(string name="");
    super.new(name);
  endfunction
  
endclass
`endif