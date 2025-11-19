/*------------------------------------------------------------------------------------------------------------------
          Name      : Jyoti Vishwakarma
          File Name : tx2rx_cluster_scoreboard.sv
          Date      : Oct 7
	  Descr..   : Data in form axi_stream_slv will will compare here using out_of_order scoreboard library,
	              Where Id is VCID and value is tdata_q, it also
		        ------------------------------------------------------------------------------------------------------------------ */

`ifndef TX2RX_CLUSTER_SCOREBOARD
`define TX2RX_CLUSTER_SCOREBOARD

typedef bit [`DATA_WIDTH] tdata_q_array_type[$];

   `include"final_out_of_order_scr_emac.sv"

   `uvm_analysis_imp_decl(_mon) 
   `uvm_analysis_imp_decl(_ref)

class emac_tx2rx_scrbd extends uvm_scoreboard;

   int tdata_comparison = 1;
   int frame_comparison = 1;

   `uvm_component_utils_begin(emac_tx2rx_scrbd)
   `uvm_field_int(tdata_comparison ,UVM_ALL_ON)
   `uvm_field_int(frame_comparison ,UVM_ALL_ON)
   `uvm_component_utils_end

 
   uvm_out_oder_scorboard_lib#( bit [`DATA_WIDTH] ,int)    scrbd;
   //uvm_out_oder_scorboard_lib#(  ,int)    scrbd_frame;


   uvm_analysis_imp_mon#(axi_str_mas_seq_item #(`DATA_WIDTH, `USER_WIDTH),emac_tx2rx_scrbd)  act_mon_port[];
   uvm_analysis_imp_ref#(axi_str_mas_seq_item #(`DATA_WIDTH, `USER_WIDTH),emac_tx2rx_scrbd)  exp_ref_port;


   function new (string name, uvm_component parent = null);

            super.new(name, parent);

            scrbd           = uvm_out_oder_scorboard_lib#(bit [`DATA_WIDTH],int)::type_id::create("scrbd",this); 

            exp_ref_port    = new("exp_ref_port",this);
            act_mon_port    = new[`NO_OF_OUTPUT_PORT];
            foreach(act_mon_port[i]) act_mon_port[i] = new($sformatf("act_mon_port[%0d]",i), this); 

            endfunction 
 
   function void build_phase(uvm_phase phase);

            super.build_phase(phase);
            endfunction
 
   /*--------------------------WRITE_METHOD OF ANALYSIS_PORTS----------------------------*/

   function write_mon(axi_str_mas_seq_item #(`DATA_WIDTH, `USER_WIDTH) act_trans);

            if(tdata_comparison)begin
            scrbd.set_act_buffer( act_trans.tdata_q[3][31 -: 8], act_trans.tdata_q);

	    //As T type is of of que type  
	    //Part selection to fetch vcid
	    end

	    if(frame_comparison) begin 
		 
	    end


            endfunction
 
   function write_ref(axi_str_mas_seq_item #(`DATA_WIDTH,`USER_WIDTH) exp_trans);

            if(tdata_comparison)begin
            scrbd.set_exp_buffer( exp_trans.tdata_q[3][31 -: 8], exp_trans.tdata_q); 
        
            end

	    if(frame_comparison) begin 
	
            end

            endfunction

             
   task run_phase(uvm_phase phase);

            super.run_phase(phase);
            if(tdata_comparison) scrbd.run_phase(phase);

            endtask
  
   function void check_phase(uvm_phase phase);

            super.check_phase(phase);
            if(tdata_comparison) scrbd.check_phase(phase);
            endfunction

endclass 
`endif





