/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = axi_4_ral.svh
//  ENGINEER  = Muskan Thakur 
//  VERSION   = 1.0 
//  DESCRIPTION = this file is contains the package of ral files    
//
/////////////////////////////////////////////////////

`ifndef AXI_4_RAL_PKG
`define AXI_4_RAL_PKG

package axi_4_ral_pkg;
  
   import uvm_pkg::*;
  `include "uvm_macros.svh"
   
   import axi_mpkg::*;

   `include "register.svh"
   `include "axi_4_reg_block.svh"
   `include "axi_4_adapter.svh"
   `include "axi_4_ral_seqs.svh"

endpackage 

`endif
