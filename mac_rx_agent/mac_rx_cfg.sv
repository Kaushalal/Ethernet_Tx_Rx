`ifndef MAC_RX_CFG
`define MAC_RX_CFG

class mac_rx_cfg extends uvm_object;
   `uvm_object_utils(mac_rx_cfg)
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int no_of_mac_rx = 1;
    function new(string name="");
       super.new(name);
    endfunction
endclass
`endif
