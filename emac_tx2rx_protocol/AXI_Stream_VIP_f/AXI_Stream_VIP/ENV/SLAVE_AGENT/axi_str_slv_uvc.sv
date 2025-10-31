/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_slv_uvc.sv

* Purpose : create number of agent and settings

* Creation Date : 08-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_SLV_UVC_SV
`define AXI_STR_SLV_UVC_SV

class axi_str_slv_uvc #(shortint DATA_SIZE=32,int USER_SIZE=32) extends uvm_agent; 

  axi_str_slv_config slv_cfg[];
  axi_str_slv_config slv_config;

  axi_str_slv_agent #(DATA_SIZE,USER_SIZE) slave_agent[];

  int i;
  `uvm_component_utils(axi_str_slv_uvc) 
   
    //-------------------------------------------------------------------------------- 
     // Method : 
      
       // Arguments : 
        
         // Description : 
          
           //--------------------------------------------------------------------------------- 
   function new (string name="axi_str_slv_uvc", uvm_component parent=null); 
      super.new(name,parent); 
   endfunction: new 
        
   function void build_phase(uvm_phase phase);
      if(!uvm_config_db #(axi_str_slv_config)::get(this,"","no_slave",slv_config))
        `uvm_warning(get_full_name(),"number of master default value")
      
      slv_cfg = new [slv_config.no_of_axis_slv];
      slave_agent = new[slv_config.no_of_axis_slv];
      
      foreach(slv_cfg[i]) begin
        slv_cfg[i] = axi_str_slv_config ::type_id::create($sformatf("slv_cfg[%0d]",i));
        slave_agent[i] = axi_str_slv_agent #(DATA_SIZE,USER_SIZE) ::type_id::create($sformatf("slave_agent[%0d]",i),this);
        slv_cfg[i].slv_id = i;
        slv_cfg[i].is_active = slv_config.is_active;
        uvm_config_db #(axi_str_slv_config)::set(uvm_root::get(),$sformatf("*slave_agent[%0d]*",i),"s_cfg",slv_cfg[i]);
      end     
     
     //slv_cfg[1].is_active = UVM_PASSIVE;

   endfunction : build_phase
endclass : axi_str_slv_uvc

`endif
