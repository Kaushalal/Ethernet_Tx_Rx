/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_slv_driver.sv

* Purpose : driver singals convert from transection level to pin level

* Creation Date : 08-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_SLV_DRIVER_SV

`define AXI_STR_SLV_DRIVER_SV
`include "axi_str_slv_define.sv"
typedef enum bit {SLV_MANUAL, SLV_RANDOM} tready_drv_mode_enum;
class axi_str_slv_driver #(shortint DATA_SIZE=512,int USER_SIZE=1) extends uvm_driver #(axi_str_slv_seq_item #(DATA_SIZE,USER_SIZE));
   
   //virtual interface
   virtual axi_str_slv_inf #(.DATA_SIZE(DATA_SIZE),.USER_SIZE(USER_SIZE)) vif;  //TODO
   
   //Counter to track packet counts
   protected byte unsigned packet_count=1;
   
   int i;

  //factory registration
  `uvm_component_param_utils_begin(axi_str_slv_driver #(DATA_SIZE,USER_SIZE)) 
    `uvm_field_int(packet_count, UVM_PRINT | UVM_UNSIGNED)
  `uvm_component_utils_end 
  
  //callback registeration
  `uvm_register_cb(axi_str_slv_driver,axi_str_slv_drv_callback)
   
  function new (string name="axi_str_slv_driver", uvm_component parent=null); 
     super.new(name,parent); 
  endfunction: new   

  virtual task run_phase(uvm_phase phase);
    initialize();
    if(!vif.areset_n)
      wait_reset_relase();
    forever begin
      fork : RESET
        drive_to_inf();
      join_none
      wait_reset_assert();
      disable RESET;
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
    vif.slv_drv_cb.tready <= 1'b0;
  endtask : initialize

  virtual protected task drive_to_inf();
    int  n_cycle_delay;
    bit tready_tmp;
    tready_drv_mode_enum tready_drv_mode;
    shortint unsigned min_itr, max_itr, tready_low_itr;

    
    forever begin
      tready_drv_mode=SLV_MANUAL;
	  
      //callback to select random mode for tready
      `uvm_do_callbacks(axi_str_slv_driver#(DATA_SIZE,USER_SIZE),axi_str_slv_drv_callback,tready_drv_random(packet_count,tready_drv_mode,min_itr,max_itr))
      if (tready_drv_mode==SLV_RANDOM) tready_low_itr = $urandom_range(min_itr,max_itr);
      do begin
        @(posedge vif.slv_drv_cb iff vif.slv_drv_cb.tvalid);
        if (tready_drv_mode==SLV_RANDOM) begin
          do begin
            tready_tmp = $urandom;
            if ((!tready_tmp) && (tready_low_itr!=0)) begin
              vif.slv_drv_cb.tready <= 1'b0;
              tready_low_itr--;
              @(vif.slv_drv_cb);
            end
          end  while(!tready_tmp);
        end
        else begin
          //callback to select MANUAL mode for tready and adding wait state customly. 
          `uvm_do_callbacks(axi_str_slv_driver#(DATA_SIZE,USER_SIZE),axi_str_slv_drv_callback,tready_drv_user(packet_count,i,n_cycle_delay));
          if(n_cycle_delay > 0) begin
            vif.slv_drv_cb.tready <= 1'b0;
            repeat(n_cycle_delay+1) @(vif.slv_drv_cb);
          end
          n_cycle_delay=0;
        end 
        vif.slv_drv_cb.tready <= 1'b1;
        i++;
        `uvm_info("AXI_str_slv_driver",$sformatf(" : pkt size in  slave i = %0d",i),UVM_DEBUG)
      end while(!vif.slv_drv_cb.tlast);
      `uvm_info("AXI_str_slv_driver"," : TLAST is asserted",UVM_DEBUG)
      fork
        begin
          @(vif.slv_drv_cb);
          if (!vif.slv_drv_cb.tvalid)
          vif.slv_drv_cb.tready <= 1'b0;
        end
      join_none
      packet_count++;
    end
  endtask : drive_to_inf

endclass : axi_str_slv_driver
`endif
