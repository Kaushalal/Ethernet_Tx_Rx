`ifndef AXI_LITE_MAS_MONITOR
`define AXI_LITE_MAS_MONITOR

class axi_lite_mas_monitor#(int ADDR_WIDTH, int DATA_WIDTH) extends uvm_monitor;
  `uvm_component_param_utils(axi_lite_mas_monitor#(ADDR_WIDTH,DATA_WIDTH))
  
  virtual axi_lite_mas_interface vif;
  uvm_analysis_port#(axi_lite_mas_sequence_item#(ADDR_WIDTH,DATA_WIDTH)) mon_put_port;
  
  function new (string name="",uvm_component parent);
    super.new(name,parent);
    mon_put_port=new("mon_put_port",this);
  endfunction
  
  	function void build_phase (uvm_phase phase);
		super.build_phase (phase);
      if (!uvm_config_db#(virtual axi_lite_mas_interface)::get(this, "", "vif", vif)) begin
               `uvm_fatal("NO_VIF", "Failed to get virtual interface from config_db")
       end
       endfunction
  
        task run_phase (uvm_phase phase);
	       super.run_phase (phase);
       endtask
  

  
endclass
`endif