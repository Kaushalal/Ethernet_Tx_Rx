/*------------------------------------------------------------------------------------------------------------------
          Name      : Jyoti Vishwakarma
          File Name : tx2rx_cluster_scoreboard.sv
          Date      : Oct 7
	  Descr..   : _order scoreboard library,
	              Where Id is VCID and value is tdata_q, it also
  ------------------------------------------------------------------------------------------------------------------ */
	


`ifndef TX2RX_CLUSTER_SCOREBOARD
`define TX2RX_CLUSTER_SCOREBOARD

typedef bit [`AXI_STR_DATA_SIZE] tdata_q_array_type[$];

   `include"final_out_of_order_scr_emac.sv"

   `uvm_analysis_imp_decl(_frame_mon) 
   `uvm_analysis_imp_decl(_frame_ref)
   `uvm_analysis_imp_decl(_tdata_mon) 
   `uvm_analysis_imp_decl(_tdata_ref)
  

class emac_tx2rx_scrbd extends uvm_scoreboard;

   //Switch to select between tdata comparison or frame comparison
   int tdata_comparison = 1;
   int frame_comparison = 0;

   int exp_vcid_q[$], act_vcid_q[$];  //This collect all expected and actual vcid for tdata comparison.

   `uvm_component_utils_begin(emac_tx2rx_scrbd)
   `uvm_field_int(tdata_comparison ,UVM_ALL_ON)
   `uvm_field_int(frame_comparison ,UVM_ALL_ON)
   `uvm_component_utils_end

   //For tdata comparison 
   uvm_out_oder_scorboard_lib#( bit [`AXI_STR_DATA_SIZE] ,int)    scrbd;

   
   //Implication ports that will collected expected and actual trancation
   //Frame
   uvm_analysis_imp_frame_mon#(emac_rx_seqs_item#(`RX_PAYLOAD_DATA_WIDTH,`RX_FRAME_DATA_WIDTH) ,emac_tx2rx_scrbd)  act_frame_mon_port[]; //rx_mon
   uvm_analysis_imp_frame_ref#(emac_rx_seqs_item#(`RX_PAYLOAD_DATA_WIDTH,`RX_FRAME_DATA_WIDTH) ,emac_tx2rx_scrbd)  exp_frame_ref_port[]; 
   //Tdata
   uvm_analysis_imp_tdata_mon#(axi_str_slv_seq_item #(`AXI_STR_DATA_SIZE,`AXI_STR_USER_SIZE) ,emac_tx2rx_scrbd)   act_tdata_mon_port[]; //axis_slv_mon
   //uvm_analysis_imp_tdata_ref#(axi_str_slv_seq_item #(`AXI_STR_DATA_SIZE,`AXI_STR_USER_SIZE) ,emac_tx2rx_scrbd)   exp_tdata_ref_port[];
   uvm_analysis_imp_tdata_ref#(axi_str_mas_seq_item #(`AXI_STR_DATA_SIZE,`AXI_STR_USER_SIZE) ,emac_tx2rx_scrbd)   exp_tdata_ref_port[];

   function new (string name, uvm_component parent = null);

            super.new(name, parent);

            if(tdata_comparison) scrbd   = uvm_out_oder_scorboard_lib#(bit [`AXI_STR_DATA_SIZE],int)::type_id::create("scrbd",this); 

            //For frame
            exp_frame_ref_port    = new[`NO_OF_OUTPUT_PORT];
            foreach(exp_frame_ref_port[i]) exp_frame_ref_port[i] = new($sformatf("exp_frame_ref_port[%0d]",i), this); 

            act_frame_mon_port    = new[`NO_OF_OUTPUT_PORT];
            foreach(act_frame_mon_port[i]) act_frame_mon_port[i] = new($sformatf("act_frame_mon_port[%0d]",i), this); 

            //For tdata
            exp_tdata_ref_port    = new[`NO_OF_OUTPUT_PORT];
            foreach(exp_tdata_ref_port[i]) exp_tdata_ref_port[i] = new($sformatf("exp_tdata_ref_port[%0d]",i), this); 

            act_tdata_mon_port    = new[`NO_OF_OUTPUT_PORT];
            foreach(act_tdata_mon_port[i]) act_tdata_mon_port[i] = new($sformatf("act_tdata_mon_port[%0d]",i), this); 

            endfunction 
 
   function void build_phase(uvm_phase phase);

            super.build_phase(phase);
            endfunction
 
  // --------------------------WRITE_METHOD OF ANALYSIS_PORTS----------------------------

   function write_frame_mon(emac_rx_seqs_item#(`RX_PAYLOAD_DATA_WIDTH,`RX_FRAME_DATA_WIDTH) act_trans);
            
           endfunction
 
   function write_frame_ref(emac_rx_seqs_item#(`RX_PAYLOAD_DATA_WIDTH,`RX_FRAME_DATA_WIDTH)  exp_trans);

            endfunction

   function write_tdata_mon(axi_str_slv_seq_item #(`AXI_STR_DATA_SIZE,`AXI_STR_USER_SIZE) act_trans);
            byte unsigned act_vc_id;
            int temp_act_vcid;
	     
	    temp_act_vcid      = {<<8{act_trans.tdata_q[3]}};
	    act_vc_id = {>>{temp_act_vcid[31 -: 8]}};
            act_vcid_q.push_back(act_vc_id);

	    scrbd.set_act_buffer( act_vc_id , act_trans.tdata_q);
            endfunction
 
   function write_tdata_ref(axi_str_mas_seq_item #(`AXI_STR_DATA_SIZE,`AXI_STR_USER_SIZE) exp_trans);
            byte unsigned exp_vc_id;
            int temp_exp_vcid;

            temp_exp_vcid      = {<<8{exp_trans.tdata_q[3]}};
            exp_vc_id = {>>{temp_exp_vcid[31 -: 8]}}; 

	    exp_vcid_q.push_back(exp_vc_id);
            scrbd.set_exp_buffer( exp_vc_id, exp_trans.tdata_q); 
            endfunction

             
   task run_phase(uvm_phase phase);

            super.run_phase(phase);
            if(tdata_comparison) scrbd.run_phase(phase);
            endtask
  
   function void check_phase(uvm_phase phase);

            super.check_phase(phase);

            if(tdata_comparison) scrbd.check_phase(phase);
            endfunction

   function void report_phase(uvm_phase phase);
            super.report_phase(phase);
	    $display("[SCRBD] : EXPECTED_VCID : %p", exp_vcid_q);
	    $display("[SCRBD] : ACTUAL_VCID   : %p", act_vcid_q);
            endfunction 
endclass 
`endif








