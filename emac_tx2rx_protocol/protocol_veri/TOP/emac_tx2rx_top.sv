`include "uvm_macros.svh"
import uvm_pkg::*;

import emac_tx2rx_test_pkg::*;

`define CYCLE 10
`timescale 1 ns / 1 ps 

module emac_tx2rx_top;
  
  bit aclk;

  axi_str_mas_inf#(32,32) mas_inf[3](aclk);
  axi_str_slv_inf#(512,1) slv_inf2[3](aclk);  
  axi_str_slv_inf#(32,32) slv_inf[3](aclk);  
 
  axi_lite_mas_inf#(32,32) m_intff(aclk);
  
  always
    #(`CYCLE/2) aclk = ~aclk;

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

	genvar i;
	generate
  	for (i = 0; i < 3; i++) begin : AXI_STREAM_CONNECT
    	assign slv_inf[i].areset_n = mas_inf[i].areset_n;
    	assign slv_inf[i].tvalid   = mas_inf[i].tvalid;
    	assign slv_inf[i].tdata    = mas_inf[i].tdata;
    	assign slv_inf[i].tkeep    = mas_inf[i].tkeep;
    	assign slv_inf[i].tlast    = mas_inf[i].tlast;
    	assign slv_inf[i].tuser    = mas_inf[i].tuser;
    	assign mas_inf[i].tready   = slv_inf[i].tready;
  	end
	endgenerate
	
	initial 
	begin : RESET
  		@(posedge aclk);
  		mas_inf[0].areset_n = 1'b0;
  		mas_inf[1].areset_n = 1'b0;
 	 	mas_inf[2].areset_n = 1'b0;

  		@(posedge aclk);
  		mas_inf[0].areset_n = 1'b1;
  		mas_inf[1].areset_n = 1'b1;
  		mas_inf[2].areset_n = 1'b1;
	end : RESET

  initial
    begin
      uvm_top.set_report_verbosity_level(UVM_MEDIUM);
      uvm_config_db #(virtual axi_str_mas_inf#(32,32))::set(null,"*master_agent[0]*","vinf",mas_inf[0]);
      uvm_config_db #(virtual axi_str_mas_inf#(32,32))::set(null,"*master_agent[1]*","vinf",mas_inf[1]);
      uvm_config_db #(virtual axi_str_mas_inf#(32,32))::set(null,"*master_agent[2]*","vinf",mas_inf[2]);
		uvm_config_db #(virtual axi_str_slv_inf#(512,1))::set(null,"*axi_str_slv_driver*","vinf",slv_inf2[0]);
		uvm_config_db #(virtual axi_str_slv_inf#(32,32))::set(null,"*slave_agent[0]*","vinf",slv_inf[0]);
      uvm_config_db #(virtual axi_str_slv_inf#(32,32))::set(null,"*slave_agent[1]*","vinf",slv_inf[1]);
      uvm_config_db #(virtual axi_str_slv_inf#(32,32))::set(null,"*slave_agent[2]*","vinf",slv_inf[2]);

		uvm_config_db#(virtual axi_lite_mas_inf#(32,32))::set(null,"*","vif",m_intff);

      run_test("emac_tx2rx_sanity_test");
		
    end
  
endmodule : emac_tx2rx_top
