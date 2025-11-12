/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = axi4_adapter.svh
//  CREATED_BY  = Muskan Thakur 
//  MODIFIED_BY  = 
//  VERSION   = 1.0 
//  DESCRIPTION = this file is responsible to convert the ethernet packet to axi_s data format.   
//
/////////////////////////////////////////////////////

`ifndef AXI_4_ADAPTER
`define AXI_4_ADAPTER

class axi_4_adapter#(int DATA_WIDTH=32, ADD_WIDTH=32) extends uvm_reg_adapter;

 `uvm_object_param_utils(axi_4_adapter#(DATA_WIDTH,ADD_WIDTH))

 function new ( string name = "");
   super.new(name);
   `uvm_info("AXI_4_ADAPTER",$sformatf("UVM RAL Configuration:-  ADDR_WIDTH = %0d ||  DATA_WIDTH = %0d || ",`UVM_REG_ADDR_WIDTH,`UVM_REG_DATA_WIDTH),UVM_LOW)
    supports_byte_enable = 0; 
    provides_responses = 0;
 endfunction

//// ---------------------------------------------------------------------------------------------------////
//// ----------------------------------------------- bus2reg ----------------------------------------------------////
//// ---------------------------------------------------------------------------------------------------////
 
 function void bus2reg( uvm_sequence_item bus_item, ref uvm_reg_bus_op rw );   // Convert seqs_item into reg_item
 
 axi_mseq_item #(DATA_WIDTH,ADD_WIDTH) axi_bus_item;
 $cast(axi_bus_item,bus_item);

 rw.kind = ( axi_bus_item.operation == axi_mpkg::WRITE ) ? UVM_WRITE : UVM_READ ;
 rw.addr = ( rw.kind == UVM_WRITE ) ? axi_bus_item.awaddr : axi_bus_item.araddr ;
 rw.data = ( rw.kind == UVM_WRITE ) ? axi_bus_item.wdata[0] : axi_bus_item.rdata[0];

 if( rw.kind == UVM_WRITE ) begin 
     case( axi_bus_item.bresp )
     axi_mpkg::OKAY    : rw.status = UVM_IS_OK  ;
     axi_mpkg::EX_OKAY : rw.status = UVM_NOT_OK ; 
     axi_mpkg::SLVERR  : rw.status = UVM_NOT_OK ; 
     axi_mpkg::DECERR  : rw.status = UVM_NOT_OK ; 
     default           : rw.status = UVM_HAS_X;
     endcase
 end 
 else begin  
     case( axi_bus_item.rresp[0] )
     axi_mpkg::OKAY    : rw.status = UVM_IS_OK  ; 
     axi_mpkg::EX_OKAY : rw.status = UVM_NOT_OK ; 
     axi_mpkg::SLVERR  : rw.status = UVM_NOT_OK ; 
     axi_mpkg::DECERR  : rw.status = UVM_NOT_OK ; 
     default           : rw.status = UVM_HAS_X;
     endcase
  end 

 endfunction

//// ---------------------------------------------------------------------------------------------------////
//// ----------------------------------------------- reg2bus ----------------------------------------------------////
//// ---------------------------------------------------------------------------------------------------////
 
 function uvm_sequence_item reg2bus ( const ref uvm_reg_bus_op rw );    // Convert reg_item to seqs_item 
 
 axi_mseq_item #(DATA_WIDTH,ADD_WIDTH) axi_bus_item;
 axi_bus_item = new("axi_bus_item");

 axi_bus_item.operation = ( rw.kind == UVM_WRITE ) ? axi_mpkg::WRITE : axi_mpkg::READ ;
 axi_bus_item.awaddr = ( rw.kind == UVM_WRITE ) ? rw.addr : 'b0 ; 
 axi_bus_item.araddr = ( rw.kind == UVM_READ ) ? rw.addr : 'b0 ; 
 
 axi_bus_item.wdata[0] = ( rw.kind == UVM_WRITE ) ? rw.data : 'b0 ; 
 axi_bus_item.rdata[0] = ( rw.kind == UVM_READ ) ? rw.data : 'b0 ;

 return axi_bus_item;

 endfunction

endclass

`endif
