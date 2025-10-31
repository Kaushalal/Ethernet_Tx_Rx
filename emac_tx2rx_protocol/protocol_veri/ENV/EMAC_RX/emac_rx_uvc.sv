`ifndef EMAC_RX_UVC_SV
`define EMAC_RX_UVC_SV

class emac_rx_uvc#(
	int PAYLOAD_DATA_WIDTH = 8,
	int FRAME_DATA_WIDTH   = 32) extends uvm_agent; 
 
   //config settings
   emac_rx_config rx_cfg;
   emac_rx_config rx_config[];

   //agent 
	emac_rx_agent#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) rx_agent[];

  `uvm_component_param_utils_begin(emac_rx_uvc#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH))
  `uvm_component_utils_end 
   
   function new (string name="emac_rx_uvc", uvm_component parent=null); 
      super.new(name,parent); 
   endfunction: new 
   
   function void build_phase(uvm_phase phase);
      if (!uvm_config_db#(emac_rx_config)::get(this,"","no_ports",rx_cfg)) begin
    		`uvm_warning(get_full_name(), "rx_cfg not found in config_db , using default configuration")
    		rx_cfg = emac_rx_config::type_id::create("default_rx_cfg");
    		rx_cfg.no_of_ports = 1;
 	 	end

		rx_config = new[rx_cfg.no_of_ports];
		rx_agent = new[rx_cfg.no_of_ports];

      foreach(rx_agent[i]) begin
			rx_agent[i] = emac_rx_agent#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)::type_id::create($sformatf("rx_agent[%0d]",i),this);
			rx_config[i] = emac_rx_config::type_id::create($sformatf("rx_config[%0d]",i),this);
			rx_config[i].id = i;
			rx_config[i].no_of_ports = rx_cfg.no_of_ports; 
			uvm_config_db#(emac_rx_config)::set(uvm_root::get(),$sformatf("*rx_agent[%0d]*",i),"rx_cfg",rx_config[i]);
		end
   endfunction : build_phase
	
endclass : emac_rx_uvc

`endif

