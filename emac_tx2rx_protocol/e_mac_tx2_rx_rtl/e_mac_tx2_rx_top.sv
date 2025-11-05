typedef struct  {
  logic [2:0]  port_id;
  logic [11:0] vlan_id;
} connection_addr_t;

`include "axi_str_inf.sv"
`include "axi_lite_inf.sv"
`include "arbiter.svp"
`include "header_parser.svp"

module top #(
  int NUM_OF_PORT = 3,
  int ADDR_SIZE   = 32,
  int DATA_SIZE   = 32,
  int ID_SIZE     = 32,
  int USER_SIZE   = 16,
  int TDATA_SIZE  = 32
)(
  input  logic clk,
  input  logic reset_n,
  input  logic reset_reg,
  input  logic clk_reg,

  // AXI-Stream and AXI-Lite interface ports
  axi_str_inf.slave  axi_in_inf   [NUM_OF_PORT],
  axi_str_inf.master axi_out_inf,
  axi_lite_inf.slave axi_lite
);

  // ------------------------------------------------------------
  // Internal signal/interface between Arbiter and Header Parser
  // ------------------------------------------------------------
  axi_str_inf #(TDATA_SIZE, USER_SIZE) axi_out_arb();

  // ------------------------------------------------------------
  // Arbiter Instance
  // ------------------------------------------------------------
  arbiter #(
    .DATA_SIZE(TDATA_SIZE),
    .USER_SIZE(USER_SIZE),
    .NUM_OF_INGRESS_PORTS(NUM_OF_PORT)
  ) u_arbiter (
    .clk(clk),
    .rst_n(reset_n),
    .axis_in_inf(axi_in_inf),
    .axis_out_inf(axi_out_arb)
  );

  // ------------------------------------------------------------
  // Header Parser Instance
  // ------------------------------------------------------------
  header_parser #(
    .ADDR_SIZE(ADDR_SIZE),
    .DATA_SIZE(DATA_SIZE),
    .ID_SIZE(ID_SIZE),
    .USER_SIZE(USER_SIZE),
    .AXIS_DATA_SIZE(TDATA_SIZE)
  ) u_header_parser (
    .reg_clk(clk_reg),
    .clk_n(clk),
    .reset_n(reset_n),
    .reset_reg(reset_reg),
    .axil_inf(axi_lite),
    .axis_in_inf(axi_out_arb),
    .axis_out_inf(axi_out_inf)
  );

endmodule

