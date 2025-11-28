/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = mac_tx_cfg.svh
//  ENGINEER  = Muskan
//  VERSION   = 1.0 
//  DESCRIPTION =  
//
/////////////////////////////////////////////////////

`ifndef MAC_TX_CFG
`define MAC_TX_CFG

class mac_tx_cfg extends uvm_object;

  uvm_active_passive_enum is_active;

  int no_of_tx_agent;
  int id;
  
  `uvm_object_utils_begin(mac_tx_cfg)
      `uvm_field_enum (uvm_active_passive_enum, is_active, UVM_ALL_ON )
      `uvm_field_int(no_of_tx_agent,UVM_ALL_ON)
      `uvm_field_int(id,UVM_ALL_ON)
   `uvm_object_utils_end

   function new (string name = "mac_tx_cfg");
      super.new(name);
   endfunction

   
endclass 

`endif
