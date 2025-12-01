/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = mac_to_axi_s_sanity_test.svh
//  ENGINEER  = Muskan Thakur 
//  VERSION   = 1.0 
//  DESCRIPTION = this file is responsible to change the ethernet packet to axi_s data format.   
//
/////////////////////////////////////////////////////

`ifndef MAC_TO_AXI_S_SANITY_TEST
`define MAC_TO_AXI_S_SANITY_TEST

class mac_to_axi_s_sanity_test extends mac_to_axi_s_base_test; 
 
  `uvm_component_utils(mac_to_axi_s_sanity_test) 
   
   mac_tx_to_rx_sanity_vseqs mac_sanity_vseqs;
   
   function new (string name="axi_str_mas_base_test", uvm_component parent=null); 
      super.new(name,parent); 
   endfunction: new 
                   
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////
////                      RUN PHASE
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
           //// Base virtual seqs 
           mac_sanity_vseqs = mac_tx_to_rx_sanity_vseqs::type_id::create("mac_sanity_vseqs");
	       mac_sanity_vseqs.start(env_h.vseqr_h);

           #2000;
		phase.drop_objection(this);
	endtask
    
endclass : mac_to_axi_s_sanity_test

`endif
