`ifndef EMAC_TX_UVC_SV
`define EMAC_TX_UVC_SV

class emac_tx_uvc#(
	PAYLOAD_DATA_WIDTH = 8,
	FRAME_DATA_WIDTH   = 32) extends uvm_agent; 
 
   //config settings
   emac_tx_config tx_cfg;
   emac_tx_config tx_config[];

   //agent 
	emac_tx_agent#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) tx_agent[];

  `uvm_component_param_utils_begin(emac_tx_uvc#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH))
  `uvm_component_utils_end 
   
   function new (string name="emac_tx_uvc", uvm_component parent=null); 
      super.new(name,parent); 
   endfunction: new 
   
   function void build_phase(uvm_phase phase);
     	if (!uvm_config_db#(emac_tx_config)::get(this, "", "no_ports", tx_cfg)) begin
    		`uvm_warning(get_full_name(), "tx_cfg not found in config_db , using default configuration")
    		tx_cfg = emac_tx_config::type_id::create("default_tx_cfg");
    		tx_cfg.no_of_ports = 1;
    		tx_cfg.is_active   = UVM_ACTIVE;
 	 	end

		tx_config = new[tx_cfg.no_of_ports];
		tx_agent =  new[tx_cfg.no_of_ports];

      foreach(tx_agent[i]) begin
			tx_agent[i] = emac_tx_agent#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)::type_id::create($sformatf("tx_agent[%0d]",i),this);
			tx_config[i] = emac_tx_config::type_id::create($sformatf("tx_config[%0d]",i),this);
			tx_config[i].id = i;
			tx_config[i].is_active = tx_cfg.is_active;   
   	   tx_config[i].no_of_ports = tx_cfg.no_of_ports;
			uvm_config_db#(emac_tx_config)::set(uvm_root::get(),$sformatf("*tx_agent[%0d]*",i),"tx_cfg",tx_config[i]);
		end
   endfunction : build_phase
	
endclass : emac_tx_uvc

`endif

