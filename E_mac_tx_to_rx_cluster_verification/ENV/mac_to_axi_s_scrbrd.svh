/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = mac_to_axi_s_scrbrd.svh
//  CREATED_BY  = Muskan
//  MODIFIFED_BY  = 
//  VERSION   = 1.0 
//  DESCRIPTION = 
//
/////////////////////////////////////////////////////

`ifndef MAC_TO_AXI_S_SCRBRD
`define MAC_TO_AXI_S_SCRBRD

class mac_to_axi_s_scrbrd extends uvm_component;

  `uvm_component_utils(mac_to_axi_s_scrbrd)

    parameter int ADD_WIDTH = 32, DATA_WIDTH = 32;

//// Analysis fifo to get the data broadcasted by monitor
	uvm_tlm_analysis_fifo #( mac_rx_seq_item ) anl_sb_fifo;

//// TLM put port to fifo for scoreboard    
     uvm_blocking_get_port #( mac_rx_seq_item ) sb_get_port;

     mac_rx_seq_item mac_act_item;

////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////
////                   NEW 
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////

   function new (string name = "mac_to_axi_s_ref_model",uvm_component parent = null);
      super.new(name, parent);
   endfunction
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////
////                BUILD PHASE 
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////

    function void build_phase(uvm_phase phase);
     super.build_phase(phase);

     //// Analysis fifo to get data By monitor
     anl_sb_fifo = new ("anl_ref_fifo",this);
    
     //// Tlm port to send expected data to scoreboard    
     sb_get_port = new("ref_put_port",this);

  endfunction

////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////
////                RUN PHASE 
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////

   task run_phase(uvm_phase phase);
    forever begin
      
      anl_ref_fifo.get(mac_req_item);

    end
      
  endtask 

endclass

`endif
