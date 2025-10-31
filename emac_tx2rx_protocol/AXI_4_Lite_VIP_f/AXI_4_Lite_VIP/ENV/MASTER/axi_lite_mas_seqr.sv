`ifndef AXI_LITE_MAS_SEQR
`define AXI_LITE_MAS_SEQR

class axi_lite_mas_seqr#(int ADDR_WIDTH, int DATA_WIDTH) extends uvm_sequencer#(axi_lite_mas_seqs_item#(ADDR_WIDTH,DATA_WIDTH));
	
	`uvm_component_param_utils(axi_lite_mas_seqr#(ADDR_WIDTH,DATA_WIDTH))
  
  	function new(string name="axi_lite_mas_seqr",uvm_component parent=null);
   	super.new(name,parent);
  	endfunction : new
	
endclass : axi_lite_mas_seqr
`endif
