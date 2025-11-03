`ifndef EMAC_TX_SEQS_ITEM_SV
`define EMAC_TX_SEQS_ITEM_SV

class emac_tx_seqs_item#(
	shortint PAYLOAD_DATA_WIDTH = 8,
	shortint FRAME_DATA_WIDTH   = 32
	) extends uvm_sequence_item;

	localparam BYTES_PER_WORD = FRAME_DATA_WIDTH / 8;

	rand bit [(8*6)-1:0] dest_mac_addr;		//Client address
	rand bit [(8*6)-1:0] source_mac_addr;	//Network address
  
  	bit [FRAME_DATA_WIDTH-1:0] frame [$];  //pack into axi_stream
	
	//TCI  control information
	rand bit [11:0] vlan_id; 
	rand bit [2:0]  prior;
	rand bit 	    dei;		//Drop Eligible Indicator
   bit [15:0]  	 tci;    //concatination of {vlan_id,prior,dei}
	
	rand bit [15:0]                   e_type;        //8100,0800 : supported
	rand bit [PAYLOAD_DATA_WIDTH-1:0] payload [$];    //data 
	rand bit [31:0]                   fcs;	          //CRC
	int unsigned 			  				 total_bytes;   //total bytes in a transfer
	int unsigned 			  				 pkt_len;   	 //packet length in a transfer

	rand bit[31:0] min,max;

	constraint payload_len_c{                    //payload length supported min:46 | max:1500
		soft payload.size() inside {min,max};
	} 

  	`uvm_object_param_utils_begin(emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH))
		`uvm_field_int(dest_mac_addr,   UVM_ALL_ON | UVM_HEX)
		`uvm_field_int(source_mac_addr, UVM_ALL_ON | UVM_HEX)
		`uvm_field_int(vlan_id,         UVM_ALL_ON | UVM_HEX)
		`uvm_field_int(prior,           UVM_ALL_ON | UVM_HEX)
		`uvm_field_int(dei,             UVM_ALL_ON | UVM_HEX)
		`uvm_field_int(tci,				  UVM_ALL_ON | UVM_HEX)
		`uvm_field_int(e_type,          UVM_ALL_ON | UVM_DEC)
		`uvm_field_queue_int(payload,   UVM_ALL_ON | UVM_HEX)
		`uvm_field_int(fcs,             UVM_ALL_ON | UVM_HEX)
		`uvm_field_int(total_bytes,     UVM_ALL_ON | UVM_DEC)
		`uvm_field_int(pkt_len,     	  UVM_ALL_ON | UVM_DEC)
		`uvm_field_queue_int(frame,     UVM_ALL_ON)
	`uvm_object_utils_end
	
  	function new(string name = "emac_tx_seqs_item");
		super.new(name);
	endfunction : new
	
	function void post_randomization();
		tci = {vlan_id,prior,dei};
	endfunction : post_randomization	
  
  	function string convert2string;
   	return $sformatf("\nDEST_MAC_ADDR = %h | SOURCE_MAC_ADDR=%h | TCI=%h | e_type=%0d | fcs=%h | min=%0d | max = %0d",
                     		dest_mac_addr,source_mac_addr,{vlan_id,prior,dei},e_type,fcs,min,max);
  	endfunction : convert2string 

endclass : emac_tx_seqs_item

`endif 
