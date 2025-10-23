/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : mac_to_axi_s_top.sv

* Purpose : main module

* Creation Date : 07-10-2025

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/

`define CYCLE 10
`timescale 1 ns / 1 ps 

module mac_to_axi_s_top();
  `include "mac_to_axi_s_defines.svh"

`include "uvm_macros.svh"
 import uvm_pkg::*;

import mac_to_axi_s_test_pkg::*;
  
  bit aclk;

  axi_str_mas_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)) axi_s_minf1(aclk);
  axi_str_mas_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)) axi_s_minf2(aclk);
  axi_str_mas_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)) axi_s_minf3(aclk);
  
  axi_str_slv_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE))axi_s_sinf1(aclk);
  axi_str_slv_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE))axi_s_sinf2(aclk);
  axi_str_slv_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE))axi_s_sinf3(aclk);
  axi_str_slv_inf #(512,1) dumy(aclk);  

  axi_minf #(32,32) axi_4_inf1(aclk,axi_s_minf1.areset_n);
  axi_minf #(32,32) axi_4_inf2(aclk,axi_s_minf2.areset_n);
  axi_minf #(32,32) axi_4_inf3(aclk,axi_s_minf3.areset_n);
 
  always
    #(`CYCLE/2) aclk = ~aclk;
 
 //slave
      assign axi_s_minf1.tready = 1;
      assign axi_s_minf2.tready = 1;
      assign axi_s_minf3.tready = 1;
 initial 
    begin : RESET
      @(posedge aclk);
      axi_s_minf1.areset_n = 1'b0; //reset active assert (active low) 
      axi_s_minf2.areset_n = 1'b0; //reset active assert (active low) 
      axi_s_minf3.areset_n = 1'b0; //reset active assert (active low) 
      @(posedge aclk);
      axi_s_minf1.areset_n = 1'b1; //reset active assert (active low) 
      axi_s_minf2.areset_n = 1'b1; //reset active assert (active low) 
      axi_s_minf3.areset_n = 1'b1; //reset active assert (active low) 
    end : RESET

  initial
    begin
     // uvm_top.set_report_verbosity_level(UVM_DEBUG);
      uvm_config_db #(virtual axi_str_mas_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)))::set(null,"*.axi_str_muvc_h.master_agent[0]*","vinf",axi_s_minf1);
      uvm_config_db #(virtual axi_str_mas_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)))::set(null,"*.axi_str_muvc_h.master_agent[1]*","vinf",axi_s_minf2);
      uvm_config_db #(virtual axi_str_mas_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)))::set(null,"*.axi_str_muvc_h.master_agent[2]*","vinf",axi_s_minf3);
     
      uvm_config_db #(virtual axi_str_slv_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)))::set(null,"*.axi_str_suvc_h.slave_agent[0]*","vinf",axi_s_sinf1);
      uvm_config_db #(virtual axi_str_slv_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)))::set(null,"*.axi_str_suvc_h.slave_agent[1]*","vinf",axi_s_sinf2);
      uvm_config_db #(virtual axi_str_slv_inf#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)))::set(null,"*.axi_str_suvc_h.slave_agent[2]*","vinf",axi_s_sinf3);
      
      uvm_config_db #(virtual axi_minf #(`AXI_4_DATA_SIZE,`AXI_4_ADD_SIZE))::set(null,"*.axi_4_magent_h*","mvif", axi_4_inf1);

      run_test("mac_to_axi_s_base_test");
    end
endmodule
