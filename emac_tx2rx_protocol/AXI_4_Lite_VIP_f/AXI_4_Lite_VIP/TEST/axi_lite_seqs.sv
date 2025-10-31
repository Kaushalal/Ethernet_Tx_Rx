`ifndef AXI_LITE_SEQS
`define AXI_LITE_SEQS

class axi_lite_seqs#(int ADDR_WIDTH,int DATA_WIDTH) extends uvm_sequence#(axi_lite_mas_seqs_item#(ADDR_WIDTH,DATA_WIDTH));

	`uvm_object_param_utils_begin(axi_lite_seqs#(ADDR_WIDTH,DATA_WIDTH))
  	`uvm_object_utils_end
  
  	function new (string name="aix_lite_seqs");
   	super.new(name);
  	endfunction : new
  
 	virtual task body();
   	repeat(5)begin
      	`uvm_do_with(req,{axi_op_e==AXI_LITE_WRITE;})
      	$display("INSIDE MASTER SEQUENCE WRITE REQ");
      	`uvm_do_with(req,{axi_op_e==AXI_LITE_READ;})
      	$display("INSIDE MASTER SEQUENCE READ REQ");
       	req.print();
    	end
  	endtask : body

endclass : axi_lite_seqs
`endif
