`ifndef AXI_LITE_MAS_CFG_SV
`define AXI_LITE_MAS_CFG_SV

class axi_lite_mas_cfg extends uvm_object;
  `uvm_object_utils(axi_lite_mas_cfg)
  function new (string name="");
    super.new(name);
  endfunction
  
   uvm_active_passive_enum is_active = UVM_ACTIVE;
  int no_of_axi_lite_mas = 1;
endclass
`endif
