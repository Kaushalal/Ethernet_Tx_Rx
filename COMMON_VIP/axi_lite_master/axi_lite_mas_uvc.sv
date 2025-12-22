`ifndef AXI_LITE_MAS_UVC
`define AXI_LITE_MAS_UVC

class axi_lite_mas_uvc extends uvm_agent;
  `uvm_component_utils(axi_lite_mas_uvc)
  function new (string name="",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  axi_lite_mas_cfg mas_cfg[];
  axi_lite_mas_cfg mas_config;
  axi_lite_mas_agent axi_lite_m_agent[];
  
     function void build_phase(uvm_phase phase);
      if(!uvm_config_db #(axi_lite_mas_cfg)::get(this,"","no_master",mas_config))
        `uvm_warning(get_full_name(),"number of master default value")
        mas_cfg=new[mas_config.no_of_axi_lite_mas];
       axi_lite_m_agent=new[mas_config.no_of_axi_lite_mas];
       
       foreach(mas_cfg[i]) begin
        mas_cfg[i] = axi_lite_mas_cfg ::type_id::create($sformatf("mas_cfg[%0d]",i));
        axi_lite_m_agent[i] = axi_lite_mas_agent::type_id::create($sformatf("axi_lite_m_agent[%0d]",i),this);
    //    mas_cfg[i].id = i;
        mas_cfg[i].is_active = mas_config.is_active;
        uvm_config_db #(axi_lite_mas_cfg)::set(uvm_root::get(),$sformatf("*axi_lite_m_agent[%0d]*",i),"m_cfg",mas_cfg[i]);
      end
     endfunction
endclass
`endif
  
