`ifndef EMAC_TX_AGENT_SV
`define EMAC_TX_AGENT_SV

class emac_tx_agent#(
	int PAYLOAD_DATA_WIDTH = 8,
	int FRAME_DATA_WIDTH   = 32
	) extends uvm_agent;
  
	emac_tx_seqr#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) 		tx_seqr;
	emac_2_axistr_seqs#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) conv_seqs;
	emac_tx_mon#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) 		   tx_mon;
	emac_tx_config     												   tx_cfg;
  
  	uvm_sequencer#(axi_str_mas_seq_item#(DATA_SIZE,USER_SIZE)) axi_mas_seqr;
 
  	`uvm_component_param_utils_begin(emac_tx_agent#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH))
	`uvm_component_utils_end
  
  	function new(string name="emac_tx_agent",uvm_component parent=null);
   	super.new(name,parent);
  	endfunction : new
  
  	function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
		conv_seqs = emac_2_axistr_seqs#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)::type_id::create("conv_seqs");	
    	if(!uvm_config_db#(emac_tx_config)::get(this,"","tx_cfg",tx_cfg))
			`uvm_fatal(get_full_name(),"unable to retrieve mac_tx_config")
		if(tx_cfg.is_active == UVM_ACTIVE) begin
			tx_seqr = emac_tx_seqr#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)::type_id::create("tx_seqr",this);
    		if (!$cast(conv_seqs.up_seqr,tx_seqr))
      		`uvm_fatal(get_full_name(),"Casting Failed!!!")
		end
		tx_mon = emac_tx_mon#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)::type_id::create("tx_mon",this);
  	endfunction : build_phase
  
  	task run_phase(uvm_phase phase);
   	super.run_phase(phase);
    	conv_seqs.start(axi_mas_seqr);
  	endtask : run_phase
  
  	function void connect_to_axi_str_mas_agnt(axi_str_mas_agent#(DATA_SIZE,USER_SIZE) str_mas_agent);
    	if (tx_cfg.is_active == UVM_ACTIVE) begin
			this.axi_mas_seqr=str_mas_agent.master_seqr;
						`uvm_info(get_full_name(),"Successfully connected to axiStream master sequencer.........................",UVM_DEBUG)
		end
		str_mas_agent.master_mon.item_collected_port.connect(this.tx_mon.item_collected_imp);
  	endfunction : connect_to_axi_str_mas_agnt

endclass : emac_tx_agent 

`endif 
