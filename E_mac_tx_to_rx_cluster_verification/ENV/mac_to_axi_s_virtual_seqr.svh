/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = mac_to_axi_s_virtual_seqr.svh
//  ENGINEER  = Muskan Thakur
//  VERSION   = 1.0 
//  DESCRIPTION = contains all the sequencer of the project  
//
/////////////////////////////////////////////////////

`ifndef MAC_TO_AXI_S_VIRTUAL_SEQR
`define MAC_TO_AXI_S_VIRTUAL_SEQR

class mac_to_axi_s_virtual_seqr extends uvm_sequencer #(uvm_sequence_item);

  `uvm_component_utils(mac_to_axi_s_virtual_seqr)

   // axi_str_mas_sequencer #(32,32) axi_s_mas_seqr_h[];
   // axi_str_slv_sequencer #(32,32) axi_s_slv_seqr_h[];
   
   mac_tx_seqr mac_tx_seqr_h[];

   function new(string name = "axi_virtual_seqr",uvm_component parent = null);
      super.new(name,parent);

      // axi_s_mas_seqr_h = new[3];
      // axi_s_slv_seqr_h = new[3];
      
      mac_tx_seqr_h = new[3];
   endfunction

   function void build_phase ( uvm_phase phase );
   super.build_phase(phase);
   endfunction 

 
endclass 

`endif

