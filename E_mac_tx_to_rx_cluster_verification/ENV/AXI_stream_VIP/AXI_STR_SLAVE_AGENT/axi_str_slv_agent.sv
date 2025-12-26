/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_slv_agent.sv

* Purpose : build monitor,driver,sequencer

* Creation Date : 08-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_SLV_AGENT_SV
`define AXI_STR_SLV_AGENT_SV

class axi_str_slv_agent #(shortint DATA_SIZE=32,int USER_SIZE=32) extends uvm_agent; 

  //virtual interface
  virtual axi_str_slv_inf #(.DATA_SIZE(DATA_SIZE),.USER_SIZE(USER_SIZE)) vif;

  //config active/passive
  axi_str_slv_config slv_cfg;

  axi_str_slv_driver    #(DATA_SIZE,USER_SIZE) slave_drv;
  axi_str_slv_monitor   #(DATA_SIZE,USER_SIZE) slave_mon;
  axi_str_slv_sequencer #(DATA_SIZE,USER_SIZE) slave_seqr;

  `uvm_component_param_utils(axi_str_slv_agent #(DATA_SIZE,USER_SIZE)) 
   
  function new (string name="axi_str_slv_agent", uvm_component parent=null); 
    super.new(name,parent); 
  endfunction: new 
  
  function void build_phase(uvm_phase phase);
     if(!uvm_config_db #(axi_str_slv_config)::get(this,"","s_cfg",slv_cfg))
       `uvm_fatal(get_full_name(),"try again ! slave agent config mode not available")
     
      if(!uvm_config_db #(virtual axi_str_slv_inf #(.DATA_SIZE(DATA_SIZE),.USER_SIZE(USER_SIZE)))::get(this,"","vinf",vif))
        `uvm_fatal(get_full_name(),"try again ! slave agent interface not available")

      //IF Agent mode is ACTIVE
      if(slv_cfg.is_active == UVM_ACTIVE) begin
        slave_drv = axi_str_slv_driver #(DATA_SIZE,USER_SIZE) ::type_id::create("slave_drv",this);
        //slave_seqr = axi_str_slv_sequencer ::type_id::create("slave_seqr",this);
      end
      slave_mon = axi_str_slv_monitor #(DATA_SIZE,USER_SIZE) ::type_id::create("slave_mon",this);
   endfunction : build_phase


   function void connect_phase(uvm_phase phase);
     //IF Agent mode is ACTIVE
     if(slv_cfg.is_active == UVM_ACTIVE) begin
      //slave_drv.seq_item_port.connect(slave_seqr.seq_item_export);
      slave_drv.vif = vif;
     end
     slave_mon.vif = vif;
   endfunction : connect_phase

endclass : axi_str_slv_agent

`endif
