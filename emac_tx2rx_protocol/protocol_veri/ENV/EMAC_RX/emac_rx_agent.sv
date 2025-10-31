`ifndef EMAC_RX_AGENT_SV
`define EMAC_RX_AGENT_SV

class emac_rx_agent#(
	int PAYLOAD_DATA_WIDTH = 8,
	int FRAME_DATA_WIDTH   = 32) extends uvm_agent;
 
	emac_rx_mon#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) rx_mon;
	emac_rx_config     										  rx_cfg;
  
  	`uvm_component_param_utils_begin(emac_rx_agent#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH))
	`uvm_component_utils_end
  
  	function new(string name="emac_rx_agent",uvm_component parent=null);
   	super.new(name,parent);
  	endfunction : new
  
  	function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    	if(!uvm_config_db#(emac_rx_config)::get(this,"","rx_cfg",rx_cfg))
			`uvm_fatal(get_full_name(),"unable to retrieve mac_rx_config")
		rx_mon = emac_rx_mon#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)::type_id::create("rx_mon",this);
  	endfunction : build_phase

  	task run_phase(uvm_phase phase);
   	super.run_phase(phase);
  	endtask : run_phase
  
  	function void connect_to_axi_str_slv_agnt(axi_str_slv_agent #(DATA_SIZE,USER_SIZE) str_slv_agnt);
		str_slv_agnt.slave_mon.item_collected_port.connect(this.rx_mon.item_collected_imp);
		`uvm_info(get_full_name(),"Successfully connected to axiStream master monitor.........................",UVM_DEBUG)
  	endfunction : connect_to_axi_str_slv_agnt

endclass : emac_rx_agent 

`endif 
