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

   int tdata_comparison = 0;
   int frame_comparison = 1;

   `uvm_component_utils_begin(emac_tx2rx_scrbd)
   `uvm_field_int(tdata_comparison ,UVM_ALL_ON)
   `uvm_field_int(frame_comparison ,UVM_ALL_ON)
   `uvm_component_utils_end

 
   uvm_out_oder_scorboard_lib#( bit [`DATA_WIDTH] ,int)    scrbd;
   uvm_out_oder_scorboard_lib#( bit [47:0] ,int)           scrbd_da;;
   uvm_out_oder_scorboard_lib#( bit [47:0] ,int)           scrbd_sa;;
   uvm_out_oder_scorboard_lib#( bit [7:0]  ,int)           scrbd_payload;
   uvm_out_oder_scorboard_lib#( bit [15:0] ,int)           scrbd_etype;;


   uvm_analysis_imp_mon#(emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) ,emac_tx2rx_scrbd)  act_mon_port[];
   uvm_analysis_imp_ref#(emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) ,emac_tx2rx_scrbd)  exp_ref_port[];


   function new (string name, uvm_component parent = null);

            super.new(name, parent);

            scrbd           = uvm_out_oder_scorboard_lib#(bit [`DATA_WIDTH],int)::type_id::create("scrbd",this); 
            scrbd_da        = uvm_out_oder_scorboard_lib#(bit [47:0],int)::type_id::create("scrbd_da",this); 
            scrbd_sa        = uvm_out_oder_scorboard_lib#(bit [47:0],int)::type_id::create("scrbd_sa",this); 
            scrbd_payload   = uvm_out_oder_scorboard_lib#(bit [7:0] ,int)::type_id::create("scrbd_payload",this); 
            scrbd_etype     = uvm_out_oder_scorboard_lib#(bit [15:0],int)::type_id::create("scrbd_etype",this); 

            exp_ref_port    = new[`NO_OF_OUTPUT_PORT];
            foreach(exp_ref_port[i]) exp_ref_port[i] = new($sformatf("exp_ref_port[%0d]",i), this); 

            act_mon_port    = new[`NO_OF_OUTPUT_PORT];
            foreach(act_mon_port[i]) act_mon_port[i] = new($sformatf("act_mon_port[%0d]",i), this); 

            endfunction 
 
   function void build_phase(uvm_phase phase);

            super.build_phase(phase);
            endfunction
 
   /*--------------------------WRITE_METHOD OF ANALYSIS_PORTS----------------------------*/

   function write_mon(emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) act_trans);
               
	        
            
	    if(tdata_comparison)begin
            // scrbd.set_act_buffer( act_vc_id , act_trans.tdata_q);
	    end

	    if(frame_comparison) begin 

               scrbd_da.set_act_buffer( act_trans.vcid, act_trans.dest_mac_addr); 
               scrbd_sa.set_act_buffer( act_trans.vcid, act_trans.source_mac_addr); 

	       foreach(act_trans.payload[i]) 
               scrbd_payload.set_act_buffer( act_trans.vcid, act_trans.payload[i]); 

               scrbd_etype.set_act_buffer( act_trans.vcid, act_trans.e_type); 
	       end
            endfunction
 
   function write_ref(emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)  exp_trans);
          
	    

            if(tdata_comparison)begin
            //scrbd.set_exp_buffer( exp_trans.tdata_q[3][31 -: 8], exp_trans.tdata_q); 
        
            end

	    if(frame_comparison) begin 
               scrbd_da.set_exp_buffer( exp_trans.vcid, exp_trans.dest_mac_addr); 
               scrbd_sa.set_exp_buffer( exp_trans.vcid, exp_trans.source_mac_addr); 
                 
	       foreach(exp_trans.payload[i])  
               scrbd_payload.set_exp_buffer( exp_trans.vcid, exp_trans.payload[i]); 

               scrbd_etype.set_exp_buffer( exp_trans.vcid, exp_trans.e_type); 	
               end

            endfunction

             
   task run_phase(uvm_phase phase);

            super.run_phase(phase);
            if(tdata_comparison) scrbd.run_phase(phase);
            if(frame_comparison)
	       fork
               scrbd_da.run_phase(phase);
               scrbd_sa.run_phase(phase);
               scrbd_payload.run_phase(phase);
               scrbd_etype.run_phase(phase);
               join

            endtask
  
   function void check_phase(uvm_phase phase);

            super.check_phase(phase);
            if(tdata_comparison) scrbd.check_phase(phase);
            if(frame_comparison)begin
               scrbd_da.check_phase(phase);
               scrbd_sa.check_phase(phase);
               scrbd_payload.check_phase(phase);
               scrbd_etype.check_phase(phase);
               end

            endfunction
  
endclass 
`endif





