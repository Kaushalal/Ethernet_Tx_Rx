/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = axi_minf.svh
//  ENGINEER  = Muskan
//  VERSION   = 1.0 
//  DESCRIPTION = contains all macro 
//
/////////////////////////////////////////////////////

 `ifndef AXI_MINTERFACE_SV
 `define AXI_MINTERFACE_SV

interface axi_minf #(int DATA_WIDTH = 32, ADD_WIDTH = 18) (input aclk,input areset);
	 
//-------------------------------------- WRITE ADDRESS ------//
   logic [7:0] awid;
   logic [(ADD_WIDTH-1) : 0 ] awaddr;
   logic [7:0] awlen;
   logic [2:0] awsize;
   logic [1:0] awburst;
   logic awlock;
   logic awvalid;
   logic awready;

// ---------------------------------------WRITE DATA -------//
   logic [7:0] wid;
   logic[(DATA_WIDTH-1) : 0] wdata;
   logic [((DATA_WIDTH/8) - 1 ) : 0] wstrb;
   logic wlast;
   logic wvalid;
   logic wready;

//-------------------------------------- WRITE RESPONSE ------//
   logic [7:0] bid;
   logic [1 : 0 ] bresp;
   logic bvalid;
   logic bready;

//-------------------------------------- READ ADDRESS ------ //
   logic[7:0] arid;
   logic [(ADD_WIDTH-1) : 0 ] araddr;
   logic [7:0] arlen;
   logic [2:0] arsize;
   logic [1:0] arburst;
   logic arlock;
   logic arvalid;
   logic arready;

// -------------------------------------- READ DATA ------ //
    logic [7:0] rid;
    logic [(DATA_WIDTH-1) : 0] rdata;
    logic [1 : 0 ] rresp;
    logic rlast;
    logic rvalid;
    logic rready;
     

// -------------------------------- CLOCKING BLOCKS -----------------//		 
     
     clocking mdrv_cb @(posedge aclk);
	   default input #1 output #0;  
       
       input  awready;
       output awid, awaddr, awlen, awsize, awburst, awlock, awvalid;
       
       input  wready;
       output wid, wdata, wlast, wstrb, wvalid; 
       
       input  bid, bresp, bvalid;
       output bready; 
       
       input  arready;
       output arid, araddr, arlen, arsize, arburst, arlock, arvalid;
	    
       input rid, rdata, rresp, rlast, rvalid;
       output  rready;
	endclocking
	
     clocking mmon_cb @(posedge aclk);
	   default input #1 output #0;  
       
       input  awready;
       input awid, awaddr, awlen, awsize, awburst, awlock, awvalid;
       
       input  wready;
       input wid, wdata, wlast, wstrb, wvalid; 
       
       input  bid, bresp, bvalid;
       input bready; 
       
       input  arready;
       input arid, araddr, arlen, arsize, arburst, arlock, arvalid;

       input rid, rdata, rresp, rlast, rvalid;
       input  rready;
     endclocking
	
  modport MDRV_MP (clocking mdrv_cb, input aclk, input areset);

  modport MMON_MP (clocking mmon_cb, input aclk, input areset);

 endinterface

 `endif

