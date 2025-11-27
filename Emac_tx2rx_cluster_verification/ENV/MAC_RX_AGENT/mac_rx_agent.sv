`ifndef MAC_RX_AGENT
`define MAC_RX_AGENT
 
class mac_rx_agent extends uvm_agent;
   `uvm_component_utils(mac_rx_agent)
    mac_rx_monitor mac_rx_mon;
    mac_rx_cfg mac_rx_config;
    function new (string name="",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase (uvm_phase phase);
    	 super.build_phase (phase);
      if(!uvm_config_db #(mac_rx_cfg)::get(this,"","rx_cfg",mac_rx_config))
        `uvm_fatal(get_full_name(),"try again ! master agent config mode not available")

       mac_rx_mon=mac_rx_monitor::type_id::create("mac_rx_mon",this);
    endfunction
    function void connect_to_axis_slave_mon(axi_str_slv_agent axis_slv_agent);
       axis_slv_agent.slave_mon.item_collected_port.connect(mac_rx_mon.mac_rx_mon_get_fifo.analysis_export);
    endfunction
endclass
`endif
