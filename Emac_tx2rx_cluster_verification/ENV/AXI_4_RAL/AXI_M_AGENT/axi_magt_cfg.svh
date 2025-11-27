/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = axi_magt_cfg.svh
//  ENGINEER  = Muskan
//  VERSION   = 1.0 
//  DESCRIPTION = contains all macro 
//
/////////////////////////////////////////////////////

`ifndef AXI_MAGT_CFG
`define AXI_MAGT_CFG

class axi_magt_cfg extends uvm_object;

  uvm_active_passive_enum magt_is_active;
  bit has_wid; 
  
  bit pipeline_drv; 
  
  int no_of_agent; 
  int id; 
  
  `uvm_object_utils_begin(axi_magt_cfg)
      `uvm_field_enum (uvm_active_passive_enum, magt_is_active, UVM_ALL_ON )
      `uvm_field_int (has_wid, UVM_ALL_ON )
      `uvm_field_int (pipeline_drv, UVM_ALL_ON )
      `uvm_field_int (no_of_agent, UVM_ALL_ON )
      `uvm_field_int (id, UVM_ALL_ON )
   `uvm_object_utils_end

   function new (string name = "axi_magt_cfg");
      super.new(name);
   endfunction

   
endclass 

`endif

