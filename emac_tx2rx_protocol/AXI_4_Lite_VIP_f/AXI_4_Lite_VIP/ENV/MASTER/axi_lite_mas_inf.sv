`ifndef AXI_LITE_MAS_INF
`define AXI_LITE_MAS_INF

interface axi_lite_mas_inf#(int ADDR_WIDTH=32,int DATA_WIDTH=32)(input bit ACLK);
   //---------------------------
  	//AXI GLOBLE SIGNAL
  	logic  ARESETn=1;

  	//SIGNALS OF AW CH
  	logic AWVALID;
  	logic AWREADY; 
  	logic [ADDR_WIDTH-1:0] AWADDR;
  
  	// AXI Write Data Channel
  	logic WVALID;
  	logic WREADY; 
  	logic [DATA_WIDTH-1:0] WDATA;
  
   // AXI Write Response Channel
  	logic BVALID;
  	logic BREADY;
  	logic [1:0] BRESP;
  
   // AXI Read Address Channel
   logic ARVALID;
  	logic ARREADY;
  	logic [ADDR_WIDTH-1:0] ARADDR;
  
   // AXI Read Data Channel
  	logic RVALID;
  	logic RREADY;
  	logic [DATA_WIDTH-1:0] RDATA;  // usually this is RDATA
  	logic [1:0]  RRESP;
  
    // Clocking blocks
  	clocking drv_cb @(posedge ACLK);
   	default input #1ns output #0ns;
    	output AWVALID, AWADDR;
    	output WVALID, WDATA;
    	output BREADY;
    	output ARVALID, ARADDR;
    	output RREADY;
    	input AWREADY;
    	input WREADY;
    	input BVALID, BRESP;
    	input ARREADY;
    	input RVALID, RDATA, RRESP;
  	endclocking
  
  	clocking mon_cb @(posedge ACLK);
   	default input #1step;
    	input ARESETn;
    	input AWVALID, AWREADY, AWADDR;
   	input WVALID, WREADY, WDATA;
    	input BVALID, BREADY, BRESP;
    	input ARVALID, ARREADY, ARADDR;
    	input RVALID, RREADY, RDATA, RRESP;
  endclocking
  
endinterface : axi_lite_mas_inf
`endif
