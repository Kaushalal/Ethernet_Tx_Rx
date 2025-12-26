/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-

*	File_Name     : emac_rx_seqs_item.sv
*	Purpose       : Defines the transaction object for received Ethernet frames,
	           		 including MAC addresses, payload, and control information,
 	          		 used by the EMAC RX monitor and sequences.
*  Created By    : Meet_Patel

-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-. */

`ifndef EMAC_RX_SEQS_ITEM_SV
`define EMAC_RX_SEQS_ITEM_SV

class emac_rx_seqs_item#(
	int PAYLOAD_DATA_WIDTH = 8,
	int FRAME_DATA_WIDTH   = 32) extends uvm_sequence_item;

	localparam BYTES_PER_WORD = FRAME_DATA_WIDTH / 8;

	bit [(8*6)-1:0] dest_mac_addr;		//Client address
	bit [(8*6)-1:0] source_mac_addr;	//Network address
  
	//TCI  control information
	bit [7:0] vcid;   //virtual connection id 
	
	bit [15:0]                   e_type;        //'h8100,'h0800 : supported
	bit [PAYLOAD_DATA_WIDTH-1:0] payload[$];    //data 
	
	bit [15:0] dummy_tci;
	bit [FRAME_DATA_WIDTH-1:0] frame[$];

	int unsigned total_bytes = 20 + payload.size();   //total bytes in a transfer
	int unsigned pkt_len = (total_bytes%4)==0 ? (total_bytes/4) : ((total_bytes/4)+1); //packet length in a transfer

  	`uvm_object_param_utils_begin(emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH))
		`uvm_field_int(dest_mac_addr,   UVM_ALL_ON | UVM_HEX)
		`uvm_field_int(source_mac_addr, UVM_ALL_ON | UVM_HEX)
		`uvm_field_int(vcid,            UVM_ALL_ON | UVM_HEX)
		`uvm_field_int(e_type,          UVM_ALL_ON | UVM_HEX)
		`uvm_field_queue_int(payload,   UVM_ALL_ON | UVM_HEX)
		`uvm_field_int(total_bytes,     UVM_ALL_ON | UVM_DEC)
		`uvm_field_int(pkt_len,         UVM_ALL_ON | UVM_DEC)
		`uvm_field_queue_int(frame,     UVM_ALL_ON)
	`uvm_object_utils_end
	
  	function new(string name = "emac_rx_seqs_item");
		super.new(name);
	endfunction : new

  	function string convert2string;
   	return $sformatf("\nDEST_MAC_ADDR = %h | SOURCE_MAC_ADDR=%h | VCID = %h | e_type=%0d",
                     		dest_mac_addr,source_mac_addr,vcid,e_type);
  	endfunction : convert2string 

endclass : emac_rx_seqs_item

`endif 
