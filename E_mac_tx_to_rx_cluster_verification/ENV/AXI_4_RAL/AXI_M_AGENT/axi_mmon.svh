/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = axi_mmon.svh
//  ENGINEER  = Muskan
//  VERSION   = 1.0 
//  DESCRIPTION = contains all macro 
//
/////////////////////////////////////////////////////

`ifndef AXI_MMON
`define AXI_MMON

 `define MMON_CB mvif.mmon_cb
 `define MMON_MP mvif.MMON_MP

class axi_mmon #(int DATA_WIDTH = 32 , ADD_WIDTH = 32) extends uvm_monitor;

   `uvm_component_param_utils(axi_mmon #(DATA_WIDTH, ADD_WIDTH))
  
    virtual axi_minf #(DATA_WIDTH, ADD_WIDTH) mvif;
    
    uvm_analysis_port #(axi_mseq_item #(32,32) ) anl_mport;
  
  axi_mseq_item #(DATA_WIDTH,ADD_WIDTH) witem_arr[ int ];
  axi_mseq_item #(DATA_WIDTH,ADD_WIDTH) ritem_arr[ int ];
  
  bit[7:0] awid_que [$];  // When there is no wid
 
  axi_magt_cfg mcfg_h; 


   function new (string name = "axi_mmon", uvm_component parent = null);
      super.new(name,parent);
   endfunction

   function void build_phase (uvm_phase phase);
     super.build_phase(phase);

     anl_mport = new("anl_mport",this);
       
     if(!uvm_config_db #(axi_magt_cfg)::get(this,"","mcfg_h", mcfg_h))
       `uvm_fatal(get_name()," Master config failed to get in monitor!!!")

   endfunction

  task run_phase (uvm_phase phase);
    forever begin 
       monitor();
    end
  endtask 

  task monitor();
       fork
       get_write_address();
       get_read_address();
       if(mcfg_h.has_wid == 1)
           get_write_data_with_wid();
       else get_write_data_without_wid();
       sample_write_response();
       sample_read_response();
       join
  endtask
  
  task get_write_address ( );

  forever begin 
      @( `MMON_CB ) begin
      if ( `MMON_CB.awvalid && `MMON_CB.awready && mvif.areset )begin

       if( !witem_arr.exists(`MMON_CB.awid))
            witem_arr[`MMON_CB.awid] = new($sformatf(" witem_arr_m[%0d] ",`MMON_CB.awid));

      witem_arr[`MMON_CB.awid].awid    = `MMON_CB.awid; 
      if(mcfg_h.has_wid == 0) awid_que.push_back( `MMON_CB.awid );
      witem_arr[`MMON_CB.awid].awaddr  = ( `MMON_CB.awaddr ); 
      witem_arr[`MMON_CB.awid].awlen   = `MMON_CB.awlen; 
      witem_arr[`MMON_CB.awid].awsize  = `MMON_CB.awsize; 
      witem_arr[`MMON_CB.awid].awburst = `MMON_CB.awburst;

      if( witem_arr[`MMON_CB.awid].awid == witem_arr[`MMON_CB.awid].wid ) begin
         if ( witem_arr[`MMON_CB.awid].wdata.size() == ( witem_arr[`MMON_CB.awid].awlen + 1 ) ) begin  // To ensure that all the data has also arrived 
           witem_arr[`MMON_CB.awid].operation = WRITE;  
           anl_mport.write( witem_arr[`MMON_CB.awid] );
           //$display($time," *** Master Monitor Write ADDR*** ");
          //witem_arr[`MMON_CB.awid].print();
        end
       end
      end
     end
    end
  endtask
   
  task get_read_address ( );

  forever begin
      @(`MMON_CB) begin
      
      if( `MMON_CB.arvalid && `MMON_CB.arready && mvif.areset  ) begin
  
          if( !ritem_arr.exists(`MMON_CB.arid) )
              ritem_arr[`MMON_CB.arid] = new($sformatf(" ritem_arr[%0d] ",`MMON_CB.arid));
     
     ritem_arr[`MMON_CB.arid].arid    = `MMON_CB.arid;
     ritem_arr[`MMON_CB.arid].araddr  = `MMON_CB.araddr;
     ritem_arr[`MMON_CB.arid].arlen   = `MMON_CB.arlen; 
     ritem_arr[`MMON_CB.arid].arsize  = `MMON_CB.arsize; 
     ritem_arr[`MMON_CB.arid].arburst = `MMON_CB.arburst;
     
     ritem_arr[`MMON_CB.arid].operation = READ;  
     //$display($time," *** Master Monitor READ ADDR *** ");
     //ritem_arr[`MMON_CB.arid].print();
     anl_mport.write( ritem_arr[`MMON_CB.arid] );

     end
    end 
   end
  endtask

  task get_write_data_with_wid ( );

  forever begin
      @(`MMON_CB iff mvif.areset ) begin
       if( `MMON_CB.wvalid  && `MMON_CB.wready ) begin

       if(!witem_arr.exists(`MMON_CB.wid))
           witem_arr[`MMON_CB.wid] = new($sformatf(" witem_arr[%0d] ",`MMON_CB.wid));

       witem_arr[`MMON_CB.wid].wid  =  `MMON_CB.wid ;
       witem_arr[`MMON_CB.wid].wdata.push_back(`MMON_CB.wdata);
       witem_arr[`MMON_CB.wid].wstrb.push_back(`MMON_CB.wstrb);
       
       if(`MMON_CB.wlast === 1'b1) begin
         if( witem_arr[`MMON_CB.wid].wid == witem_arr[`MMON_CB.wid].awid ) begin
             witem_arr[`MMON_CB.wid].operation = WRITE;  
             anl_mport.write( witem_arr[`MMON_CB.wid] );
             //$display($time," *** Master Monitor Write Data *** ");
             //witem_arr[`MMON_CB.wid].print();
         end
       end 
     end
    end
   end
  endtask 

 task get_write_data_without_wid( );
  int temp_id;

  forever begin
      @(`MMON_CB iff mvif.areset ) begin
       if( `MMON_CB.wvalid  && `MMON_CB.wready ) begin

       temp_id = awid_que.pop_back();
       //// CHANGED 
       if( !witem_arr.exists(temp_id))
            witem_arr[temp_id] = new($sformatf(" witem_arr_m[%0d] ",temp_id));

       do begin 
       if( witem_arr[temp_id].wdata.size() > 0 ) @(`MMON_CB);
       witem_arr[temp_id].wdata.push_back(`MMON_CB.wdata);
       witem_arr[temp_id].wstrb.push_back(`MMON_CB.wstrb);
       end 
       while(`MMON_CB.wlast != 1'b1);
     
       if( witem_arr[temp_id].wid == witem_arr[temp_id].awid ) begin
         witem_arr[temp_id].operation = WRITE;  
         anl_mport.write( witem_arr[temp_id] );
         //$display( " *** @%0t Master Monitor Write Data *** ",$time);
         //witem_arr[temp_id].print();
        end 
       end
      end
    end
  endtask


  task sample_write_response ( );
  
  forever begin 
      @(`MMON_CB iff mvif.areset ) begin
      if( `MMON_CB.bvalid && `MMON_CB.bready ) begin

     witem_arr[`MMON_CB.bid].bid   = `MMON_CB.bid;
     witem_arr[`MMON_CB.bid].bresp = `MMON_CB.bresp;
         
     //anl_mport.write( witem_arr[`MMON_CB.bid] );
    // $display($time," *** Master Monitor Write Data with response *** ");
     //witem_arr[`MMON_CB.bid].print();
     // Delete existing transaction from array 
     witem_arr.delete(`MMON_CB.bid);
      end
     end
    end
  endtask

  task sample_read_response ( );
  
  forever begin 
      @(`MMON_CB iff mvif.areset ) begin
      
      if( `MMON_CB.rvalid && `MMON_CB.rready ) begin

      ritem_arr[`MMON_CB.rid].rresp.push_back(`MMON_CB.rresp);
      ritem_arr[`MMON_CB.rid].rdata.push_back(`MMON_CB.rdata); 
      if ( `MMON_CB.rlast === 1'b1 ) begin
           //anl_mport.write( ritem_arr[`MMON_CB.rid] );
           //$display($time," *** Master Monitor READ Data with response *** ");
           //ritem_arr[`MMON_CB.rid].print();
           ritem_arr.delete(`MMON_CB.rid);
       end
      end 
     end 
   end  
  endtask
   
endclass  

`endif
