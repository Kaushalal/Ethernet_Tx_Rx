`ifndef EMAC_TX_SEQS_SV
`define EMAC_TX_SEQS_SV

class emac_tx_seqs#(
	shortint PAYLOAD_DATA_WIDTH = 8,
	shortint FRAME_DATA_WIDTH   = 32
	) extends uvm_sequence#(emac_tx_seqs_item#(
									.PAYLOAD_DATA_WIDTH(PAYLOAD_DATA_WIDTH),
									.FRAME_DATA_WIDTH(FRAME_DATA_WIDTH)));

	//TCI  control information
	rand bit [11:0] vlan_idd; 
	rand bit [2:0]  priorr;
	rand bit 	    deii; //Drop Eligible Indicator
	
	rand bit [23:0] e_typee;		//8100,0800 : supported
	
	rand bit [31:0] minn,maxx;

	constraint payload_len_c{		//payload length supported min:46 | max:1500
		soft minn == 46;
		soft maxx == 1500;
	} 

	constraint e_type_c{
		soft e_typee inside {8100,0800};		  
	}

	`uvm_object_param_utils_begin(emac_tx_seqs#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH))
	`uvm_object_utils_end
  
  	function new(string name = "emac_tx_seqs");
   	super.new(name);
  	endfunction : new
  
  	task body();
    	req = emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)::type_id::create("req");
    	start_item(req);
    	if(!req.randomize() with {req.vlan_id == vlan_idd;
										  req.prior   == priorr;
										  req.dei     == deii;
										  req.e_type  == e_typee;
										  req.min     == minn;
										  req.max     == maxx;})
      	`uvm_error(get_full_name(),"Randomization Failed!!")
		`uvm_info(get_full_name(),req.convert2string,UVM_MEDIUM)
    	finish_item(req);
  	endtask : body
  
endclass : emac_tx_seqs

`endif 
