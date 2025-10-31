`ifndef AXI_LITE_MAS_AGENT
`define AXI_LITE_MAS_AGENT

class axi_lite_mas_agent extends uvm_agent;

	axi_lite_mas_cfg m_cfg;
  	axi_lite_mas_seqr#(ADDR_WIDTH,DATA_WIDTH) m_seqr;
  	axi_lite_mas_drv#(ADDR_WIDTH,DATA_WIDTH)  m_drv;
  	axi_lite_mas_mon#(ADDR_WIDTH,DATA_WIDTH)  m_mon;
	 
  `uvm_component_utils(axi_lite_mas_agent)
  
	function new (string name="axi_lite_mas_agent",uvm_component parent=null);
   	super.new(name,parent);
  	endfunction : new
  
  	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
      
      if(!uvm_config_db #(axi_lite_mas_cfg)::get(this,"","m_cfg",m_cfg))
      	`uvm_fatal(get_full_name(),"try again ! master agent config mode not available")
        
      if(m_cfg.is_active == UVM_ACTIVE)begin
     		m_seqr=axi_lite_mas_seqr#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("m_seqr",this);
      	m_drv=axi_lite_mas_drv#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("s_drv",this);
      end
      
		m_mon=axi_lite_mas_mon#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("s_mon",this);
	endfunction : build_phase
  
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
   	if(m_cfg.is_active == UVM_ACTIVE)begin
      	m_drv.seq_item_port.connect(m_seqr.seq_item_export);
   	end
	endfunction : connect_phase

endclass : axi_lite_mas_agent
`endif
