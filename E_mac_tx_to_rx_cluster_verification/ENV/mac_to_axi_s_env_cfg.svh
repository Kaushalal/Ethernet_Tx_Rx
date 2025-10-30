/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = mac_to_axi_s_cfg.svh
//  ENGINEER  = Muskan
//  VERSION   = 1.0 
//  DESCRIPTION =  
//
/////////////////////////////////////////////////////

`ifndef MAC_TO_AXI_S_CFG
`define MAC_TO_AXI_S_CFG

class mac_to_axi_s_env_cfg extends uvm_object;

   //// Config class of mac_tx agent
   mac_tx_cfg mac_tx_cfg_h;

   //// Config class of axi_stream 
   axi_str_mas_config mas_axi_s_config; 
   axi_str_slv_config slv_axi_s_config;
 
   //// AXI_4 config
   axi_magt_cfg axi_4_mcfg_h;

  `uvm_object_utils_begin(mac_to_axi_s_env_cfg)
  `uvm_object_utils_end

   function new (string name = "mac_to_axi_s_env_cfg");
      super.new(name);
      mas_axi_s_config = axi_str_mas_config::type_id::create("mas_axi_s_config");
      slv_axi_s_config = axi_str_slv_config::type_id::create("slv_axi_s_config");
      
      mac_tx_cfg_h = mac_tx_cfg ::type_id::create("mac_tx_cfg_h");
      
      axi_4_mcfg_h = axi_magt_cfg ::type_id::create("axi_4_mcfg_h");
   endfunction

   
endclass 

`endif

