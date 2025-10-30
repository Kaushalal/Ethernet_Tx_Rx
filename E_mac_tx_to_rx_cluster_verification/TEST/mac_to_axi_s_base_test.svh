/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : mac_to_axi_s_base_test.sv

* Purpose : build and run sequence

* Creation Date : 07-10-2025

* Last Modified :

* Created By : Muskan Thakur

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef MAC_TO_AXI_S_BASE_TEST_SV
`define MAC_TO_AXI_S_BASE_TEST_SV

class mac_to_axi_s_base_test extends uvm_test; 
  
  mac_to_axi_s_env_cfg env_cfg_h;
  mac_to_axi_s_env env_h;
  
  axi_str_mas_base_seqs#(32,32) master_seq;

  `uvm_component_utils(mac_to_axi_s_base_test) 
   
   function new (string name="axi_str_mas_base_test", uvm_component parent=null); 
      super.new(name,parent); 
   endfunction:new 

////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////
////                    BUILD PHASE 
////----------------------------------------------------------------------////
////----------------------------------------------------------------------////
                  
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     
     //// ENV and its config 
     env_h = mac_to_axi_s_env::type_id::create("env_h",this);
     env_cfg_h = mac_to_axi_s_env_cfg::type_id::create("env_cfg_h");
     
     //// Base seqs of master axi_str agent 
     master_seq = axi_str_mas_base_seqs#(32,32) ::type_id::create("master_seq");

     //// AXI_STR master config for ENV 
     env_cfg_h.mas_axi_s_config.no_of_axis_mas = 3;
     env_cfg_h.mas_axi_s_config.is_active = UVM_ACTIVE;
     
     //// AXI_STR slave config for ENV
     env_cfg_h.slv_axi_s_config.no_of_axis_slv = 3;
     env_cfg_h.slv_axi_s_config.is_active = UVM_PASSIVE;
     
     //// MAC_tx config for ENV
     env_cfg_h.mac_tx_cfg_h.no_of_tx_agent = 3;
     env_cfg_h.mac_tx_cfg_h.is_active = UVM_ACTIVE;
     
     //// AXI_4_config for ENV
     env_cfg_h.axi_4_mcfg_h.magt_is_active = UVM_ACTIVE;
     env_cfg_h.axi_4_mcfg_h.no_of_agent = 1;
     uvm_config_db #(mac_to_axi_s_env_cfg)::set(this,"*", "env_cfg", env_cfg_h);
   
   endfunction : build_phase

////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////
////           END_OF_ELABORATION PHASE (topology)
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////
   
   function void end_of_elaboration_phase(uvm_phase phase);
     uvm_top.print_topology(); 
   endfunction : end_of_elaboration_phase

////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////
////                    RUN PHASE 
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////
	
    task run_phase(uvm_phase phase);
		phase.raise_objection(this);
	       master_seq.start(env_h.axi_str_muvc_h.master_agent[0].master_seqr);
		phase.drop_objection(this);
	endtask

endclass : mac_to_axi_s_base_test

`endif
