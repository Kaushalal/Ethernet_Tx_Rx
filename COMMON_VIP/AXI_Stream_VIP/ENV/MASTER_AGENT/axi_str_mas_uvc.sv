/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_mas_uvc.sv

* Purpose : create number of agent and settings 

* Creation Date : 04-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_MAS_UVC_SV
`define AXI_STR_MAS_UVC_SV


class axi_str_mas_uvc #(int DATA_SIZE=32, int USER_SIZE=32)extends uvm_agent; 
 
   //config settings
   axi_str_mas_config mas_cfg[];
   axi_str_mas_config mas_config;

   //agent 
   axi_str_mas_agent #(DATA_SIZE,USER_SIZE) master_agent[];

   int i;
  `uvm_component_param_utils(axi_str_mas_uvc #(DATA_SIZE,USER_SIZE)) 
   
    //-------------------------------------------------------------------------------- 
     // Method : 
      
       // Arguments : 
        
         // Description : 
          
           //--------------------------------------------------------------------------------- 
   function new (string name="axi_str_mas_uvc", uvm_component parent=null); 
      super.new(name,parent); 
   endfunction: new 
   
   function void build_phase(uvm_phase phase);
      if(!uvm_config_db #(axi_str_mas_config)::get(this,"","no_master",mas_config))
        `uvm_warning(get_full_name(),"number of master default value")
      
      mas_cfg = new [mas_config.no_of_axis_mas];
      master_agent = new[mas_config.no_of_axis_mas];
      
      foreach(mas_cfg[i]) begin
        mas_cfg[i] = axi_str_mas_config ::type_id::create($sformatf("mas_cfg[%0d]",i));
        master_agent[i] = axi_str_mas_agent #(DATA_SIZE,USER_SIZE)::type_id::create($sformatf("master_agent[%0d]",i),this);
        mas_cfg[i].id = i;
        mas_cfg[i].is_active = mas_config.is_active;
        uvm_config_db #(axi_str_mas_config)::set(uvm_root::get(),$sformatf("*master_agent[%0d]*",i),"m_cfg",mas_cfg[i]);
      end     
     

   endfunction : build_phase

endclass : axi_str_mas_uvc

`endif
