/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_mas_base_test.sv

* Purpose : build and run sequence

* Creation Date : 04-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_MAS_BASE_TEST_SV
`define AXI_STR_MAS_BASE_TEST_SV

class axi_str_mas_base_test extends uvm_test; 
 
 //master
  axi_str_mas_uvc master_uvc;
  axi_str_mas_config mas_cfg;
  
  //slave
  axi_str_slv_uvc slave_uvc;
  axi_str_slv_config slv_cfg;

  axi_str_mas_base_seqs master_seq;

  axi_str_mas_user_callback mas_callback_1;
  axi_str_slv_user_callback slv_callback_1;
  `uvm_component_utils(axi_str_mas_base_test) 
   
    //-------------------------------------------------------------------------------- 
     // Method : 
      
       // Arguments : 
        
         // Description : 
          
           //--------------------------------------------------------------------------------- 
   function new (string name="axi_str_mas_base_test", uvm_component parent=null); 
      super.new(name,parent); 
   endfunction: new 
                   
   function void build_phase(uvm_phase phase);
      //master
      master_uvc = axi_str_mas_uvc #(.DATA_SIZE(32),.USER_SIZE(32)) ::type_id::create("master_uvc",this);
      mas_cfg = axi_str_mas_config :: type_id::create("mas_cfg");
      master_seq = axi_str_mas_base_seqs#(`DATA_WIDTH,`USER_WIDTH)::type_id::create("master_seq");
      mas_cfg.no_of_axis_mas = 3;
      uvm_config_db #(axi_str_mas_config)::set(this,"*","no_master",mas_cfg);
      //uvm_config_db #(axi_str_mas_config)::set(this,"*","m_cfg",mas_cfg);
      //slave
      slave_uvc = axi_str_slv_uvc #(.DATA_SIZE(32),.USER_SIZE(32))::type_id::create("slave_uvc",this);
      slv_cfg = axi_str_slv_config  ::type_id::create("slv_cfg");
      slv_cfg.no_of_axis_slv = 3;
      uvm_config_db #(axi_str_slv_config)::set(this,"*","no_slave",slv_cfg);
      //uvm_config_db #(axi_str_slv_config)::set(this,"*","s_cfg",slv_cfg);

      mas_callback_1 = axi_str_mas_user_callback::type_id::create("mas_callback_1");
      slv_callback_1 = axi_str_slv_user_callback::type_id::create("slv_callback_1");

   endfunction : build_phase

   function void end_of_elaboration_phase(uvm_phase phase);
     uvm_top.print_topology(); 
   endfunction : end_of_elaboration_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		     begin
          $display($time," : raise objection");
			     //if(master_uvc.master_agent[0].mas_cfg.is_active == UVM_ACTIVE)
           fork
            //   uvm_callbacks# (axi_str_mas_driver, axi_str_mas_drv_callback)::add(master_uvc.master_agent[0].master_drv,mas_callback_1);

			     master_seq.start(master_uvc.master_agent[0].master_seqr);
              //uvm_callbacks# (axi_str_slv_driver, axi_str_slv_user_callback)::add(slave_uvc.slave_agent[0].slave_drv,slv_callback_1);
           join   
	       end
		 #30ns;
		$display($time," we are in  master");
		phase.drop_objection(this);
	endtask
endclass : axi_str_mas_base_test


`endif
