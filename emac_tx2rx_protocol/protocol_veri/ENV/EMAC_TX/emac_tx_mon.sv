`ifndef EMAC_TX_MON_SV
`define EMAC_TX_MON_SV

class emac_tx_mon#(
	shortint PAYLOAD_DATA_WIDTH = 8,
	shortint FRAME_DATA_WIDTH   = 32) extends uvm_monitor;

	uvm_analysis_imp #(axi_str_mas_seq_item#(DATA_SIZE,USER_SIZE),
	 						  emac_tx_mon#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)) 		  item_collected_imp;
	uvm_analysis_port #(emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)) txmon_analysis_port;
	
	emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) tx_seqs_item;

	emac_tx_config tx_config;

	`uvm_component_param_utils_begin(emac_tx_mon#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH))
	`uvm_component_utils_end

	function new(string name = "emac_tx_mon",uvm_component parent = null);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		item_collected_imp  = new("item_collected_imp",this);
		txmon_analysis_port = new("txmon_analysis_port",this);
		if(!uvm_config_db#(emac_tx_config)::get(this,"","tx_cfg",tx_config))
			`uvm_fatal(get_full_name(),"unable to retrieve cfg settings for port_id")	
	endfunction : build_phase

	virtual function void write(axi_str_mas_seq_item #(DATA_SIZE,USER_SIZE) sampled_pkt);	
		axistream2emac_frame(sampled_pkt);
		//`uvm_info(get_full_name(),tx_seqs_item.sprint(),UVM_MEDIUM)	
	endfunction : write

	function void axistream2emac_frame(axi_str_mas_seq_item #(DATA_SIZE,USER_SIZE) sampled_pkt);
		tx_seqs_item = emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)::type_id::create("tx_seqs_item");
		foreach(sampled_pkt.tdata_q[i])
			`uvm_info(get_full_name,$sformatf("%h",sampled_pkt.tdata_q[i]),UVM_DEBUG)
		for(int i = 0;i < sampled_pkt.tdata_q.size()-1 ; i++)  //excludnig fcs
			tx_seqs_item.frame[i] = sampled_pkt.tdata_q[i];
		{>>{tx_seqs_item.dest_mac_addr,
     		 tx_seqs_item.source_mac_addr,
     		 {tx_seqs_item.vlan_id,tx_seqs_item.prior,tx_seqs_item.dei},
     		 tx_seqs_item.e_type,
     		 tx_seqs_item.payload}} = tx_seqs_item.frame;
		case(sampled_pkt.tkeep_q[$])
			4'b0001 : tx_seqs_item.fcs = {sampled_pkt.tdata_q[$-1][23:0],sampled_pkt.tdata_q[$][31:24]};
			4'b0011 : tx_seqs_item.fcs = {sampled_pkt.tdata_q[$-1][15:0],sampled_pkt.tdata_q[$][23:16]};
			4'b0111 : tx_seqs_item.fcs = {sampled_pkt.tdata_q[$-1][7:0],sampled_pkt.tdata_q[$][15:8]}; 
			default : tx_seqs_item.fcs = sampled_pkt.tdata_q[$];
		endcase  	
		tx_seqs_item.port_id = tx_config.id;
		txmon_analysis_port.write(tx_seqs_item);
	endfunction : axistream2emac_frame

endclass : emac_tx_mon

`endif 

