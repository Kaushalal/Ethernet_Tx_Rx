/*------------------------------------------------------------------------
                          Name      : Muskan_Thakur
                          File Name : reg_adapter.sv
                          Date      : Oct 13
------------------------------------------------------------------------ */


`ifndef AXI_4_ADAPTER
`define AXI_4_ADAPTER

class axi_4_adapter#(int DATA_WIDTH=32, ADD_WIDTH=32) extends uvm_reg_adapter;

 `uvm_object_param_utils(axi_4_adapter#(DATA_WIDTH,ADD_WIDTH))

 function new ( string name = "axi_4_adapter");
      super.new(name);
     `uvm_info("AXI_4_ADAPTER",$sformatf("UVM RAL Configuration:-  ADDR_WIDTH = %0d ||  DATA_WIDTH = %0d || ",`UVM_REG_ADDR_WIDTH,`UVM_REG_DATA_WIDTH),UVM_LOW)
      endfunction

 function void bus2reg( uvm_sequence_item bus_item, ref uvm_reg_bus_op rw );   // Convert seqs_item into reg_item

      mas_axi_seq_item #(DATA_WIDTH,ADD_WIDTH) axi_bus_item;

      $cast(axi_bus_item,bus_item);
     
      rw.kind = ( axi_bus_item.enb == axi_bus_item.WRITE   ) ? UVM_WRITE            : UVM_READ ;
      rw.addr = ( rw.kind          == UVM_WRITE            ) ? axi_bus_item.AWADDR  : axi_bus_item.ARADDR ;
      rw.data = ( rw.kind          == UVM_WRITE            ) ? axi_bus_item.wdata_array[0]: axi_bus_item.rdata_array[0]; 
     
      endfunction

 function uvm_sequence_item reg2bus ( const ref uvm_reg_bus_op rw );          // Convert reg_item to seqs_item 
 
      mas_axi_seq_item #(DATA_WIDTH,ADD_WIDTH) axi_bus_item;
      axi_bus_item = mas_axi_seq_item#(DATA_WIDTH,ADD_WIDTH)::type_id::create("axi_bus_item");
     
      axi_bus_item.enb      = ( rw.kind == UVM_WRITE ) ? axi_bus_item.WRITE   : axi_bus_item.READ ;
      axi_bus_item.AWADDR   = ( rw.kind == UVM_WRITE ) ? rw.addr : 'b0  ; 
      axi_bus_item.ARADDR   = ( rw.kind == UVM_READ  ) ? rw.addr : 'b0  ; 
      
      axi_bus_item.wdata_array[0] = ( rw.kind == UVM_WRITE ) ? rw.data : 'b0  ; 
      axi_bus_item.rdata_array[0] = ( rw.kind == UVM_READ  ) ? rw.data : 'b0  ;
     
      return axi_bus_item;
     
      endfunction

endclass

`endif
