/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_slv_config.sv

* Purpose : settings of enviroment (active / passive)

* Creation Date : 08-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_SLV_CONFIG_SV
`define AXI_STR_SLV_CONFIG_SV

class axi_str_slv_config extends uvm_object; 

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int no_of_axis_slv = 1;
  int slv_id;
  
  `uvm_object_utils_begin(axi_str_slv_config)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_PRINT | UVM_STRING)
    `uvm_field_int(no_of_axis_slv, UVM_PRINT | UVM_DEC)
    `uvm_field_int(slv_id, UVM_PRINT | UVM_DEC)
  `uvm_object_utils_end   
   
    //-------------------------------------------------------------------------------- 
     // Method : 
      
       // Arguments : 
        
         // Description : 
          
           //--------------------------------------------------------------------------------- 
   function new (string name="axi_str_slv_config"); 
      super.new(name); 
   endfunction: new 
                   
endclass : axi_str_slv_config

`endif
