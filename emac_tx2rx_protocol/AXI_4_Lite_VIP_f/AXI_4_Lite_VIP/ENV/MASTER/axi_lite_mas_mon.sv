`ifndef AXI_LITE_MAS_MON
`define AXI_LITE_MAS_MON

class axi_lite_mas_mon#(int ADDR_WIDTH, int DATA_WIDTH) extends uvm_monitor;

	virtual axi_lite_mas_inf vif;
  	uvm_analysis_port#(axi_lite_mas_seqs_item#(ADDR_WIDTH,DATA_WIDTH)) mon_put_port;

	`uvm_component_param_utils(axi_lite_mas_mon#(ADDR_WIDTH,DATA_WIDTH))
    
  	function new (string name="axi_lite_mas_mon",uvm_component parent=null);
   	super.new(name,parent);
    	mon_put_port=new("mon_put_port",this);
  	endfunction : new
  
  	function void build_phase (uvm_phase phase);
		super.build_phase (phase);
      if (!uvm_config_db#(virtual axi_lite_mas_inf)::get(this, "", "vif", vif)) begin
      	`uvm_fatal("NO_VIF", "Failed to get virtual interface from config_db")
      end
   endfunction : build_phase
  
   task run_phase (uvm_phase phase);
		super.run_phase (phase);
   endtask : run_phase
  
endclass : axi_lite_mas_mon
`endif
