/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_env_pkg.sv

* Purpose : make package of file

* Creation Date : 07-10-2025

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef MAC_TO_AXI_S_ENV_PKG
`define MAC_TO_AXI_S_ENV_PKG

package mac_to_axi_s_env_pkg;

   import uvm_pkg::*;
  `include "uvm_macros.svh"
 
   import axi_str_mas_pkg::*;
   import axi_str_slv_pkg::*;
 
   import mac_tx_pkg::*;
   import emac_rx_pkg::*;
   
   import axi_4_ral_pkg::*;
   
   import axi_mpkg::*;

  `include "mac_to_axi_s_defines.svh"
  `include "mac_to_axi_s_env_cfg.svh"
  `include "mac_to_axi_s_virtual_seqr.svh"
  `include "mac_to_axi_s_base_virtual_seqs.svh"

  `include "emac_tx2rx_base_vseqs.sv"
  `include "axi_str_mas_uvc.sv"
  `include "axi_str_slv_uvc.sv"
  
  `include "axi_4_muvc.svh"
  
  `include "mac_tx_uvc.svh"
  `include "mac_rx_uvc.sv"
  
  `include "emac_tx2rx_ref.sv"
  `include "emac_tx2rx_scrbd.sv"
  
  `include "mac_to_axi_s_env.svh"

endpackage

`endif
