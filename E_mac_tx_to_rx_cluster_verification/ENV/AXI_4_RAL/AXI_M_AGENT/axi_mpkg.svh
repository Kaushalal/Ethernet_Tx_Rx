/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = axi_mpkg.svh
//  ENGINEER  = Muskan
//  VERSION   = 1.0 
//  DESCRIPTION = contains all macro 
//
/////////////////////////////////////////////////////

`ifndef AXI_MPKG
`define AXI_MPKG
 
   `include "axi_minf.svh"

package axi_mpkg;

 `include "uvm_macros.svh"
  import uvm_pkg::*;
  uvm_event reset_mev;

   `include "axi_magt_cfg.svh"
   `include "axi_m_defines.svh"
   `include "axi_mseq_item.svh"
   `include "axi_mseqr.svh"
   `include "axi_mdrv.svh"
   `include "axi_mmon.svh"
   `include "axi_magent.svh"

   `include "axi_base_mseqs.svh"

   
endpackage 

`endif


