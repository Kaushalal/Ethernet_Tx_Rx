`ifndef MAC_RX_SEQUENCE_ITEM
`define MAC_RX_SEQUENCE_ITEM

class mac_rx_sequence_item extends uvm_sequence_item;
   bit [47:0] rx_SA;
   bit [47:0] rx_DA;
   bit [7:0]  rx_vcid;
   bit [15:0] rx_EType;
   byte unsigned rx_payload[];
   int rx_fram_size;
   `uvm_object_utils(mac_rx_sequence_item)
   function new(string name="");
      super.new(name);
   endfunction   
  
   function int calculate_frame_size();
    int size = 0;
    size += 13; 
    size += 2;   
    size += $size(rx_payload);
    rx_fram_size = size;
    return size;
   endfunction
  function string convert2string();
    calculate_frame_size();
    return $sformatf("rx_DA=%h rx_SA=%h VCID=%0h EType=%0h Payload=%0d bytes Total=%0d bytes",
                     rx_DA, rx_SA, /*(has_vlan ? "YES" : "NO"),*/ rx_vcid, rx_EType, 
                     $size(rx_payload), rx_fram_size);
  endfunction
endclass
`endif
