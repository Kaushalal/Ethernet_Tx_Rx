`ifndef AXI_LITE_MAS_DRV
`define AXI_LITE_MAS_DRV

class axi_lite_mas_drv#(int ADDR_WIDTH,int DATA_WIDTH) extends uvm_driver#(axi_lite_mas_seqs_item#(ADDR_WIDTH,DATA_WIDTH));

	int trans_item;
  	int drv_count;
  	virtual axi_lite_mas_inf vif;
  	semaphore sem;

	`uvm_component_param_utils(axi_lite_mas_drv#(ADDR_WIDTH,DATA_WIDTH))
  	
  	function new(string name="axi_lite_mas_drv",uvm_component parent=null);
   	super.new(name,parent);
    	sem=new(1);
  	endfunction : new
  
  	function void build_phase(uvm_phase phase);
   	super.build_phase(phase);
    	if (!uvm_config_db#(virtual axi_lite_mas_inf)::get(this, "", "vif", vif)) begin
      	`uvm_fatal("NO_VIF", "Failed to get virtual interface from config_db")
    	end
  	endfunction : build_phase
  
	// ------------------ updated run_phase ------------------
	task run_phase(uvm_phase phase);
  		super.run_phase(phase);
  		@(posedge vif.ACLK);

  		trans_item = 0;
  		drv_count  = 0;

  		forever begin
    		seq_item_port.get_next_item(req);
    		trans_item++;
    		//$display("[DRV] Received item %0d", trans_item);

    		send_to_inf(req); // perform the transaction

    		drv_count++;
    		seq_item_port.item_done();

    		if (drv_count == trans_item) begin
      		@(posedge vif.ACLK);
      		vif.drv_cb.AWVALID <= 0;
      		vif.drv_cb.WVALID  <= 0;
      		vif.drv_cb.ARVALID <= 0;
    		end
  		end
	endtask : run_phase

	// -------------------------------------------------------
	task write_address_channel(axi_lite_mas_seqs_item#(ADDR_WIDTH,DATA_WIDTH) aw_ch);
  		static int aw_handshake_count = 0;
  		vif.drv_cb.AWADDR  <= aw_ch.addr;
  		vif.drv_cb.AWVALID <= 1;

  		@(posedge vif.ACLK iff (vif.drv_cb.AWREADY && vif.drv_cb.AWVALID));
  		aw_handshake_count++;

  		//$display("[DRV] AW handshake %0d / %0d", aw_handshake_count, trans_item);
	endtask : write_address_channel


  	task write_data_channel(axi_lite_mas_seqs_item#(ADDR_WIDTH,DATA_WIDTH) w_ch);
   	static int w_handshake_count = 0;
    	vif.drv_cb.WVALID <= 1;
    	vif.drv_cb.WDATA  <= w_ch.w_data;
    
  		@(posedge vif.ACLK iff (vif.drv_cb.WREADY && vif.drv_cb.WVALID));
  		w_handshake_count++;

  		//$display("[DRV] W handshake %0d / %0d", w_handshake_count, trans_item);
  endtask : write_data_channel
  
	task write_response_channel();
   	vif.drv_cb.BREADY <= 1;
    	wait(vif.drv_cb.BVALID);
    	//$display($time,":Write response received");
  	endtask : write_response_channel
  	
  	task read_address_channel(axi_lite_mas_seqs_item#(ADDR_WIDTH,DATA_WIDTH) ar_ch);
   	static int ar_handshake_count = 0;
    	vif.drv_cb.ARVALID <= 1;
    	vif.drv_cb.ARADDR <= ar_ch.r_addr;
    
    	@(posedge vif.ACLK iff (vif.drv_cb.ARREADY && vif.drv_cb.ARVALID));
  		ar_handshake_count++;

    	//$display("[DRV] AR handshake %0d / %0d", ar_handshake_count, trans_item);
 	endtask : read_address_channel
  
	task read_data_channel(); 
  		vif.drv_cb.RREADY <= 1;
  		wait(vif.drv_cb.RVALID);
  		//$display($time,":Read data received: 0x%08h", vif.drv_cb.RDATA);
	endtask : read_data_channel

	// ------------------ updated send_to_inf ------------------
	task send_to_inf(axi_lite_mas_seqs_item#(ADDR_WIDTH,DATA_WIDTH) req);
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
	endtask : send_to_inf
endclass : axi_lite_mas_drv
`endif
