`ifndef AXI_LITE_TOP
`define AXI_LITE_TOP

`include "axi_lite_pkg.sv"
import axi_lite_pkg::*;

module axi_lite_top();

	import uvm_pkg::*;
  	`include "uvm_macros.svh"
  	
	axi_lite_mas_inf#(ADDR_WIDTH,DATA_WIDTH) m_intff();
  	axi_lite_slv_inf#(ADDR_WIDTH,DATA_WIDTH) s_intff();
  	
	initial begin
   	m_intff.ACLK=0;
    	forever #5 m_intff.ACLK=~m_intff.ACLK;
  	end

  	initial begin
  		m_intff.AWREADY<=1;
  		m_intff.WREADY<=1;
  		m_intff.BVALID<=1;
  		m_intff.ARREADY<=1;
  		m_intff.RVALID<=1;
   end
    
  	// Reset generation
  	initial begin
   	m_intff.ARESETn = 0;
    	#20 m_intff.ARESETn = 1;
  	end
      
   initial begin
   	$dumpfile("dump.vcd");
    	$dumpvars;
  	end
  
 	initial begin
   	uvm_config_db#(virtual axi_lite_mas_inf#(ADDR_WIDTH,DATA_WIDTH))::set(null,"*","vif",m_intff);
    	uvm_config_db#(virtual axi_lite_slv_inf#(ADDR_WIDTH,DATA_WIDTH))::set(null,"*","vif",s_intff);
    	run_test("axi_lite_test");
  	end

endmodule : axi_lite_top
`endif
