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
   `uvm_analysis_imp_decl(_tdata_mon0) 
   `uvm_analysis_imp_decl(_tdata_mon1) 
   `uvm_analysis_imp_decl(_tdata_mon2) 
   `uvm_analysis_imp_decl(_tdata_ref0)
   `uvm_analysis_imp_decl(_tdata_ref1)
   `uvm_analysis_imp_decl(_tdata_ref2)

class emac_tx2rx_scrbd extends uvm_scoreboard;

   //Switch to select between tdata comparison or frame comparison
   int tdata_comparison = 1;
   int frame_comparison = 0;

   int exp_vcid_q[`NO_OF_OUTPUT_PORT][$], act_vcid_q[`NO_OF_OUTPUT_PORT][$];  //This collect all expected and actual vcid for tdata comparison.

   `uvm_component_utils_begin(emac_tx2rx_scrbd)
   `uvm_field_int(tdata_comparison ,UVM_ALL_ON)
   `uvm_field_int(frame_comparison ,UVM_ALL_ON)
   `uvm_component_utils_end

   //For tdata comparison 
   uvm_out_oder_scorboard_lib#( bit [`AXI_STR_DATA_SIZE] ,int)    scrbd[];

   
   //Implication ports that will collected expected and actual trancation
   //Frame
   uvm_analysis_imp_frame_mon#(emac_rx_seqs_item#(`RX_PAYLOAD_DATA_WIDTH,`RX_FRAME_DATA_WIDTH) ,emac_tx2rx_scrbd)  act_frame_mon_port[]; //rx_mon
   uvm_analysis_imp_frame_ref#(emac_rx_seqs_item#(`RX_PAYLOAD_DATA_WIDTH,`RX_FRAME_DATA_WIDTH) ,emac_tx2rx_scrbd)  exp_frame_ref_port[]; 
   //Tdata
   // uvm_analysis_imp_tdata_mon#(axi_str_slv_seq_item #(`AXI_STR_DATA_SIZE,`AXI_STR_USER_SIZE) ,emac_tx2rx_scrbd)   act_tdata_mon_port[]; //axis_slv_mon
   // uvm_analysis_imp_tdata_ref#(axi_str_mas_seq_item #(`AXI_STR_DATA_SIZE,`AXI_STR_USER_SIZE) ,emac_tx2rx_scrbd)   exp_tdata_ref_port[];
   uvm_analysis_imp_tdata_mon0#(axi_str_slv_seq_item #(`AXI_STR_DATA_SIZE,`AXI_STR_USER_SIZE) ,emac_tx2rx_scrbd)   act_tdata_mon_port0; //axis_slv_mon
   uvm_analysis_imp_tdata_mon1#(axi_str_slv_seq_item #(`AXI_STR_DATA_SIZE,`AXI_STR_USER_SIZE) ,emac_tx2rx_scrbd)   act_tdata_mon_port1; //axis_slv_mon
   uvm_analysis_imp_tdata_mon2#(axi_str_slv_seq_item #(`AXI_STR_DATA_SIZE,`AXI_STR_USER_SIZE) ,emac_tx2rx_scrbd)   act_tdata_mon_port2; //axis_slv_mon
   uvm_analysis_imp_tdata_ref0#(axi_str_mas_seq_item #(`AXI_STR_DATA_SIZE,`AXI_STR_USER_SIZE) ,emac_tx2rx_scrbd)   exp_tdata_ref_port0;
   uvm_analysis_imp_tdata_ref1#(axi_str_mas_seq_item #(`AXI_STR_DATA_SIZE,`AXI_STR_USER_SIZE) ,emac_tx2rx_scrbd)   exp_tdata_ref_port1;
   uvm_analysis_imp_tdata_ref2#(axi_str_mas_seq_item #(`AXI_STR_DATA_SIZE,`AXI_STR_USER_SIZE) ,emac_tx2rx_scrbd)   exp_tdata_ref_port2;

   function new (string name, uvm_component parent = null);

            super.new(name, parent);

            if(tdata_comparison)
	       begin
	       scrbd = new[`NO_OF_OUTPUT_PORT];
	       foreach(scrbd[i])
	       scrbd[i]   = uvm_out_oder_scorboard_lib#(bit [`AXI_STR_DATA_SIZE],int)::type_id::create($sformatf("scrbd[%0d]",i),this); 
               act_tdata_mon_port0  = new("act_tdata_mon_port0",this);  
               act_tdata_mon_port1  = new("act_tdata_mon_port1",this);
               act_tdata_mon_port2  = new("act_tdata_mon_port2",this);
               exp_tdata_ref_port0  = new("exp_tdata_ref_port0",this);
               exp_tdata_ref_port1  = new("exp_tdata_ref_port1",this);
               exp_tdata_ref_port2  = new("exp_tdata_ref_port2",this);
               end
            //For frame
            exp_frame_ref_port    = new[`NO_OF_OUTPUT_PORT];
            foreach(exp_frame_ref_port[i]) exp_frame_ref_port[i] = new($sformatf("exp_frame_ref_port[%0d]",i), this); 

            act_frame_mon_port    = new[`NO_OF_OUTPUT_PORT];
            foreach(act_frame_mon_port[i]) act_frame_mon_port[i] = new($sformatf("act_frame_mon_port[%0d]",i), this); 

            //For tdata
            //exp_tdata_ref_port    = new[`NO_OF_OUTPUT_PORT];
            //foreach(exp_tdata_ref_port[i]) exp_tdata_ref_port[i] = new($sformatf("exp_tdata_ref_port[%0d]",i), this); 

            //act_tdata_mon_port    = new[`NO_OF_OUTPUT_PORT];
            //foreach(act_tdata_mon_port[i]) act_tdata_mon_port[i] = new($sformatf("act_tdata_mon_port[%0d]",i), this); 


            endfunction 
 
   function void build_phase(uvm_phase phase);

            super.build_phase(phase);
            endfunction
 
  // --------------------------WRITE_METHOD OF ANALYSIS_PORTS----------------------------

   function write_frame_mon(emac_rx_seqs_item#(`RX_PAYLOAD_DATA_WIDTH,`RX_FRAME_DATA_WIDTH) act_trans);
            
           endfunction
 
   function write_frame_ref(emac_rx_seqs_item#(`RX_PAYLOAD_DATA_WIDTH,`RX_FRAME_DATA_WIDTH)  exp_trans);

            endfunction

   function write_tdata_mon0(axi_str_slv_seq_item #(`AXI_STR_DATA_SIZE,`AXI_STR_USER_SIZE) act_trans);
            byte unsigned act_vc_id;
            int temp_act_vcid;
	     
	    temp_act_vcid      = {<<8{act_trans.tdata_q[3]}};
	    act_vc_id = {>>{temp_act_vcid[31 -: 8]}};
            act_vcid_q[0].push_back(act_vc_id);

	    scrbd[0].set_act_buffer( act_vc_id , act_trans.tdata_q);
            endfunction

   function write_tdata_mon1(axi_str_slv_seq_item #(`AXI_STR_DATA_SIZE,`AXI_STR_USER_SIZE) act_trans);
            byte unsigned act_vc_id;
            int temp_act_vcid;
	     
	    temp_act_vcid      = {<<8{act_trans.tdata_q[3]}};
	    act_vc_id = {>>{temp_act_vcid[31 -: 8]}};
            act_vcid_q[1].push_back(act_vc_id);

	    scrbd[1].set_act_buffer( act_vc_id , act_trans.tdata_q);
            endfunction

   function write_tdata_mon2(axi_str_slv_seq_item #(`AXI_STR_DATA_SIZE,`AXI_STR_USER_SIZE) act_trans);
            byte unsigned act_vc_id;
            int temp_act_vcid;
	     
	    temp_act_vcid      = {<<8{act_trans.tdata_q[3]}};
	    act_vc_id = {>>{temp_act_vcid[31 -: 8]}};
            act_vcid_q[2].push_back(act_vc_id);

	    scrbd[2].set_act_buffer( act_vc_id , act_trans.tdata_q);
            endfunction

 
   function write_tdata_ref0(axi_str_mas_seq_item #(`AXI_STR_DATA_SIZE,`AXI_STR_USER_SIZE) exp_trans);
            byte unsigned exp_vc_id;
            int temp_exp_vcid;

            temp_exp_vcid      = {<<8{exp_trans.tdata_q[3]}};
            exp_vc_id = {>>{temp_exp_vcid[31 -: 8]}}; 

	    exp_vcid_q[0].push_back(exp_vc_id);
            scrbd[0].set_exp_buffer( exp_vc_id, exp_trans.tdata_q); 
            endfunction

   function write_tdata_ref1(axi_str_mas_seq_item #(`AXI_STR_DATA_SIZE,`AXI_STR_USER_SIZE) exp_trans);
            byte unsigned exp_vc_id;
            int temp_exp_vcid;

            temp_exp_vcid      = {<<8{exp_trans.tdata_q[3]}};
            exp_vc_id = {>>{temp_exp_vcid[31 -: 8]}}; 

	    exp_vcid_q[1].push_back(exp_vc_id);
            scrbd[1].set_exp_buffer( exp_vc_id, exp_trans.tdata_q); 
            endfunction

  function write_tdata_ref2(axi_str_mas_seq_item #(`AXI_STR_DATA_SIZE,`AXI_STR_USER_SIZE) exp_trans);
            byte unsigned exp_vc_id;
            int temp_exp_vcid;

            temp_exp_vcid      = {<<8{exp_trans.tdata_q[3]}};
            exp_vc_id = {>>{temp_exp_vcid[31 -: 8]}}; 

	    exp_vcid_q[2].push_back(exp_vc_id);
            scrbd[2].set_exp_buffer( exp_vc_id, exp_trans.tdata_q); 
            endfunction


             
   task run_phase(uvm_phase phase);

            super.run_phase(phase);
            if(tdata_comparison) begin
                                
		                 scrbd[0].run_phase(phase);
		                 scrbd[1].run_phase(phase);
		                 scrbd[2].run_phase(phase);
                                 end
            endtask
  
   function void check_phase(uvm_phase phase);

          //  super.check_phase(phase);

          //  if(tdata_comparison) scrbd.check_phase(phase);
            endfunction

   function void report_phase(uvm_phase phase);
            super.report_phase(phase);
           foreach(exp_vcid_q[i]) 
	   begin
	   $display("");
	   $display("  ----  Scoreboard exp - act VCID's  for port %0d  ", i );
	   $display("no_of_pkt recevied -> exp :%0d act :%0d  ", exp_vcid_q[i].size(),act_vcid_q[i].size());
	   $display("");
           $display("EXPECTED");      
       	   foreach(exp_vcid_q[i][j]) $write(" [%0d] : 'd%0d  ",  j, exp_vcid_q[i][j]);
    
           $display("\nACUTAL");      
	   foreach(act_vcid_q[i][j]) $write(" [%0d] : 'd%0d  " , j,  act_vcid_q[i][j]);
	   $display("");
           end
           endfunction 
endclass 
`endif








