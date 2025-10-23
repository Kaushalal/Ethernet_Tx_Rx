/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = axi_mseqr.svh
//  ENGINEER  = Muskan
//  VERSION   = 1.0 
//  DESCRIPTION = contains all macro 
//
/////////////////////////////////////////////////////

`ifndef AXI_MSEQR
`define AXI_MSEQR

class axi_mseqr #(int DATA_WIDTH = 16 , ADD_WIDTH = 8 ) extends uvm_sequencer #(axi_mseq_item#(DATA_WIDTH,ADD_WIDTH));

   `uvm_component_param_utils(axi_mseqr#(DATA_WIDTH, ADD_WIDTH))

   function new (string name = "axi_mseqr", uvm_component parent = null);
      super.new(name,parent);
   endfunction

   
endclass 

`endif

