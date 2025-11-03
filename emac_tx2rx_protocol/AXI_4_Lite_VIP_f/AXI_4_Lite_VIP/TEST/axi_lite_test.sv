`ifndef AXI_LITE_TEST
`define AXI_LITE_TEST

`include "axi_lite_pkg.sv"
import axi_lite_pkg::*;

class axi_lite_test extends uvm_test;

	`uvm_component_utils(axi_lite_test)
  	axi_lite_env env;
   axi_lite_mas_cfg mas_config;
  	axi_lite_seqs#(ADDR_WIDTH,DATA_WIDTH) m_seq_h;
  
  	function new(string name="axi_lite_test",uvm_component parent=null);
		super.new(name,parent);
	endfunction : new

  	function void build_phase (uvm_phase phase);
		super.build_phase (phase);
      env=axi_lite_env::type_id::create("env",this);
      m_seq_h=axi_lite_seqs#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("m_seq_h",this);
      mas_config=axi_lite_mas_cfg::type_id::create("axi_lite_mas_cfg");
      mas_config.no_of_axi_lite_mas=3;
      uvm_config_db #(axi_lite_mas_cfg)::set(this,"*","no_master",mas_config);
      uvm_config_db #(axi_lite_mas_cfg)::set(this,"*","m_cfg",mas_config);
	endfunction : build_phase

	function void end_of_elaboration_phase (uvm_phase phase);
   	super.end_of_elaboration_phase (phase);
    	uvm_top.print_topology();
  	endfunction : end_of_elaboration_phase

	task run_phase (uvm_phase phase);
		super.run_phase (phase);
	   phase.raise_objection(this);
      m_seq_h.start(env.m_agent.m_seqr);
      #40;
		phase.drop_objection(this);
	endtask : run_phase

endclass : axi_lite_test
`endif

