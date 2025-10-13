/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_mas_config.sv

* Purpose : settings of enviroment (active / passive)

* Creation Date : 04-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_MAS_CONFIG_SV
`define AXI_STR_MAS_CONFIG_SV

class axi_str_mas_config extends uvm_object; 
 
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int no_of_axis_mas = 1;
  int id;
  
  `uvm_object_utils_begin(axi_str_mas_config) 
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_PRINT | UVM_STRING)
    `uvm_field_int(no_of_axis_mas, UVM_PRINT | UVM_DEC)
    `uvm_field_int(id, UVM_PRINT | UVM_DEC)
  `uvm_object_utils_end 

   function new (string name="axi_str_mas_config"); 
      super.new(name); 
   endfunction: new 
                   
endclass : axi_str_mas_config


`endif
