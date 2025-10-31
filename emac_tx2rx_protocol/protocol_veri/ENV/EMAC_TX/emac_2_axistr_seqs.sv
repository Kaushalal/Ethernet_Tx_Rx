`ifndef EMAC_2_AXISTR_SEQS_SV
`define EMAC_2_AXISTR_SEQS_SV

class emac_2_axistr_seqs#(
	int PAYLOAD_DATA_WIDTH = 8,
	int FRAME_DATA_WIDTH = 32
	) extends axi_str_mas_base_seqs;
  
	uvm_sequencer#(emac_tx_seqs_item)  							  up_seqr;
  	emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) tx_seqs_item;
  
  	`uvm_object_param_utils_begin(emac_2_axistr_seqs#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH))
	`uvm_object_utils_end
  
  	function new(string name = "emac_2_axistr_seqs");
   	super.new(name);
  	endfunction : new
 
  	task body();
    	forever begin
      	up_seqr.get_next_item(tx_seqs_item);
			`uvm_create(req)
      	emac2axistream_frame();
			`uvm_info(get_full_name(),$sformatf("%0s",tx_seqs_item.sprint()),UVM_MEDIUM)
      	start_item(req);
			#20;
      	if (!req.randomize() with {foreach(tx_seqs_item.frame[i]) { tdata_q[i] == tx_seqs_item.frame[i]; }
																							total_bytes == tx_seqs_item.total_bytes; })
        		`uvm_error(get_full_name(),"Randomization failed");
      	finish_item(req);
      	up_seqr.item_done();
    	end
  	endtask : body

	function void emac2axistream_frame();	
    	tx_seqs_item.frame = {>>{tx_seqs_item.dest_mac_addr,
										 tx_seqs_item.source_mac_addr,
										 tx_seqs_item.tci,
										 tx_seqs_item.e_type,
										 tx_seqs_item.payload,
										 tx_seqs_item.fcs}};
		tx_seqs_item.total_bytes = 20 + tx_seqs_item.payload.size();
		tx_seqs_item.pkt_len = (tx_seqs_item.total_bytes%4)==0 ? (tx_seqs_item.total_bytes/4) : ((tx_seqs_item.total_bytes/4)+1);	
	endfunction : emac2axistream_frame

endclass : emac_2_axistr_seqs

`endif   
