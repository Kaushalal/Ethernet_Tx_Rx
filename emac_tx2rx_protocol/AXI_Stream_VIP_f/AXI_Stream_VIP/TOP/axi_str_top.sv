/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_top.sv

* Purpose : main module

* Creation Date : 04-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/

`define CYCLE 10
`timescale 1 ns / 1 ps 
`include "uvm_macros.svh"
import uvm_pkg::*;
import axi_str_pkg::*;
`include "axis_define.sv"

module axi_str_top();

  bit aclk;

  //axi_str_inf inf(aclk);
  axi_str_mas_inf #(`DATA_WIDTH,`USER_WIDTH) mas_inf(aclk);
  axi_str_slv_inf #(`DATA_WIDTH,`USER_WIDTH) slv_inf(aclk);  
  axi_str_slv_inf #(512,1) dumy(aclk);  

  always
    #(`CYCLE/2) aclk = ~aclk;

      //slave
      assign slv_inf.areset_n = mas_inf.areset_n;
      assign slv_inf.tvalid = mas_inf.tvalid;
      assign slv_inf.tdata = mas_inf.tdata;
      //slv_inf.tstrb = mas_inf.tstrb;
      assign slv_inf.tkeep = mas_inf.tkeep;
      assign slv_inf.tlast = mas_inf.tlast;
      assign slv_inf.tuser = mas_inf.tuser;
      assign mas_inf.tready = slv_inf.tready;

  initial 
    begin : RESET
      @(posedge aclk);
      mas_inf.areset_n = 1'b0; //reset active assert (active low) 
      @(posedge aclk);
      mas_inf.areset_n = 1'b1; //reset relase
    end : RESET

  initial
    begin
      uvm_top.set_report_verbosity_level(UVM_DEBUG);
      uvm_config_db #(virtual axi_str_mas_inf)::set(null,"*","vinf",mas_inf);
      uvm_config_db #(virtual axi_str_slv_inf)::set(null,"*","vinf",slv_inf);
      run_test("axi_str_mas_base_test");
      //run_test("c2n_mac_to_axi_str_test");
    //  run_test("n2c_mac_to_axi_str_test");
    end

endmodule
