/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : mac_to_axi_s_top.sv

* Purpose : main module

* Creation Date : 07-10-2025

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/

`define CYCLE 10
`define CYCLE_REG 20
`timescale 1 ns / 1 ps 

module mac_to_axi_s_top();
 
`include "mac_to_axi_s_defines.svh"
`include "axi_assertion.sv"

`include "uvm_macros.svh"
 import uvm_pkg::*;

 import mac_to_axi_s_test_pkg::*;

 uvm_event reg_reset_evt = new("reg_reset_evt");
 uvm_event rtl_reset_evt = new("rtl_reset_evt"); 

  `define NO_OF_IN_PORT 3
  `define NO_OF_OUT_PORT 3
 
  // CLOCK
  bit tb_clk;
  bit tb_clk_reg;
  
  // RESET
  bit tb_reset;
  bit tb_reset_reg;

  // AXI_STR INF TB 
  axi_str_mas_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)) axi_s_minf[`NO_OF_IN_PORT](tb_clk);
  axi_str_slv_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)) axi_s_sinf[`NO_OF_OUT_PORT](tb_clk);
  axi_str_slv_inf #(512,1) dumy(tb_clk);  

  // AXI_LITE INF TB 
  axi_minf #(`AXI_4_DATA_SIZE,`AXI_4_ADD_SIZE) axi_4_minf1(tb_clk_reg,tb_reset_reg);


//// ------------------------------------------------------- ////
 //// AXI_LITE
//// ------------------------------------------------------- ////
 // WRITE ADDRESS CHANNEL
  assign axi_lite_design.reset_n  = tb_reset_reg;

  assign axi_lite_design.awaddr   = axi_4_minf1.awaddr;
  assign axi_lite_design.awid     = axi_4_minf1.awid;
  assign axi_lite_design.awlen    = axi_4_minf1.awlen;
  assign axi_lite_design.awsize   = axi_4_minf1.awsize;
  assign axi_lite_design.awburst  = axi_4_minf1.awburst;
  assign axi_lite_design.awvalid  = axi_4_minf1.awvalid;
  assign axi_4_minf1.awready      = axi_lite_design.awready;

  // WRITE DATA CHANNEL
  assign axi_lite_design.wdata     = axi_4_minf1.wdata;
  assign axi_lite_design.wid       = axi_4_minf1.wid;
  assign axi_lite_design.wstrb     = axi_4_minf1.wstrb;
  assign axi_lite_design.wlast     = axi_4_minf1.wlast;
  assign axi_lite_design.wvalid    = axi_4_minf1.wvalid;
  assign axi_4_minf1.wready        = axi_lite_design.wready;

  // WRITE RESPONSE CHANNEL
  assign axi_4_minf1.bid           = axi_lite_design.bid;
  assign axi_4_minf1.bresp         = axi_lite_design.bresp;
  assign axi_4_minf1.bvalid        = axi_lite_design.bvalid;
  assign axi_lite_design.bready    = axi_4_minf1.bready;

  // READ ADDRESS CHANNEL
  assign axi_lite_design.araddr    = axi_4_minf1.araddr;
  assign axi_lite_design.arid      = axi_4_minf1.arid;
  assign axi_lite_design.arlen     = axi_4_minf1.arlen;
  assign axi_lite_design.arsize    = axi_4_minf1.arsize;
  assign axi_lite_design.arburst   = axi_4_minf1.arburst;
  assign axi_lite_design.arvalid   = axi_4_minf1.arvalid;
  assign axi_4_minf1.arready       = axi_lite_design.arready;

  // READ DATA CHANNEL
  assign axi_4_minf1.rlast         = axi_lite_design.rlast;
  assign axi_4_minf1.rvalid        = axi_lite_design.rvalid;
  assign axi_4_minf1.rid           = axi_lite_design.rid;
  assign axi_4_minf1.rresp         = axi_lite_design.rresp;
  assign axi_4_minf1.rdata         = axi_lite_design.rdata;
  assign axi_lite_design.rready    = axi_4_minf1.rready;  

//// ------------------------------------------------------- ////
//// AXI_STR INF --------------------------------------------//// 
//// ------------------------------------------------------- ////
  genvar i;

  generate 
     for(i = 0; i<`NO_OF_IN_PORT; i++) begin 
        assign axi_s_minf[i].areset_n         = tb_reset;
        assign axi_str_slv_design[i].reset_n  = tb_reset;;
        assign axi_str_slv_design[i].tvalid   = axi_s_minf[i].tvalid;
        assign axi_str_slv_design[i].tdata    = axi_s_minf[i].tdata;
        assign axi_str_slv_design[i].tlast    = axi_s_minf[i].tlast;
        assign axi_str_slv_design[i].tkeep    = axi_s_minf[i].tkeep;
        assign axi_str_slv_design[i].tuser    = axi_s_minf[i].tuser ;
        assign axi_s_minf[i].tready           = axi_str_slv_design[i].tready; 
    end 
    endgenerate


//// ------------------------------------------------------- ////
//// DESIGN OUTPUT ( Header parser ) 
//// ------------------------------------------------------- ////
  
  genvar j;

  generate 
    for (j=0; j<`NO_OF_OUT_PORT; j++ ) begin 
      assign axi_str_mas_design[j].reset_n = tb_reset;
      assign axi_s_sinf[j].areset_n              = tb_reset;
      assign axi_s_sinf[j].tvalid                = axi_str_mas_design[j].tvalid;
      assign axi_s_sinf[j].tdata                 = axi_str_mas_design[j].tdata ;
      assign axi_s_sinf[j].tlast                 = axi_str_mas_design[j].tlast ;
      assign axi_s_sinf[j].tkeep                 = axi_str_mas_design[j].tkeep ;
      assign axi_s_sinf[j].tuser                 = axi_str_mas_design[j].tuser ;
      assign axi_str_mas_design[j].tready         = axi_s_sinf[j].tready;
    end
  endgenerate 


//// ------------------------------------------------------- ////
  //// CLOCK 
//// ------------------------------------------------------- ////
  always
    #(`CYCLE/2) tb_clk = ~tb_clk;
  
  always
    #(`CYCLE_REG/2) tb_clk_reg = ~tb_clk_reg;
 
//// ------------------------------------------------------- ////
//// DESIGN_INF
//// ------------------------------------------------------- ////
 axi_lite_inf #(`AXI_4_DATA_SIZE,`AXI_4_ADD_SIZE,`AXI_4_ID_SIZE)  axi_lite_design();
 axi_str_slave_inf #(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)) axi_str_slv_design[`NO_OF_IN_PORT]();
 axi_str_master_inf #(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)) axi_str_mas_design[`NO_OF_OUT_PORT]();
 
 
//// ------------------------------------------------------- ////
//// DESIGN
//// ------------------------------------------------------- ////
 top#(.ADDR_SIZE(`AXI_4_ADD_SIZE), .DATA_SIZE(`AXI_4_DATA_SIZE), .ID_SIZE(`AXI_4_ID_SIZE), .USER_SIZE(`AXI_STR_USER_SIZE), .TDATA_SIZE(`AXI_STR_DATA_SIZE) ) dut ( .clk(tb_clk), .reset_n(tb_reset), .reset_reg(tb_reset_reg), .clk_reg(tb_clk_reg), .axi_in_inf(axi_str_slv_design.slave), .axi_out_inf(axi_str_mas_design.master), .axi_lite(axi_lite_design.slave) );


//// ------------------------------------------------------- ////
//// AXI_ASSERTIONS 
//// ------------------------------------------------------- ////
 axi_assertion #(`AXI_4_DATA_SIZE,`AXI_4_ADD_SIZE,`AXI_4_ID_SIZE) axi_4_ass ( tb_clk_reg, tb_reset,axi_4_minf1);


//// ------------------------------------------------------- ////
 //// INITIAL RESET
//// ------------------------------------------------------- ////

// Task that performs a synchronous reset assertion/de-assertion aligned to tb_clk
  task reg_reset_assertion();
    // align to rising edge then assert
    @(posedge tb_clk);
    tb_reset_reg = 1'b0;
    repeat (2) @(posedge tb_clk);
    // de-assert
    tb_reset_reg = 1'b1;
  endtask :reg_reset_assertion 

  task rtl_reset_assertion();
    // align to rising edge then assert
    @(posedge tb_clk);
    tb_reset     = 1'b0;
    repeat (2) @(posedge tb_clk);
    // de-assert
    tb_reset     = 1'b1;
  endtask :rtl_reset_assertion 



  // initial trigger: power-up reset
  initial begin
    fork
      reg_reset_assertion();
      rtl_reset_assertion();
    join
  end


// two parallel waiters; each will service its event when triggered
initial begin
  fork
    begin : REG_RESET_WATCHER
      forever begin
        reg_reset_evt.wait_trigger();                // wait for reg-reset request
        `uvm_info("TOP","reg_reset_evt triggered", UVM_LOW)
        reg_reset_assertion();                       // example: tb_reset_reg only
      end
    end

    begin : RTL_RESET_WATCHER
      forever begin
        rtl_reset_evt.wait_trigger();               // wait for rtl-reset request
        `uvm_info("TOP","rtl_reset_evt triggered", UVM_LOW)
        rtl_reset_assertion();                       // example: tb_reset only
      end
    end
  join_none
end
 



  initial
    begin
      //uvm_top.set_report_verbosity_level(UVM_DEBUG);
     
      uvm_config_db #(virtual axi_str_mas_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)))::set(null,"*.axi_str_muvc_h.master_agent[0]*","vinf",axi_s_minf[0]);
      uvm_config_db #(virtual axi_str_mas_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)))::set(null,"*.axi_str_muvc_h.master_agent[1]*","vinf",axi_s_minf[1]);
      uvm_config_db #(virtual axi_str_mas_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)))::set(null,"*.axi_str_muvc_h.master_agent[2]*","vinf",axi_s_minf[2]);
     
      uvm_config_db #(virtual axi_str_slv_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)))::set(null,"*.axi_str_suvc_h.slave_agent[0]*","vinf",axi_s_sinf[0]);
      uvm_config_db #(virtual axi_str_slv_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)))::set(null,"*.axi_str_suvc_h.slave_agent[1]*","vinf",axi_s_sinf[1]);
      uvm_config_db #(virtual axi_str_slv_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)))::set(null,"*.axi_str_suvc_h.slave_agent[2]*","vinf",axi_s_sinf[2]);
      
      uvm_config_db #(virtual axi_minf #(`AXI_4_DATA_SIZE,`AXI_4_ADD_SIZE))::set(null,"*.axi_4_magent_h*","mvif", axi_4_minf1);

    // make available to sequences via uvm_config_db
    uvm_config_db#(uvm_event)::set(null, "*", "reg_reset_evt", reg_reset_evt);
    uvm_config_db#(uvm_event)::set(null, "*", "rtl_reset_evt", rtl_reset_evt);
      
      run_test("mac_to_axi_s_base_test");
    end
endmodule
