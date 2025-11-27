/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = mac_to_axi_s_ref_model.svh
//  CREATED_BY  = Muskan
//  MODIFIFED_BY  = 
//  VERSION   = 1.0 
//  DESCRIPTION = 
//
/////////////////////////////////////////////////////

`ifndef MAC_TO_AXI_S_REF_MODEL
`define MAC_TO_AXI_S_REF_MODEL

class mac_to_axi_s_ref_model extends uvm_component;

  `uvm_component_utils(mac_to_axi_s_ref_model )

    parameter int ADD_WIDTH = 32, DATA_WIDTH = 32;

//// Analysis fifo to get the data broadcasted by monitor
	uvm_tlm_analysis_fifo #( mac_tx_seq_item ) anl_ref_fifo;

//// TLM put port to fifo for scoreboard    
     uvm_blocking_put_port #( mac_rx_seq_item ) ref_put_port;

     mac_tx_seq_item mac_req_item;
     mac_rx_seq_item mac_exp_item;

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
////                CONNECT PHASE 
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////

    function void build_phase(uvm_phase phase);
     super.build_phase(phase);

//// Analysis fifo to get data By monitor
     anl_ref_fifo = new ("anl_ref_fifo",this);
    
//// Tlm port to send expected data to scoreboard    
     ref_put_port = new("ref_put_port",this);

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
