/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = mac_tx_seq_item.svh
//  CREATED_BY  = Muskan Thakur 
//  MODIFIED_BY  =  
//  VERSION   = 1.0 
//  DESCRIPTION = contains sequense item class of mac agent  
//
/////////////////////////////////////////////////////

`ifndef MAC_TX_SEQ_ITEM
`define MAC_TX_SEQ_ITEM

class mac_tx_seq_item extends uvm_sequence_item;

  rand bit [5:0][7:0] da;
  rand bit [5:0][7:0] sa;

  rand bit [11:0] vlan;
  rand bit [2:0] pri;
  rand bit dei;

  rand bit [1:0][7:0] Etype;

  rand byte unsigned payload_q[$];

//  rand bit [3:0][7:0] fcs;

  rand bit [1:0][7:0] tci;

  `uvm_object_utils_begin(mac_tx_seq_item)
    `uvm_field_int (da, UVM_ALL_ON | UVM_HEX )
    `uvm_field_int (sa, UVM_ALL_ON | UVM_HEX )

    `uvm_field_int (vlan, UVM_ALL_ON | UVM_HEX )
    `uvm_field_int (pri, UVM_ALL_ON )
    `uvm_field_int (dei, UVM_ALL_ON )
    `uvm_field_int (tci, UVM_ALL_ON )

    `uvm_field_int (Etype, UVM_ALL_ON | UVM_HEX )

    `uvm_field_queue_int (payload_q, UVM_ALL_ON | UVM_HEX )

//    `uvm_field_int (fcs, UVM_ALL_ON | UVM_HEX )
  `uvm_object_utils_end 

  constraint payload_size_c1 { soft payload_q.size() inside { [46:1500] }; }
  
  constraint Etype_c { soft Etype inside { 16'h0800, 16'h8100 }; }
  
  constraint pri_c { soft pri == 0; }
  
  constraint dei_c { soft dei == 0; }

  function void post_randomize();
    tci = {>>{ dei,pri,vlan } };
    `uvm_info("TCI_DETIALS",$sformatf(" dei = %b || pri = %b || vlan = %b || tci = %b ",dei,pri,vlan,tci),UVM_MEDIUM);

    if(payload_q.size < 46) begin
        do begin 
        payload_q.push_back('b0); end 
        while (payload_q.size != 46);
    end

  endfunction

  function new (string name = "");
  super.new(name);
  endfunction

endclass 

`endif
