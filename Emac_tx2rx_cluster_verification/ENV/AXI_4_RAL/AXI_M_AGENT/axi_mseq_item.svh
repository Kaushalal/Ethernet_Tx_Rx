/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = axi_mseq_items.svh
//  ENGINEER  = Muskan
//  VERSION   = 1.0 
//  DESCRIPTION = contains all macro 
//
/////////////////////////////////////////////////////

`ifndef AXI_MSEQ_ITEM
`define AXI_MSEQ_ITEM

 typedef enum bit [1:0] { FIXED, INCR, WRAP } axi_burst_me;
 typedef enum bit [1:0] { OKAY, EX_OKAY, SLVERR, DECERR } axi_resp_me;
 typedef enum bit [2:0] {
    size_1_BYTE    = 3'b000,
    size_2_BYTES   = 3'b001,
    size_4_BYTES   = 3'b010,
    size_8_BYTES   = 3'b011,
    size_16_BYTES  = 3'b100,
    size_32_BYTES  = 3'b101,
    size_64_BYTES  = 3'b110,
    size_128_BYTES = 3'b111
 } axi_size_me;

typedef enum bit[1:0] { READ, WRITE, SIM_WR } operation_me;

class axi_mseq_item #( int DATA_WIDTH = 64 , ADD_WIDTH = 32) extends uvm_sequence_item;
  
  local rand int start_lane;
  
  local rand bit[7:0] no_of_bytes_w;
  local rand bit[7:0] no_of_bytes_r;
  
  rand operation_me operation; 
  
//-------------------------------------- WRITE ADDRESS --------------------------//
   randc bit [7:0] awid;
   randc bit [(ADD_WIDTH-1) : 0 ] awaddr;
   rand bit [7:0] awlen;
   rand axi_size_me awsize;
   
   rand axi_burst_me awburst;

// ---------------------------------------WRITE DATA ---------------------------//
   rand bit [7:0] wid;
   rand bit [(DATA_WIDTH-1) : 0] wdata[$];
   rand bit [((DATA_WIDTH/8) - 1 ) : 0] wstrb[$];
   rand bit wlast;

//-------------------------------------- WRITE RESPONSE ------------------------//
   bit [7:0] bid;
   axi_resp_me bresp;

//-------------------------------------- READ ADDRESS ------------------------- //
   randc bit [7:0] arid;
   randc bit [(ADD_WIDTH-1) : 0 ] araddr;
   rand bit [7:0] arlen;
   rand axi_size_me arsize;
   
   rand axi_burst_me arburst;

// -------------------------------------- READ DATA ---------------------------- //
    bit [7:0] rid;
    bit [(DATA_WIDTH-1) : 0] rdata[$];
    axi_resp_me rresp[$];
    bit rlast;

  `uvm_object_param_utils_begin(axi_mseq_item #(DATA_WIDTH, ADD_WIDTH))
  
      `uvm_field_enum (operation_me, operation, UVM_ALL_ON | UVM_STRING )
      `uvm_field_int ( awid, UVM_ALL_ON | UVM_DEC )
      `uvm_field_int ( awaddr, UVM_ALL_ON | UVM_HEX )
      `uvm_field_int ( awlen, UVM_ALL_ON | UVM_DEC )
      `uvm_field_enum (axi_size_me, awsize, UVM_ALL_ON | UVM_STRING )
      `uvm_field_enum (axi_burst_me, awburst, UVM_ALL_ON | UVM_STRING )
  
  
      `uvm_field_int ( wid, UVM_ALL_ON | UVM_DEC )
      `uvm_field_queue_int ( wdata, UVM_ALL_ON | UVM_HEX )
      `uvm_field_queue_int ( wstrb, UVM_ALL_ON | UVM_BIN )
  
      `uvm_field_int ( bid, UVM_ALL_ON | UVM_DEC )
      `uvm_field_enum (axi_resp_me, bresp, UVM_ALL_ON | UVM_STRING )
  
  
      `uvm_field_int ( arid, UVM_ALL_ON | UVM_DEC )
      `uvm_field_int ( araddr, UVM_ALL_ON | UVM_HEX )
      `uvm_field_int ( arlen, UVM_ALL_ON | UVM_DEC )
      `uvm_field_enum (axi_size_me, arsize, UVM_ALL_ON | UVM_STRING )  
      `uvm_field_enum (axi_burst_me, arburst, UVM_ALL_ON | UVM_STRING )
  
  
      `uvm_field_int ( rid, UVM_ALL_ON | UVM_DEC )
      `uvm_field_queue_int ( rdata, UVM_ALL_ON | UVM_HEX )
      `uvm_field_int ( rlast, UVM_ALL_ON ) 
      `uvm_field_queue_enum (axi_resp_me, rresp, UVM_ALL_ON | UVM_STRING )
  
   `uvm_object_utils_end
  
       // constraint incr_lenw { if (awburst == INCR) { awlen > 0 }; }
        constraint wrap_lenw { if (awburst == WRAP) { awlen inside { 1,3,7,15 };} }
        constraint fixed_lenw { if (awburst == FIXED) { awlen inside { [0:15] }; } }
          
      //  constraint incr_lenr { if (arburst == INCR) { arlen > 0 }; }
        constraint wrap_lenr { if (arburst == WRAP) { arlen inside { 1,3,7,15 };} }
        constraint fixed_lenr { if (arburst == FIXED) { arlen inside { [0:15] }; } } 
                  
        constraint no_of_bytes_cw { no_of_bytes_w == 2**awsize ; solve awsize before no_of_bytes_w; }
        constraint awsize_cw { no_of_bytes_w <= (DATA_WIDTH / 8) ;}
        
        constraint no_of_bytes_cr { no_of_bytes_r == 2**arsize ; solve arsize before no_of_bytes_r; }
        constraint awsize_cr { no_of_bytes_r <= (DATA_WIDTH / 8) ;}  
          
        constraint wdata_que_c { wdata.size() == (awlen + 1)  ; solve awlen before wdata; }  
        constraint wstrb_que_c { wstrb.size() == (awlen + 1) ; solve awlen before wstrb; }  

        constraint four_kb_limit_c { (awlen + 1) ** no_of_bytes_w <= 4096 ; (arlen + 1) ** no_of_bytes_r <= 4096 ; }
         
       // constraint strb_c1 { start_lane == (awaddr % (DATA_WIDTH / 8)); }
        constraint strb_c1 { start_lane == (awaddr % no_of_bytes_w); }

        constraint strb_c2 { if ( ( start_lane == 0)&& (no_of_bytes_w == (DATA_WIDTH / 8)) )  { foreach( wstrb[i,j] ) 
                                                                                              { wstrb[i][j] == 1'b1 }; } }

        constraint strb_c3 { if ( ( start_lane > 0 ) && (no_of_bytes_w == (DATA_WIDTH / 8)) )  { foreach( wstrb[i,j] ) 
                                                                                                if( (i == 0) && (j<start_lane) )
                                                                                                { wstrb[i][j] == 1'b0 ;} else { wstrb[i][j] == 1'b1 ;} } }
                    
        constraint alligned_raddr_c {  if( arburst == WRAP ) { foreach(araddr[i])
                                                               if( i<arsize )
                                                                { araddr[i] == 1'b0 }; } }
                                                                            
        constraint alligned_waddr_c {  if( awburst == WRAP ) { foreach(awaddr[i])
                                                               if( i<awsize )
                                                                { awaddr[i] == 1'b0 }; } }
        
        //constraint id_1 { awid != arid ;}
        constraint id_2 { wid == awid ;}

                           /*  function void strb_calculation ();
                                 start_lane = awaddr % (DATA_WIDTH / 8);
                                 if(start_lane > 0)
                                   wstrb[0] = wstrb[0] << start_lane;               
                               endfunction */

 function void strb_calculation ();
   int temp = start_lane;
   int j;

   //$display(" start lane / temp = %0d",temp); 
   //$display(" awaddr = %h",awaddr); 
    for(int i=0; i<=awlen; i++)begin
      wstrb[i] = 'b0;
      if(temp % no_of_bytes_w == 0 ) begin
        for( j = temp; j<(no_of_bytes_w+temp); j++ )begin
           wstrb[i][j] = 1'b1; 
        end
        if ( j == (DATA_WIDTH/8) ) temp = 0;
        else temp = j;
      end
      else while ( (temp % no_of_bytes_w) != 0 ) begin
           wstrb[i][temp] = 1'b1;
           temp++;
      end 
      if ( temp == (DATA_WIDTH/8) ) temp = 0;
     end 

  endfunction
          
                           /* function bit [(ADD_WIDTH-1) : 0 ] alligned_awaddr ( );
                               if( awburst == WRAP && operation == WRITE || SIM_WR ) begin 
                                 for ( int i=0; i<=awsize; i++ )begin
                                   awaddr[i] = 'b0;
                                 end
                               end 
                               return awaddr;
                            endfunction 
                               
                            function bit [(ADD_WIDTH-1) : 0 ] alligned_araddr ( ); 
                               if( arburst == WRAP && operation == READ || SIM_WR ) begin
                                   for ( int i=0; i<=arsize; i++ )begin
                                     araddr[i] = 'b0;
                                   end
                               end 
                               return araddr;
                            endfunction  */

   function void post_randomize ();
// //                                  void'( alligned_awaddr() );
// //                                  void'( alligned_araddr() );
//  $display(" no_of_bytes_w = %0d || start_lane = %0d || ", no_of_bytes_w, start_lane );
    if (no_of_bytes_w < (DATA_WIDTH / 8))
         strb_calculation();
    endfunction
    
   function new (string name = "axi_mseq_item");
      super.new(name);
   endfunction

   
endclass 
 

`endif

