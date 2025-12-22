`ifndef AXI_LITE_MAS_DRIVER
`define AXI_LITE_MAS_DRIVER

class axi_lite_mas_driver#(int ADDR_WIDTH,int DATA_WIDTH) extends uvm_driver#(axi_lite_mas_sequence_item#(ADDR_WIDTH,DATA_WIDTH));
  `uvm_component_param_utils(axi_lite_mas_driver#(ADDR_WIDTH,DATA_WIDTH))
  bit reset_ctr = 0; 
  int trans_item;
  int drv_count;
  virtual axi_lite_mas_interface vif;
  semaphore sem;
  
  function new(string name="",uvm_component parent);
    super.new(name,parent);
    sem=new(1);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi_lite_mas_interface)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NO_VIF", "Failed to get virtual interface from config_db")
    end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    // Initialize signals
    vif.drv_cb.AWVALID <= 0;
    vif.drv_cb.WVALID  <= 0;
    vif.drv_cb.BREADY  <= 1;
    vif.drv_cb.ARVALID <= 0;
    vif.drv_cb.RREADY  <= 1;
    vif.drv_cb.AWADDR  <= 0;
    vif.drv_cb.WDATA   <= 0;
    vif.drv_cb.ARADDR  <= 0;
    
    @(posedge vif.ACLK);
    
    trans_item = 0;
    drv_count  = 0;

    forever begin
      seq_item_port.get_next_item(req);
      trans_item++;
      $display("[DRV] Received item %0d", trans_item);
      wait(vif.ARESETn);
      if(reset_ctr==0)begin
      @(posedge vif.ACLK);
      reset_ctr++;
      end
      @(posedge vif.ACLK);
      send_to_inf(req); // perform the transaction

      drv_count++;
      seq_item_port.item_done();

      // Drop VALID signals if all transactions completed
      if (drv_count == trans_item) begin
        @(posedge vif.ACLK);
        vif.drv_cb.AWVALID <= 0;
        vif.drv_cb.WVALID  <= 0;
        vif.drv_cb.ARVALID <= 0;
      end
    end
  endtask : run_phase

  task write_address_channel(axi_lite_mas_sequence_item#(ADDR_WIDTH,DATA_WIDTH) aw_ch);
    static int aw_handshake_count = 0;
    
    vif.drv_cb.AWADDR  <= aw_ch.addr;
    vif.drv_cb.AWVALID <= 1;

    @(vif.drv_cb iff (vif.drv_cb.AWREADY && vif.drv_cb.AWVALID));
    aw_handshake_count++;

    $display("[DRV] AW handshake %0d / %0d", aw_handshake_count, trans_item);
  endtask

  task write_data_channel(axi_lite_mas_sequence_item#(ADDR_WIDTH,DATA_WIDTH) w_ch);
    static int w_handshake_count = 0;
    
    vif.drv_cb.WVALID <= 1;
    vif.drv_cb.WDATA  <= w_ch.w_data;
    
    @(vif.drv_cb iff (vif.drv_cb.WREADY && vif.drv_cb.WVALID));
    w_handshake_count++;

    $display("[DRV] W handshake %0d / %0d", w_handshake_count, trans_item);
  endtask
  
  task write_response_channel();
    vif.drv_cb.BREADY <= 1;
    @(vif.drv_cb iff vif.drv_cb.BVALID);
    $display($time,":Write response received");
  endtask
  
  task read_address_channel(axi_lite_mas_sequence_item#(ADDR_WIDTH,DATA_WIDTH) ar_ch);
    static int ar_handshake_count = 0;
    
    vif.drv_cb.ARVALID <= 1;
    vif.drv_cb.ARADDR <= ar_ch.r_addr;
    
    @(vif.drv_cb iff (vif.drv_cb.ARREADY && vif.drv_cb.ARVALID));
    ar_handshake_count++;

    $display("[DRV] AR handshake %0d / %0d", ar_handshake_count, trans_item);
  endtask
  
  task read_data_channel(); 
    vif.drv_cb.RREADY <= 1;
    @(vif.drv_cb iff vif.drv_cb.RVALID);
    $display($time,":Read data received: 0x%08h", vif.drv_cb.RDATA);
  endtask

  task send_to_inf(axi_lite_mas_sequence_item#(ADDR_WIDTH,DATA_WIDTH) req);
    case (req.axi_op_e)
      AXI_LITE_WRITE: begin
        fork
          write_address_channel(req);
          write_data_channel(req);
          write_response_channel();
        join_none
      end

      AXI_LITE_READ: begin
        fork
          read_address_channel(req);
          read_data_channel();
        join_none
      end

      default: `uvm_error("DRV", "Unknown transaction type")
    endcase
  endtask
  
endclass
`endif

