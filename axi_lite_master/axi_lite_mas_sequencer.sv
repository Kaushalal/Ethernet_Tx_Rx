`ifndef AXI_LITE_MAS_SEQUENCER
`define AXI_LITE_MAS_SEQUENCER

class axi_lite_mas_sequencer#(int ADDR_WIDTH, int DATA_WIDTH) extends uvm_sequencer#(axi_lite_mas_sequence_item#(ADDR_WIDTH,DATA_WIDTH));
  `uvm_component_param_utils(axi_lite_mas_sequencer#(ADDR_WIDTH,DATA_WIDTH))
  
  function new(string name="",uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass
`endif