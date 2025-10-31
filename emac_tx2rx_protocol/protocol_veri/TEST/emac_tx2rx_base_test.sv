`ifndef EMAC_TX2RX_BASE_TEST_SV
`define EMAC_TX2RX_BASE_TEST_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class emac_tx2rx_base_test extends uvm_test;
    
	emac_tx2rx_env 	 env;
	emac_tx_config 	 tx_cfg;
	emac_rx_config 	 rx_cfg;
  	axi_str_mas_config mas_cfg;
	axi_str_slv_config slv_cfg;
	axi_lite_mas_cfg 	 mas_config;

  	`uvm_component_utils(emac_tx2rx_base_test)
  
  	function new(string name="emac_tx2rx_base_test",uvm_component parent=null);
    	super.new(name,parent);
  	endfunction : new
   
  	function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    	env = emac_tx2rx_env::type_id::create("env",this);
		
		/*----------------------------------------------------------------------------------------
			 				                 CONFIGURATION FOR MAC_TX	
		----------------------------------------------------------------------------------------*/
		tx_cfg = emac_tx_config::type_id::create("tx_cfg");
		tx_cfg.no_of_ports = 3;
		uvm_config_db#(emac_tx_config)::set(this,"*","no_ports",tx_cfg);

		/*----------------------------------------------------------------------------------------
			 				                 CONFIGURATION FOR MAC_TX	
		----------------------------------------------------------------------------------------*/
		rx_cfg = emac_rx_config::type_id::create("rx_cfg");
		rx_cfg.no_of_ports = 3;
		uvm_config_db#(emac_rx_config)::set(this,"*","no_ports",rx_cfg);

		/*----------------------------------------------------------------------------------------
			 				             CONFIGURATION FOR AXI_STREAM_MASTER	
		----------------------------------------------------------------------------------------*/
      mas_cfg = axi_str_mas_config::type_id::create("mas_cfg");
      mas_cfg.no_of_axis_mas = 3;
      uvm_config_db #(axi_str_mas_config)::set(this,"*str_mas_uvc*","no_master",mas_cfg);
      uvm_config_db #(axi_str_mas_config)::set(this,"*str_mas_uvc*","m_cfg",mas_cfg);

		/*----------------------------------------------------------------------------------------
			 				             CONFIGURATION FOR AXI_STREAM_SLAVE	
		----------------------------------------------------------------------------------------*/
		slv_cfg = axi_str_slv_config::type_id::create("slv_cfg");
		slv_cfg.no_of_axis_slv = 3;
		uvm_config_db #(axi_str_slv_config)::set(this,"*str_slv_uvc*","no_slave",slv_cfg);
      uvm_config_db #(axi_str_slv_config)::set(this,"*str_slv_uvc*","s_cfg",slv_cfg);

		/*----------------------------------------------------------------------------------------
			 				             CONFIGURATION FOR AXI4_LITE_MASTER	
		----------------------------------------------------------------------------------------*/
		mas_config = axi_lite_mas_cfg::type_id::create("mas_config");
		mas_config.no_of_axi_lite_mas=1;
      uvm_config_db #(axi_lite_mas_cfg)::set(this,"*","no_master",mas_config);
		uvm_config_db #(axi_lite_mas_cfg)::set(this,"*","m_cfg",mas_config);

  	endfunction : build_phase

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction : end_of_elaboration_phase
   
endclass : emac_tx2rx_base_test

`endif 
