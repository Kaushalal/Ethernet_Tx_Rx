/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_mas_driver.sv

* Purpose : convert transsection level to pin level (sequence item to interface pin)

* Creation Date : 04-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_MAS_DRIVER_SV
`define AXI_STR_MAS_DRIVER_SV
`include "axi_str_mas_define.sv"
typedef enum bit { MANUAL, RANDOM} tvalid_drv_mode_enum; //TODO

class axi_str_mas_driver #(int DATA_SIZE=32,int USER_SIZE=32) extends uvm_driver #(axi_str_mas_seq_item #(DATA_SIZE,USER_SIZE)); 
   
   //virtual interface
   //virtual axi_str_mas_inf #(.DATA_SIZE(DATA_SIZE),.USER_SIZE(USER_SIZE)) vif; //TODO direct value in vif

  virtual axi_str_mas_inf #(.DATA_SIZE(DATA_SIZE),.USER_SIZE(USER_SIZE)) vif;
   //int i;

   
   //Counter to track packet counts
  protected byte unsigned packet_count=1;

  //
  bit ready_rcvd_flag;
  event ready_rcvd_ev;

  //factory registration
  `uvm_component_param_utils_begin(axi_str_mas_driver #(DATA_SIZE,USER_SIZE)) 
    `uvm_field_int(packet_count, UVM_PRINT | UVM_UNSIGNED)
  `uvm_component_utils_end 
   
   //callback registeration
   `uvm_register_cb(axi_str_mas_driver,axi_str_mas_drv_callback)

  function new (string name="axi_str_mas_driver", uvm_component parent=null); 
     super.new(name,parent); 
  endfunction: new 
  
  virtual task run_phase(uvm_phase phase);
    initialize();
    if(!vif.areset_n)
    wait_reset_relase();
    forever begin
      fork : RUN
        //thread 1
        forever begin
          seq_item_port.get_next_item(req);
          `uvm_info(get_full_name(),$sformatf("req_data_in_driver : %0s",req.sprint()),UVM_DEBUG);
          drive_to_inf(req);
          seq_item_port.item_done();
        end
      join_any

      wait_reset_assert();
      disable RUN;
      wait_reset_relase();
    end
  endtask : run_phase

  task wait_reset_relase(); //wait for reset 0 to 1
    @(posedge vif.areset_n);
  endtask : wait_reset_relase

  task wait_reset_assert(); //wait for reset apply 1,x to 0
    @(negedge vif.areset_n);
  endtask : wait_reset_assert
  
  virtual protected task initialize();
    vif.drv_cb.tvalid <= 0;
    vif.drv_cb.tdata  <= 0;
    vif.drv_cb.tkeep  <= 0;
    vif.drv_cb.tlast  <= 0;
    vif.drv_cb.tuser  <= 0;
  endtask : initialize

  virtual protected task drive_to_inf(axi_str_mas_seq_item #(DATA_SIZE,USER_SIZE) req);
    byte unsigned n_cycle_dly;
    tvalid_drv_mode_enum tvalid_drv_mode;
    bit tvalid_q [$];
    bit tvalid_tmp;
    shortint unsigned min_itr, max_itr;

    //callback to select random mode for tvalid
    `uvm_do_callbacks(axi_str_mas_driver#(DATA_SIZE,USER_SIZE),axi_str_mas_drv_callback,tvalid_drv_random(packet_count,tvalid_drv_mode,min_itr,max_itr))  
    if (tvalid_drv_mode == RANDOM) begin
      repeat(req.tdata_q.size()-1) tvalid_q.push_back(1'b1);
      repeat($urandom_range(min_itr,max_itr)) tvalid_q.push_back(1'b0);
      tvalid_q.shuffle();
      tvalid_q.push_back(1'b1);  //to keep tvalid 1 at the last index
    end
    for(int i=0;i<=req.pkt_len-1;i++) begin
      if (tvalid_drv_mode == RANDOM) begin
         //toggle tvalid randomly - Method-I
         if (!tvalid_q[i]) begin
            while (!tvalid_q[i]) begin
              vif.drv_cb.tvalid <= 1'b0;
              @(vif.drv_cb);
              tvalid_q.delete(i);
            end
         end
	 else
             if(i==0) @(vif.drv_cb);   //for the first beat of the respective packet
         //toggle tvalid randomly - Method-II
          /*do begin
            tvalid_tmp = $urandom;
            if (!tvalid_tmp) begin 
               vif.drv_cb.tvalid <= 1'b0;
               @(vif.drv_cb);
            end
          end while(!tvalid_tmp);*/
       end
       else begin
         //callback to select MANUAL mode for tvalid and adding wait state customly. 
	 `uvm_do_callbacks(axi_str_mas_driver#(DATA_SIZE,USER_SIZE),axi_str_mas_drv_callback,tvalid_drv_user(packet_count,i,n_cycle_dly));
         `uvm_info("AXI_str_driver",$sformatf(" : n_cycle_dly=%0d",n_cycle_dly),UVM_DEBUG)
         if(n_cycle_dly > 0)
           vif.drv_cb.tvalid <= 1'b0;
         if (!ready_rcvd_ev.triggered) n_cycle_dly++;
         `uvm_info("AXI_str_driver",$sformatf(" : n_cycle_dly=%0d",n_cycle_dly),UVM_DEBUG)
         repeat(n_cycle_dly) begin
          @(vif.drv_cb);
         end 
         n_cycle_dly = 0;
      end  //else
      vif.drv_cb.tvalid <= 1'b1;
      vif.drv_cb.tuser <= req.tuser;
      vif.drv_cb.tdata  <= req.tdata_q.pop_front();
      `uvm_info("tdata_q_axi_str",$sformatf($time," : DEBUG : [%0d]vif.tdata_q : %0h",i,vif.drv_cb.tdata),UVM_DEBUG) //TODO DEBUG
      vif.drv_cb.tkeep  <= req.tkeep_q.pop_front();
      vif.drv_cb.tlast  <= 1'b0;

      if(i == req.pkt_len-1) begin
        vif.drv_cb.tlast <= 1'b1;  
      end
      
      @(posedge vif.drv_cb iff vif.drv_cb.tready);
      ->ready_rcvd_ev;
      /*fork begin
        ready_rcvd_flag=1;
        @(posedge vif.drv_cb);
        ready_rcvd_flag=0;
      end join_none*/
    end   //for
    packet_count++;
    vif.drv_cb.tlast  <= 1'b0;
    vif.drv_cb.tvalid <= 1'b0;
     
  endtask : drive_to_inf
endclass : axi_str_mas_driver

`endif
