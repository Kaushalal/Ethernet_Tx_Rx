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
  
   mac_to_axi_s_base_virtual_seqs mac_vseqs; 
   mac_to_axi_s_virtual_seqr mac_vseqr;

   function new (string name="axi_str_mas_base_test", uvm_component parent=null); 
      super.new(name,parent); 
   endfunction: new 
                   
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////
////                      BUILD PHASE
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////

   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     mac_vseqs = mac_to_axi_s_base_virtual_seqs::type_id::create("mac_vseqs");
     mac_vseqr = mac_to_axi_s_virtual_seqr::type_id::create("mac_vseqr",this);
   endfunction : build_phase

////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////
////                      CONNECT PHASE
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////

    function void connect_phase(uvm_phase phase);
       mac_vseqs.conn_cfg_seqs.axi_4_reg_block_h = env_h.axi_4_reg_block_h;
    endfunction 
   
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////
////                      RUN PHASE
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
	       mac_vseqs.start(env_h.vseqr_h);

           #2000;
		phase.drop_objection(this);
	endtask
    
endclass : mac_to_axi_s_sanity_test

`endif
