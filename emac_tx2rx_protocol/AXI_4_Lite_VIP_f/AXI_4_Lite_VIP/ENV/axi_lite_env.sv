`ifndef AXI_LITE_ENV
`define AXI_LITE_ENV

class axi_lite_env extends uvm_env;
	
	axi_lite_mas_uvc    m_uvc;
  	axi_lite_mas_agent  m_agent;
	
	`uvm_component_utils(axi_lite_env)
  
  	function new(string name="axi_lite_env",uvm_component parent=null);
		super.new(name,parent);
	endfunction : new
  
  	function void build_phase (uvm_phase phase);
		super.build_phase (phase);
      m_uvc=axi_lite_mas_uvc::type_id::create("m_uvc",this);
  		m_agent=axi_lite_mas_agent::type_id::create("m_agent",this);
	endfunction : build_phase

   function void connect_phase(uvm_phase phase);
	endfunction : connect_phase

endclass : axi_lite_env
`endif
