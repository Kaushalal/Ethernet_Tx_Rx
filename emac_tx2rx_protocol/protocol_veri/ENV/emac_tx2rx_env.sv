`ifndef EMAC_TX2RX_ENV_SV
`define EMAC_TX2RX_ENV_SV

class emac_tx2rx_env extends uvm_env;
  
  	emac_tx_uvc#(8,32)    		  tx_uvc;
	emac_rx_uvc#(8,32)    		  rx_uvc;
	axi_str_mas_uvc#(32,32)      str_mas_uvc; 
	axi_str_slv_uvc#(32,32)      str_slv_uvc; 
	emac_tx_config	      		  tx_cfg;
	emac_rx_config	      		  rx_cfg;
	emac_tx2rx_vseqr 		        vseqr;
	axi_lite_mas_uvc             lite_mas_uvc;
	emac_tx2rx_reg_block         reg_blk;
	axi_lite_reg_adapter#(32,32) adapter;

	emac_tx2rx_ref_model			  ref_model;
  
  	`uvm_component_utils_begin(emac_tx2rx_env)
	`uvm_component_utils_end
  
  	function new(string name="emac_tx2rx_env",uvm_component parent=null);
   	super.new(name,parent);
  	endfunction : new
  
  	function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
		vseqr = emac_tx2rx_vseqr::type_id::create("vseqr",this);
    	tx_uvc = emac_tx_uvc#(8,32)::type_id::create("tx_uvc",this);
    	rx_uvc = emac_rx_uvc#(8,32)::type_id::create("rx_uvc",this);
      str_mas_uvc = axi_str_mas_uvc#(32,32)::type_id::create("str_mas_uvc",this);
    	str_slv_uvc = axi_str_slv_uvc#(32,32)::type_id::create("str_slv_uvc",this);
		lite_mas_uvc = axi_lite_mas_uvc::type_id::create("lite_mas_uvc",this);
		reg_blk = emac_tx2rx_reg_block::type_id::create("reg_blk");
		adapter = axi_lite_reg_adapter#(32,32)::type_id::create("adapter");
		ref_model = emac_tx2rx_ref_model::type_id::create("ref_model",this);
		reg_blk.build();
		uvm_config_db#(emac_tx2rx_reg_block)::set(this,"*","reg_blk",reg_blk);
  	endfunction : build_phase
  
  	function void connect_phase(uvm_phase phase);
    	super.connect_phase(phase);
		uvm_config_db#(emac_tx_config)::get(this,"","no_ports",tx_cfg);
		uvm_config_db#(emac_rx_config)::get(this,"","no_ports",rx_cfg);
		for(int i = 0;i<tx_cfg.no_of_ports;i++)begin
    		tx_uvc.tx_agent[i].connect_to_axi_str_mas_agnt(str_mas_uvc.master_agent[i]);
			vseqr.tx_seqr[i] = tx_uvc.tx_agent[i].tx_seqr;
			tx_uvc.tx_agent[i].tx_mon.txmon_analysis_port.connect(ref_model.txmon_analysis_imp);
		end
		for(int i = 0;i<rx_cfg.no_of_ports;i++)begin
    		rx_uvc.rx_agent[i].connect_to_axi_str_slv_agnt(str_slv_uvc.slave_agent[i]);
		end
		reg_blk.config_reg_map.set_sequencer(lite_mas_uvc.axi_lite_m_agent[0].m_seqr,adapter);
		reg_blk.misc_reg_map.set_sequencer(lite_mas_uvc.axi_lite_m_agent[0].m_seqr,adapter);	
	endfunction : connect_phase
  
endclass : emac_tx2rx_env

`endif 
