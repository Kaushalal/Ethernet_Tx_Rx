`include "uvm_macros.svh"
import uvm_pkg::*;

import emac_tx2rx_test_pkg::*;
`include "axi_lite_inf.sv"
`include "axi_str_inf.sv"

`define CYCLE 10
`timescale 1 ns / 1 ps 

module emac_tx2rx_top;
  
  bit aclk;
  bit resetn;

  axi_str_inf#(32,32)     str_inf[3]();
  axi_str_inf#(32,32)     str_inf2();
  axi_lite_inf#(32,32,32) lite_inf();

  axi_str_mas_inf#(32,32) mas_inf[3](aclk);
  axi_str_slv_inf#(512,1) slv_inf2[3](aclk);  
  axi_str_slv_inf#(32,32) slv_inf[3](aclk);  
 
  axi_lite_mas_inf#(32,32) m_intff(aclk);
 
  top emac_tx2rx_top(.clk(aclk),.reset_n(resetn),.reset_reg(lite_inf.reset_n),.clk_reg(aclk),
  							.axi_in_inf(str_inf.slave),.axi_out_inf(str_inf2.master),.axi_lite(lite_inf.slave));
  
  always
    #(`CYCLE/2) aclk = ~aclk;

	/*initial begin
  		m_intff.AWREADY<=1;
  		m_intff.WREADY<=1;
  		m_intff.BVALID<=1;
  		m_intff.ARREADY<=1;
  		m_intff.RVALID<=1;
   end*/

	initial begin 
   	m_intff.ARESETn = 1'b0; //reset active assert (active low) 
      repeat(2)@(posedge m_intff.ACLK);
      m_intff.ARESETn = 1'b1; //reset relase
    end 

   assign lite_inf.slave.reset_n = m_intff.ARESETn;
   assign lite_inf.slave.awvalid = m_intff.AWVALID;
   assign m_intff.AWREADY        = lite_inf.slave.awready;
   assign lite_inf.slave.awaddr  = m_intff.AWADDR;
   assign lite_inf.slave.wvalid  = m_intff.WVALID;
   assign m_intff.WREADY         = lite_inf.slave.wready;
   assign lite_inf.slave.wdata   = m_intff.WDATA;
   assign m_intff.BVALID         = lite_inf.slave.bvalid;
   assign lite_inf.slave.bready  = m_intff.BREADY;
   assign lite_inf.slave.bresp   = m_intff.BRESP;
   assign lite_inf.slave.arvalid = m_intff.ARVALID;
   assign m_intff.ARREADY        = lite_inf.slave.arready;
   assign lite_inf.slave.araddr  = m_intff.ARADDR;
   assign m_intff.RVALID   		= lite_inf.slave.rvalid;
   assign lite_inf.slave.rready  = m_intff.RREADY;
   assign m_intff.RDATA    		= lite_inf.slave.rdata;
   assign m_intff.RRESP    		= lite_inf.slave.rresp;

	genvar i;
	generate
  	for (i = 0; i < 3; i++) begin : AXI_STREAM_MAS_CONNECT
    	assign str_inf[i].slave.reset_n = mas_inf[i].areset_n;
    	assign str_inf[i].slave.tvalid  = mas_inf[i].tvalid;
    	assign str_inf[i].slave.tdata   = mas_inf[i].tdata;
    	assign str_inf[i].slave.tkeep   = mas_inf[i].tkeep;
    	assign str_inf[i].slave.tlast   = mas_inf[i].tlast;
    	assign str_inf[i].slave.tuser   = mas_inf[i].tuser;
    	assign mas_inf[i].tready        = str_inf[i].slave.tready;
  	end
	endgenerate

	genvar i2;
	generate
  	for (i2 = 0; i2 < 3; i2++) begin : AXI_STREAM_SLV_CONNECT
    	assign slv_inf[i2].areset_n      = str_inf[i2].master.reset_n;
    	assign slv_inf[i2].tvalid        = str_inf[i2].master.tvalid;
    	assign slv_inf[i2].tdata         = str_inf[i2].master.tdata;
    	assign slv_inf[i2].tkeep         = str_inf[i2].master.tkeep;
    	assign slv_inf[i2].tlast         = str_inf[i2].master.tlast;
    	assign slv_inf[i2].tuser         = str_inf[i2].master.tuser;
    	assign str_inf[i2].master.tready = slv_inf[i2].tready;
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

