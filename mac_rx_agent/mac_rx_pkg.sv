`ifndef MAC_RX_PKG
`define MAC_RX_PKG

package mac_rx_pkg;
  import uvm_pkg::*;
import axi_str_slv_pkg::*;
 `include "uvm_macros.svh"
`include "mac_rx_sequence_item.sv"
`include "mac_rx_monitor.sv"
`include "mac_rx_cfg.sv"
`include "mac_rx_agent.sv"
`include "mac_rx_uvc.sv"
endpackage
`endif
