/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = mac_tx_uvc.svh
//  ENGINEER  = Muskan Thakur 
//  VERSION   = 1.0 
//  DESCRIPTION = this file is responsible to genereate stimulus   
//
/////////////////////////////////////////////////////

`ifndef MAC_TX_UVC
`define MAC_TX_UVC

class mac_tx_uvc extends uvm_component;

   `uvm_component_utils(mac_tx_uvc)

   mac_tx_agent mac_tx_agent_h[];
   mac_tx_cfg mac_tx_cfg_h[];
   
   mac_tx_cfg mac_tx_cfg_get;

   function new(string name = "",uvm_component parent = null);
     super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
     super.build_phase(phase);

     if(!uvm_config_db #(mac_tx_cfg)::get(this,"","no_tx_agent",mac_tx_cfg_get))
        `uvm_warning(get_full_name(),"number of master default value")
     
     mac_tx_agent_h = new[mac_tx_cfg_get.no_of_tx_agent];
     mac_tx_cfg_h = new[mac_tx_cfg_get.no_of_tx_agent];
      
     foreach(mac_tx_agent_h[i])begin
         mac_tx_agent_h[i] = mac_tx_agent::type_id::create($sformatf("mac_tx_agent_h[%0d]",i),this);
         mac_tx_cfg_h[i] = mac_tx_cfg::type_id::create($sformatf("mac_tx_cfg_h[%0d]",i));

         mac_tx_cfg_h[i].is_active = mac_tx_cfg_get.is_active;
         mac_tx_cfg_h[i].id = i;
         uvm_config_db #(mac_tx_cfg)::set(uvm_root::get(),$sformatf("*mac_tx_agent_h[%0d]*",i),"tx_cfg",mac_tx_cfg_h[i]);
     end 
   
   endfunction 

endclass

`endif
