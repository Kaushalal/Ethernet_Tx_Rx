


interface axi_lite_inf #(int DATA_SIZE=32,int ADDR_SIZE=32,int ID_SIZE = 32);
/*
parameter DATA_SIZE=32;
parameter ADDR_SIZE=32;
parameter ID_SIZE=32;*/
  logic reset_n;
  logic awvalid; 
  logic awready = 1'b1;
  logic [(ADDR_SIZE-1):0] awaddr;
  logic [(ID_SIZE-1):0] awid;
  logic [2:0]awsize;
  logic [7:0]awlen;
  logic [1:0]awburst; 
  
  logic wvalid;
  logic wready = 1'b1;
  logic [(DATA_SIZE-1):0] wdata;
  logic wlast;
  logic [(ID_SIZE-1):0] wid;
  logic [((DATA_SIZE/8)-1):0]wstrb;
  
  logic bready;
  logic bvalid;
  logic [1:0]bresp;
  logic [(ID_SIZE-1):0] bid;

  logic arready=1'b1;
  logic arvalid;																			
  logic [(ADDR_SIZE-1):0] araddr;
  logic [(ID_SIZE-1):0] arid;
  logic [2:0]arsize;
  logic [7:0]arlen;
  logic [1:0]arburst;

  logic rvalid;
  logic rready;
  logic [(DATA_SIZE-1):0] rdata;
  logic rlast;
  logic [(ID_SIZE-1):0] rid;
  logic rresp;

modport slave(input    reset_n, awvalid, awaddr, awid, awsize,awlen,awburst,
                       wvalid, wdata, wlast,wid,wstrb,bready,
	               arvalid, araddr, arid, arsize,arlen,arburst,rready,
	      output  bvalid,bresp,bid,
	              rvalid, rdata, rlast, rid, rresp, 
                       arready, awready, wready);
			   
modport master(input  reset_n, awready, wready, bvalid, bresp, bid,
                      arready, rvalid, rdata, rlast, rid, rresp,
               output awvalid, awaddr, awid, awsize,awlen,awburst,
                      wvalid, wdata, wlast,wid,wstrb, bready,
                      arvalid, araddr, arid, arsize,arlen,arburst, rready);

endinterface 

