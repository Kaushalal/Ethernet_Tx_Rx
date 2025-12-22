`ifndef AXI_LITE_MAS_AGENT
`define AXI_LITE_MAS_AGENT

class axi_lite_mas_agent extends uvm_agent;
  axi_lite_mas_sequencer#(ADDR_WIDTH,DATA_WIDTH)      m_seqr;
  axi_lite_mas_driver#(ADDR_WIDTH,DATA_WIDTH)         m_drv;
  axi_lite_mas_monitor#(ADDR_WIDTH,DATA_WIDTH)        m_mon;
  
  `uvm_component_utils(axi_lite_mas_agent)
  
  function new (string name="",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
      m_seqr=axi_lite_mas_sequencer#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("m_seqr",this);
      m_drv=axi_lite_mas_driver#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("s_drv",this);
      m_mon=axi_lite_mas_monitor#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("s_mon",this);
	endfunction
  
  	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

      m_drv.seq_item_port.connect(m_seqr.seq_item_export);
	endfunction

endclass
`endif
