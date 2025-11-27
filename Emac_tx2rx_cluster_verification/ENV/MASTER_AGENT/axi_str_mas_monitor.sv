/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_mas_monitor.sv

* Purpose : activity connvert pin level to transection level (sampling data) 

* Creation Date : 04-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_MAS_MONITOR_SV
`define AXI_STR_MAS_MONITOR_SV
//`include "axi_str_mas_define.sv" //TODO
typedef enum bit {SEQ,NON_SEQ} trans_type;//TODO
class axi_str_mas_monitor #(int DATA_SIZE=32,int USER_SIZE=32) extends uvm_monitor ; 
 
  //virtual interface 
  virtual axi_str_mas_inf #(.DATA_SIZE(DATA_SIZE),.USER_SIZE(USER_SIZE)) vif;

  //factory registration
  `uvm_component_param_utils(axi_str_mas_monitor #(DATA_SIZE,USER_SIZE)) 
  
  uvm_analysis_port #(axi_str_mas_seq_item  #(DATA_SIZE,USER_SIZE)) item_collected_port;
  uvm_analysis_port #(axi_str_mas_seq_item  #(DATA_SIZE,USER_SIZE)) continuous_data_port; //DUMP_buffer
   
  //queue to keep sampled packets from interface
  protected axi_str_mas_seq_item #(DATA_SIZE,USER_SIZE) sampled_pkt_q[$];
  
  //Retain length of the packet
  protected int pkt_len;
  
  //To capture packet end time, its difference with respect to previous packet
  protected realtime pkt_end_time_ps, pkt_end_time_prev_ps, pkt_end_time_diff_ps;
  
  //To capture packet start time, its difference with respect to previous packet
  protected realtime pkt_start_time_ps, pkt_start_time_prev_ps, pkt_start_time_diff_ps;
  
  function new (string name="axi_str_mas_monitor", uvm_component parent=null); 
    super.new(name,parent); 
    item_collected_port=new("item_collected_port",this);
    continuous_data_port=new("continuous_data_port",this);
  endfunction: new 
 
  function void build_phase(uvm_phase phase);
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    wait_reset_relase();
    forever begin
      fork : MONITOR
        
        //thread 1
        begin
          monitor_packet();
        end
      join_none
      
      wait_reset_assert();
      disable MONITOR;
      wait_reset_relase();
    end
  endtask : run_phase

  task wait_reset_relase(); //wait for reset de-assertion
    @(posedge vif.areset_n);
  endtask : wait_reset_relase

  task wait_reset_assert(); //wait for reset assertion
    @(negedge vif.areset_n);
  endtask : wait_reset_assert
   
  //sample packet from axi stream interface and broadcast it to analysis port
  virtual protected task monitor_packet();
    int itr=0,itr_prev=-1;
    trans_type trans = SEQ;
	 
    forever begin
      if(trans==SEQ) begin
        sampled_pkt_q[itr] = axi_str_mas_seq_item #(DATA_SIZE,USER_SIZE) ::type_id::create($sformatf("sampled_pkt_q[%0d]",itr));
        pkt_len=0;
      end  
      @(posedge vif.mon_cb iff vif.mon_cb.tvalid);
      if(vif.mon_cb.tready == 1'b0) begin
        @(posedge vif.mon_cb iff vif.mon_cb.tready);
      end 
	  
	  start_time_calc(itr,itr_prev);
      trans = NON_SEQ;
      sampled_pkt_q[itr].tdata_q.push_back(vif.mon_cb.tdata);/**{8{vif.mon_cb.tkeep}});*/
      `uvm_info("AXI_str_mon",$sformatf(" : data : %0p",sampled_pkt_q[itr].tdata_q),UVM_DEBUG)
      sampled_pkt_q[itr].tkeep_q.push_back(vif.mon_cb.tkeep);
      pkt_len++;
      sampled_pkt_q[itr].pkt_len = pkt_len;
      sampled_pkt_q[itr].tuser = vif.mon_cb.tuser;
	  itr_prev=itr;
      
      continuous_data_port.write(sampled_pkt_q[itr]);	  

      if (vif.mon_cb.tlast) begin
	      end_time_calc(itr);
		
		// Populate the transaction
		item_collected_port.write(sampled_pkt_q[itr]);
		`uvm_info("COLLECT_PKT",$sformatf("data monitoring is : %0s",sampled_pkt_q[itr].sprint()),UVM_DEBUG);
		itr++;
        trans = SEQ;
      end
    end
  endtask : monitor_packet
 
  //calculate start time of a packet, its difference with respect to previous packet
  local function void start_time_calc(int itr, int itr_prev);
	if (itr_prev != itr) begin
	  pkt_start_time_ps=$realtime/1ps;
      pkt_start_time_diff_ps = pkt_start_time_ps - pkt_start_time_prev_ps;
	  sampled_pkt_q[itr].pkt_start_time_ps=pkt_start_time_ps;
	  `uvm_info("COLLECT_PKT_TIME",$sformatf(" : pkt_start_time_ps =%0f, pkt_start_time_prev_ps = %0f, pkt_start_time_diff_ps = %0f",pkt_start_time_ps,pkt_start_time_prev_ps,pkt_start_time_diff_ps), UVM_HIGH)
      pkt_start_time_prev_ps=pkt_start_time_ps;
	end
  endfunction : start_time_calc
	
  //calculate end time of a packet, its difference with respect to previous packet
  local function void end_time_calc(int itr);
    pkt_end_time_ps=$realtime/1ps;
    pkt_end_time_diff_ps = pkt_end_time_ps - pkt_end_time_prev_ps;
    sampled_pkt_q[itr].pkt_end_time_ps=pkt_end_time_ps;
    sampled_pkt_q[itr].pkt_num=itr+1;
   `uvm_info("COLLECT_PKT_TIME",$sformatf(" : pkt_end_time_ps =%0f, pkt_end_time_prev_ps = %0f, pkt_end_time_diff_ps = %0f",pkt_end_time_ps,pkt_end_time_prev_ps,pkt_end_time_diff_ps), UVM_HIGH)
    pkt_end_time_prev_ps=pkt_end_time_ps;
  endfunction

endclass : axi_str_mas_monitor

`endif
