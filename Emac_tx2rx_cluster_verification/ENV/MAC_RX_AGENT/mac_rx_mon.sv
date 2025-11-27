/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-

*	File_Name     : emac_rx_mon.sv
*	Purpose       : To monitor received Ethernet frames in the EMAC RX agent, 
						 convert incoming AXI-Stream data into EMAC RX sequence items, 
						 and provide these items to other UVM components for analysis 
						 or verification.
*  Created By    : Meet_Patel

-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-. */

`ifndef EMAC_RX_MON_SV
`define EMAC_RX_MON_SV

class emac_rx_mon#(
	int PAYLOAD_DATA_WIDTH = 8,
	int FRAME_DATA_WIDTH   = 32) extends uvm_monitor ; 

	uvm_analysis_imp #(axi_str_slv_seq_item #(DATA_SIZE,USER_SIZE),emac_rx_mon)  item_collected_imp;
	uvm_analysis_port #(emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)) rxmon_analysis_port;

	emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) rx_seqs_item;

  `uvm_component_param_utils_begin(emac_rx_mon#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH))
  `uvm_component_utils_end 
   
	function new (string name="emac_rx_mon", uvm_component parent=null); 
   	super.new(name,parent); 
   endfunction: new 

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		item_collected_imp  = new("item_collected_imp",this);	
		rxmon_analysis_port = new("rxmon_analysis_port",this);	
	endfunction : build_phase
 
	virtual function void write(axi_str_slv_seq_item #(DATA_SIZE,USER_SIZE) sampled_pkt);
		axistream2emac_frame(sampled_pkt);
		`uvm_info(get_full_name(),sampled_pkt.sprint(),UVM_DEBUG)
	endfunction : write

	function void axistream2emac_frame(axi_str_slv_seq_item #(DATA_SIZE,USER_SIZE) sampled_pkt);
		rx_seqs_item = emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)::type_id::create("rx_seqs_item");
		for(int i = 0;i < sampled_pkt.tdata_q.size()-1 ; i++)  //excluding fcs
			rx_seqs_item.frame[i] = {<<8{sampled_pkt.tdata_q[i]}};
		`uvm_info(get_full_name(),$sformatf("frame size = %0d",rx_seqs_item.frame.size()),UVM_DEBUG)
		if(rx_seqs_item.frame.size() != 0) begin
			{>>{rx_seqs_item.dest_mac_addr,
				rx_seqs_item.source_mac_addr,
				rx_seqs_item.vcid,
				rx_seqs_item.e_type,
				rx_seqs_item.payload}} = rx_seqs_item.frame;
		case(sampled_pkt.tkeep_q[$])
			4'b0001 : repeat(3) void'(rx_seqs_item.payload.pop_back());
			4'b0011 : repeat(2) void'(rx_seqs_item.payload.pop_back());
			4'b0111 : void'(rx_seqs_item.payload.pop_back());
		endcase 
		end
		`uvm_info(get_full_name(),rx_seqs_item.sprint(),UVM_MEDIUM)
		rxmon_analysis_port.write(rx_seqs_item);
	endfunction : axistream2emac_frame

endclass : emac_rx_mon

`endif
