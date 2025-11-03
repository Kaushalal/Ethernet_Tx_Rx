`ifndef MAC_RX_UVC
`define MAC_RX_UVC

class mac_rx_agent_uvc extends uvm_agent;
    `uvm_component_utils(mac_rx_agent_uvc)
	  mac_rx_cfg mac_r_cfg[];
	  mac_rx_cfg mac_rx_config;
     mac_rx_agent mac_r_agent[];
     function new (string name="",uvm_component parent);
        super.new(name,parent);
     endfunction

     function void build_phase(uvm_phase phase);
      if(!uvm_config_db #(mac_rx_cfg)::get(this,"","no_master",mac_rx_config))
        `uvm_warning(get_full_name(),"number of master default value")
        mac_r_cfg=new[mac_rx_config.no_of_mac_rx];
        mac_r_agent=new[mac_rx_config.no_of_mac_rx];
       
       foreach(mac_r_cfg[i]) begin
        mac_r_cfg[i] = mac_rx_cfg ::type_id::create($sformatf("mac_r_cfg[%0d]",i));
        mac_r_agent[i] = mac_rx_agent::type_id::create($sformatf("mac_r_agent[%0d]",i),this);
    //    mas_cfg[i].id = i;
        mac_r_cfg[i].is_active = mac_rx_config.is_active;
        uvm_config_db #(mac_rx_cfg)::set(uvm_root::get(),$sformatf("*mac_r_agent[%0d]*",i),"m_cfg",mac_r_cfg[i]);
      end
     endfunction
endclass
`endif
