/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_slv_inf.sv

* Purpose : axi stream signals (pins)

* Creation Date : 23-04-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_SLV_INF_SV
`define AXI_STR_SLV_INF_SV
`include "axi_str_slv_define.sv"
`timescale 1 ns / 1 ps 

 interface axi_str_slv_inf  (input bit aclk);

 parameter DATA_SIZE=32,
           USER_SIZE=32;
  
  //AXI stream master
  logic areset_n; //AXI Stream reset active LOW
  logic tvalid;   //AXI Stream valid signal
  logic [(DATA_SIZE-1):0] tdata;
  logic [((DATA_SIZE/8-1)):0] tstrb;
  logic [((DATA_SIZE/8-1)):0] tkeep;   //AXI Stream Tkeep use valid data
  logic tlast;   //AXI Stream last for boundary
  logic [(USER_SIZE-1):0] tuser;

  //AXI stream Slave
  logic tready;   //AXI Stream slave ready

  clocking slv_drv_cb @(posedge aclk);
    default input #(`axis_slv_i_skew) output #(`axis_slv_o_skew);
    output tready;
    input tvalid,tlast;
  endclocking

  clocking mon_cb @(posedge aclk);
    default input #(`axis_slv_i_skew) output #(`axis_slv_o_skew);
    input tvalid,tdata,tstrb,tkeep,tlast,tuser;
    input tready;
  endclocking

 endinterface

`endif
