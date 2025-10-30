/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = axi_magent.svh
//  ENGINEER  = Muskan
//  VERSION   = 1.0 
//  DESCRIPTION = contains all macro 
//
/////////////////////////////////////////////////////

`ifndef AXI_MAGENT
`define AXI_MAGENT

class axi_magent #(int DATA_WIDTH = 16 , ADD_WIDTH = 8) extends uvm_agent;

   `uvm_component_param_utils(axi_magent#(DATA_WIDTH, ADD_WIDTH))

   axi_mseqr #(DATA_WIDTH, ADD_WIDTH) mseqr_h; 
   axi_mdrv #(DATA_WIDTH, ADD_WIDTH) mdrv_h; 
   axi_mmon #(DATA_WIDTH, ADD_WIDTH) mmon_h; 
   axi_magt_cfg mcfg_h; 
  
  virtual axi_minf #(DATA_WIDTH, ADD_WIDTH) mvif;

   function new (string name = "axi_magent", uvm_component parent = null);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     
     if(!uvm_config_db #(axi_magt_cfg)::get(this,"", "mcfg_h", mcfg_h))
       `uvm_fatal(get_name(),"Master Config failed to get !!!")
       
       if(mcfg_h.magt_is_active == UVM_ACTIVE) begin
       mseqr_h = axi_mseqr #(DATA_WIDTH, ADD_WIDTH) ::type_id::create("mseqr_h",this);
       mdrv_h = axi_mdrv #(DATA_WIDTH, ADD_WIDTH) ::type_id::create("mdrv_h",this);
       end
       mmon_h = axi_mmon #(DATA_WIDTH, ADD_WIDTH) ::type_id::create("mmon_h",this);
      
     if(!uvm_config_db #(virtual axi_minf#(DATA_WIDTH, ADD_WIDTH))::get(this,"", "mvif", mvif))
       `uvm_fatal(get_name(),"Master Virtual interface failed to get !!!")
       
   endfunction

    function void connect_phase(uvm_phase phase);
      mdrv_h.seq_item_port.connect(mseqr_h.seq_item_export);

     if(mcfg_h.magt_is_active == UVM_ACTIVE) begin
       mdrv_h.mvif = mvif; 
     end 
     mmon_h.mvif = mvif;    

   endfunction

   
endclass 

`endif

