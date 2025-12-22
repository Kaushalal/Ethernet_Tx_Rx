/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = mac_to_axi_s_env.svh
//  ENGINEER  = Muskan
//  VERSION   = 1.0 
//  DESCRIPTION = responsible to generate multiple agents and all the components  
//
/////////////////////////////////////////////////////

`ifndef MAC_TO_AXI_S_ENV
`define MAC_TO_AXI_S_ENV

class mac_to_axi_s_env extends uvm_env;

  `uvm_component_utils(mac_to_axi_s_env)
  
   //// All uvc's of project  
   axi_str_slv_uvc axi_str_suvc_h;
   axi_str_mas_uvc axi_str_muvc_h;
   
   mac_tx_uvc mac_tx_uvc_h;
   mac_rx_uvc mac_rx_uvc_h; 
   
   axi_4_muvc axi_4_muvc_h;
   
   //// Config class of axi_stream 
   axi_str_mas_config mas_axi_s_config; 
   axi_str_slv_config slv_axi_s_config;
   
   //// Config class of mac_tx 
   mac_tx_cfg mac_tx_cfg_h;
   
   //// Config class of mac_rx 
   emac_rx_config mac_rx_cfg_h;

   ////Config class of env
   mac_to_axi_s_env_cfg env_cfg_h;
   
   //// Virtual Sequencer 
   mac_to_axi_s_virtual_seqr vseqr_h;

   //// RAL adapter 
   axi_4_adapter #(`AXI_4_DATA_SIZE,`AXI_4_ADD_SIZE) axi_4_ral_adapter_h;

   //// REG block
   axi_4_reg_block axi_4_reg_block_h;

   //// AXI_4 config
   axi_magt_cfg axi_4_mcfg_h;
   
 //// REF_MODEL and SCORE_BOARD 
   emac_tx2rx_scrbd                   mac_tx_to_rx_scrbrd_h;
   emac_tx2rx_ref_model               mac_tx_to_rx_ref;
  
  // payload_coverage
  emac_tx_to_rx_coverage emac_cvg;

////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////
////    NEW 
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////
   
   function new (string name = "axi_env", uvm_component parent = null);
      super.new(name,parent);
   endfunction

////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////
////                    BUILD PHASE 
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
  
    mac_tx_to_rx_scrbrd_h = emac_tx2rx_scrbd::type_id::create("mac_tx_to_rx_scrbrd_h",this);
     mac_tx_to_rx_ref    = emac_tx2rx_ref_model::type_id::create("mac_tx_to_rx_ref",this);
     uvm_config_db#(int)::set(this,"*","ref_type",0);
      
      //// All uvc's
      axi_str_suvc_h = axi_str_slv_uvc::type_id::create("axi_str_suvc_h",this);
      axi_str_muvc_h = axi_str_mas_uvc::type_id::create("axi_str_muvc_h",this);
      
      axi_4_muvc_h = axi_4_muvc::type_id::create("axi_4_muvc_h",this);
      
      mac_tx_uvc_h = mac_tx_uvc::type_id::create("mac_tx_uvc_h",this);
      mac_rx_uvc_h = mac_rx_uvc::type_id::create("mac_rx_uvc_h",this);
     
     //// Virtual sequencer 
     vseqr_h = mac_to_axi_s_virtual_seqr::type_id::create("vseqr_h",this);

     //// Getting env config 
      if(!uvm_config_db #(mac_to_axi_s_env_cfg)::get(this,"","env_cfg",env_cfg_h))
        `uvm_warning(get_full_name(),"ENV_CFG failed to get")
     
     //// AXI_Stream Config class
     mas_axi_s_config = axi_str_mas_config::type_id::create("mas_axi_s_config");
     slv_axi_s_config = axi_str_slv_config::type_id::create("slv_axi_s_config");
     
     //// Setting config for no_of_axi_stream_agents and there type 
     mas_axi_s_config.no_of_axis_mas = env_cfg_h.mas_axi_s_config.no_of_axis_mas;
     mas_axi_s_config.is_active = env_cfg_h.mas_axi_s_config.is_active;
     
     uvm_config_db #(axi_str_mas_config)::set(this,"*", "no_master", mas_axi_s_config);
     
     slv_axi_s_config.no_of_axis_slv = env_cfg_h.slv_axi_s_config.no_of_axis_slv;
     slv_axi_s_config.is_active = env_cfg_h.slv_axi_s_config.is_active;
     
     uvm_config_db #(axi_str_slv_config)::set(this,"*", "no_slave", slv_axi_s_config);

     //// MAC_tx Config class
     mac_tx_cfg_h = mac_tx_cfg ::type_id::create("mac_tx_cfg_h");
     
     //// MAC_rx Config class
    mac_rx_cfg_h = emac_rx_config ::type_id::create("mac_rx_cfg_h");
     
     //// Setting config for no_of_mac_tx_agent and there type 
     mac_tx_cfg_h.no_of_tx_agent = env_cfg_h.mac_tx_cfg_h.no_of_tx_agent;
     mac_tx_cfg_h.is_active = env_cfg_h.mac_tx_cfg_h.is_active;
     
     uvm_config_db #(mac_tx_cfg)::set(this,"*", "no_tx_agent", mac_tx_cfg_h);
     
     //// Setting config for no_of_mac_rx_agent and there type 
     mac_rx_cfg_h.no_of_ports = env_cfg_h.mac_rx_cfg_h.no_of_ports;
     
     uvm_config_db #(emac_rx_config)::set(this,"*", "no_ports", mac_rx_cfg_h);

     //// AXI_4 agent for register  
     axi_4_mcfg_h = axi_magt_cfg::type_id::create("axi_4_mcfg_h");
     axi_4_mcfg_h.magt_is_active = env_cfg_h.axi_4_mcfg_h.magt_is_active;
     axi_4_mcfg_h.no_of_agent = env_cfg_h.axi_4_mcfg_h.no_of_agent;
     uvm_config_db #(axi_magt_cfg)::set(this,"*", "mcfg_h", axi_4_mcfg_h);
     
     //// AXI_4 RAL adapter 
     axi_4_ral_adapter_h = axi_4_adapter#(`AXI_4_DATA_SIZE,`AXI_4_ADD_SIZE)::type_id::create("axi_4_ral_adapter_h",this);
     
     //// AXI_4 RAL reg_block
     axi_4_reg_block_h = axi_4_reg_block::type_id::create("axi_4_reg_block",this);
     axi_4_reg_block_h.build();
     
     // emac coverage
     emac_cvg = emac_tx_to_rx_coverage::type_id::create("emac_cvg");
   endfunction

////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////
////                CONNECT PHASE 
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////

   function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);

      //                  ------   SCOREBOARD CONNECTION AND REF_MODEL CONNECTION

      foreach( mac_rx_uvc_h.rx_agent[i] )  mac_rx_uvc_h.rx_agent[i].rx_mon.rxmon_analysis_port.connect(mac_tx_to_rx_scrbrd_h.act_frame_mon_port[i]);
      //foreach( axi_str_suvc_h.slave_agent[i]) axi_str_suvc_h.slave_agent[i].slave_mon.item_collected_port.connect(mac_tx_to_rx_scrbrd_h.act_tdata_mon_port[i]);
      axi_str_suvc_h.slave_agent[0].slave_mon.item_collected_port.connect(mac_tx_to_rx_scrbrd_h.act_tdata_mon_port0);
      axi_str_suvc_h.slave_agent[1].slave_mon.item_collected_port.connect(mac_tx_to_rx_scrbrd_h.act_tdata_mon_port1);
      axi_str_suvc_h.slave_agent[2].slave_mon.item_collected_port.connect(mac_tx_to_rx_scrbrd_h.act_tdata_mon_port2);

      foreach( mac_tx_to_rx_ref.frame_scrbd_port[i])mac_tx_to_rx_ref.frame_scrbd_port[i].connect(mac_tx_to_rx_scrbrd_h.exp_frame_ref_port[i]);
      //foreach( mac_tx_to_rx_ref.tdata_scrbd_port[i])mac_tx_to_rx_ref.tdata_scrbd_port[i].connect(mac_tx_to_rx_scrbrd_h.exp_tdata_ref_port[i]);
      mac_tx_to_rx_ref.tdata_scrbd_port[0].connect(mac_tx_to_rx_scrbrd_h.exp_tdata_ref_port0);
      mac_tx_to_rx_ref.tdata_scrbd_port[1].connect(mac_tx_to_rx_scrbrd_h.exp_tdata_ref_port1);
      mac_tx_to_rx_ref.tdata_scrbd_port[2].connect(mac_tx_to_rx_scrbrd_h.exp_tdata_ref_port2);

       axi_str_muvc_h.master_agent[0].master_mon.item_collected_port.connect(mac_tx_to_rx_ref.tdata_port0_imp);
       axi_str_muvc_h.master_agent[1].master_mon.item_collected_port.connect(mac_tx_to_rx_ref.tdata_port1_imp);
       axi_str_muvc_h.master_agent[2].master_mon.item_collected_port.connect(mac_tx_to_rx_ref.tdata_port2_imp);
       
       mac_tx_uvc_h.mac_tx_agent_h[0].mac_tx_mon_h.mac_tx_mon_port.connect(mac_tx_to_rx_ref.frame_port0_imp);
       mac_tx_uvc_h.mac_tx_agent_h[1].mac_tx_mon_h.mac_tx_mon_port.connect(mac_tx_to_rx_ref.frame_port1_imp);
       mac_tx_uvc_h.mac_tx_agent_h[2].mac_tx_mon_h.mac_tx_mon_port.connect(mac_tx_to_rx_ref.frame_port2_imp);
     
       mac_tx_to_rx_ref.ral = axi_4_reg_block_h; 

   
     //// MAC_TX to AXI_STR sequencer connection 
     foreach( mac_tx_uvc_h.mac_tx_agent_h[i] )begin
       mac_tx_uvc_h.mac_tx_agent_h[i].connect_to_dut_agent(axi_str_muvc_h.master_agent[i]);
    end
     
     //// MAC_RX to AXI_STR sequencer connection 
    foreach( mac_rx_uvc_h.rx_agent[i]  )begin
       mac_rx_uvc_h.rx_agent[i].connect_to_axi_str_slv_agnt(axi_str_suvc_h.slave_agent[i]);
     //// axi_str_suvc_h.slave_agent[i].item_collected_port.connect(mac_tx_to_rx_scrbrd_h.act_mon_port[i]);
     end
    axi_str_suvc_h.slave_agent[0].slave_mon.item_collected_port.connect(mac_tx_to_rx_ref.acctual_tdata_port0_imp);
    axi_str_suvc_h.slave_agent[1].slave_mon.item_collected_port.connect(mac_tx_to_rx_ref.acctual_tdata_port1_imp);
    axi_str_suvc_h.slave_agent[2].slave_mon.item_collected_port.connect(mac_tx_to_rx_ref.acctual_tdata_port2_imp);
     //// Virtual sequencer connection 
     foreach ( vseqr_h.mac_tx_seqr_h[i] ) begin 
       vseqr_h.mac_tx_seqr_h[i] = mac_tx_uvc_h.mac_tx_agent_h[i].mac_tx_seqr_h; end  
     
     //// Set sequencer for Adapter 
     axi_4_reg_block_h.cfg_mem_map.set_sequencer(axi_4_muvc_h.axi_4_magent_h[0].mseqr_h, axi_4_ral_adapter_h);
     axi_4_reg_block_h.cfg_mem_map.set_base_addr('h4000);
     axi_4_reg_block_h.misc_reg_map.set_sequencer(axi_4_muvc_h.axi_4_magent_h[0].mseqr_h, axi_4_ral_adapter_h);
     axi_4_reg_block_h.misc_reg_map.set_base_addr('h3000);
     axi_4_reg_block_h.vcid_reg_map.set_sequencer(axi_4_muvc_h.axi_4_magent_h[0].mseqr_h, axi_4_ral_adapter_h);
     axi_4_reg_block_h.vcid_reg_map.set_base_addr('h2900);

     // need to connect the emac_cvg of ref and scoreboard
    mac_tx_to_rx_scrbrd_h.emac_cvg = emac_cvg;
    mac_tx_to_rx_ref.emac_cvg = emac_cvg;
  endfunction

endclass 

`endif


