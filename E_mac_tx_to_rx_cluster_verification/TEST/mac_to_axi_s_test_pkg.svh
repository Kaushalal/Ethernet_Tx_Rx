/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : mac_to_axi_s_test_pkg.sv

* Purpose : all component, object and interface 

* Creation Date : 07-10-2025

* Last Modified :

* Created By : Muskan Thakur  

_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef MAC_TO_AXI_S_TEST_PKG
`define MAC_TO_AXI_S_TEST_PKG

package mac_to_axi_s_test_pkg;
 
   import uvm_pkg::*;
  `include "uvm_macros.svh"

   import axi_str_mas_pkg::*;
   import axi_str_slv_pkg::*;
 
   import mac_tx_pkg::*;
   import mac_to_axi_s_env_pkg::*;
  
  `include "mac_to_axi_s_base_test.svh"
  `include "mac_to_axi_s_sanity_test.svh"

endpackage 

`endif
