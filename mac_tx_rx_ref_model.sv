`ifndef MAC_TX_RX_REF_MODEAL
`define MAC_TX_RX_REF_MODEAL
  localparam PORT3_IDX = 0;
  localparam PORT4_IDX = 1;
  localparam PORT5_IDX = 2;
  localparam NUM_PORTS = 3;
class mac_tx_rx_ref_modeal extends uvm_scoreboard;
  `uvm_component_utils(mac_tx_rx_ref_modeal)
  `uvm_analysis_imp_decl (_tx_port3)
  `uvm_analysis_imp_decl (_tx_port4)
  `uvm_analysis_imp_decl (_tx_port5)
    reg_block ral;//FOR DUT CFG
    bit [15:0] valid_etypes[$] = '{16'h0800, 16'h8100};
    string port_names[NUM_PORTS] = '{"PORT3", "PORT4", "PORT5"};
    mac_tx_sequence_item tx_mac_pkt;

    mac_tx_sequence_item tx_mac_port3[$];
    mac_tx_sequence_item tx_mac_port4[$];
    mac_tx_sequence_item tx_mac_port5[$];

    mac_tx_sequence_item valid_mac_pkt_port3[$];
    mac_tx_sequence_item valid_mac_pkt_port4[$];
    mac_tx_sequence_item valid_mac_pkt_port5[$];

    mac_tx_sequence_item valid_pkt_etype_port3[$];
    mac_tx_sequence_item valid_pkt_etype_port4[$];
    mac_tx_sequence_item valid_pkt_etype_port5[$];

    mac_tx_sequence_item valid_pkt_payload_port3[$];
    mac_tx_sequence_item valid_pkt_payload_port4[$];
    mac_tx_sequence_item valid_pkt_payload_port5[$];

    mac_tx_sequence_item valid_conn_cfg_port3 [$];
    mac_tx_sequence_item valid_conn_cfg_port4 [$];
    mac_tx_sequence_item valid_conn_cfg_port5 [$];


    uvm_analysis_imp_tx_port3 #(mac_tx_sequence_item,mac_tx_rx_ref_modeal) port3_imp;
    uvm_analysis_imp_tx_port4 #(mac_tx_sequence_item,mac_tx_rx_ref_modeal) port4_imp;
    uvm_analysis_imp_tx_port5 #(mac_tx_sequence_item,mac_tx_rx_ref_modeal) port5_imp;


   int drop_pkt;//WE NEED TO TAKE SUM OF ALL DROP VARIABLE
   int etype_drop[NUM_PORTS];
   int etype_valid[NUM_PORTS];
   int payload_drop[NUM_PORTS];
   int crc_drop[NUM_PORTS];
   int valid_pkt[NUM_PORTS];
   int pkt_in_port3[NUM_PORTS];
   int pkt_in_port4[NUM_PORTS];
   int pkt_in_port5[NUM_PORTS];
   int cfg_not_found [NUM_PORTS];
   int cfg_found [NUM_PORTS];
   int valid [NUM_PORTS];
   int invalid [NUM_PORTS];
    uvm_tlm_analysis_fifo#(mac_rx_sequence_item) mac_rx_scb_get_fifo;
    mac_rx_sequence_item rx_mac_pkt;

  	function new (string name="",uvm_component parent);
		super.new(name,parent);
      mac_rx_scb_get_fifo=new("mac_rx_scb_get_fifo",this);
      port3_imp = new ("port3_imp",this);
      port4_imp = new ("port4_imp",this);
      port5_imp = new ("port5_imp",this);
	endfunction

  	function void build_phase (uvm_phase phase);
		super.build_phase (phase);
   // mac_data_sampl=axi_str_mas_seq_item #(32,32)::type_id::create("mac_data_sampl");
      tx_mac_pkt=mac_tx_sequence_item::type_id::create("tx_mac_pkt");
      ral=reg_block::type_id::create("ral");
   //ral = env_mac.reg_blk;
   endfunction

  task run_phase(uvm_phase phase);
     super.run_phase (phase);
   forever begin
fork
etype_check();
payload_check();
cnn_cfg_check();
vcid_fatch_port3();
join
     mac_rx_scb_get_fifo.get(rx_mac_pkt);

     `uvm_info("RX_SCB", $sformatf("Converting MAC frame: %s", 
                         rx_mac_pkt.convert2string()), UVM_MEDIUM)

   end
  endtask

 virtual function void add_etype(bit [15:0] new_etype);
    valid_etypes.push_back(new_etype);
    `uvm_info("ETYPE_ADDED", $sformatf("Added: 0x%04h, Now: %p", new_etype, valid_etypes), UVM_LOW)
  endfunction
  
  virtual function void write_tx_port3(mac_tx_sequence_item pkt_port3);//WE CAN CHNAGE NAME TO TX..
    pkt_in_port3[PORT3_IDX]++;
     tx_mac_port3.push_back(pkt_port3); 
     
    `uvm_info("REF_PACKET_ARRIVED", 
              $sformatf("%s: Received packet #%0d (Queue size: %0d)", 
                       port_names[PORT3_IDX], pkt_in_port3[PORT3_IDX], 
                       tx_mac_port3.size()), 
              UVM_LOW)
  foreach (tx_mac_port3[i]) begin
     $display("inside ref model");
    tx_mac_port3[i].print();
     $display("VLAN ID =%h",tx_mac_port3[i].VLAN_ID);
    `uvm_info("REF_MODEL", $sformatf("%s: Converting MAC frame: %s", 
                         port_names[PORT3_IDX],tx_mac_port3[i].convert2string()), UVM_MEDIUM)
  end

   // process_packet(pkt, 3);
  endfunction



  virtual function void write_tx_port4(mac_tx_sequence_item pkt_port4);
    pkt_in_port4[PORT4_IDX]++;
     tx_mac_port4.push_back(pkt_port4); 
       `uvm_info("REF_PACKET_ARRIVED", 
              $sformatf("%s: Received packet #%0d (Queue size: %0d)", 
                       port_names[PORT4_IDX], pkt_in_port4[PORT4_IDX], 
                       tx_mac_port4.size()), 
              UVM_LOW)
     foreach (tx_mac_port4[i]) begin
     `uvm_info("REF_MODEL", $sformatf("%s: Converting MAC frame: %s", 
                         port_names[PORT4_IDX],tx_mac_port4[i].convert2string()), UVM_MEDIUM)
  end

   // process_packet(pkt, 3);
  endfunction

  virtual function void write_tx_port5(mac_tx_sequence_item pkt_port5);
    pkt_in_port5[PORT5_IDX]++;
     tx_mac_port5.push_back(pkt_port5); 
       `uvm_info("REF_PACKET_ARRIVED", 
              $sformatf("%s: Received packet #%0d (Queue size: %0d)", 
                       port_names[PORT5_IDX], pkt_in_port5[PORT5_IDX], 
                       tx_mac_port5.size()), 
              UVM_LOW)
  foreach (tx_mac_port5[i]) begin
     `uvm_info("REF_MODEL", $sformatf("%s: Converting MAC frame: %s", 
                         port_names[PORT5_IDX],tx_mac_port5[i].convert2string()), UVM_MEDIUM)
  end

   // process_packet(pkt, 3);
  endfunction

task etype_check();
  fork
    check_port3_etype();
    check_port4_etype();
    check_port5_etype();
  join_none // BECOUSE OF WAIT STATEMENTS
endtask
task payload_check();
  fork
    check_port3_payload();
    check_port4_payload();
    check_port5_payload();
  join_none
endtask

task cnn_cfg_check();
	fork
		cfg_check_port3();
		cfg_check_port4();
		cfg_check_port5();
	join_none
endtask


task check_port3_etype();
// mac_tx_sequence_item valid_pkt_payload_port3 [$];
//fork
  forever begin
    wait (tx_mac_port3.size() > 0);
    `uvm_info("PORT3_CHECK", $sformatf("Processing %0d packets", tx_mac_port3.size()), UVM_HIGH)
    
    foreach (tx_mac_port3[i]) begin
      if (tx_mac_port3[i].EType inside {valid_etypes}) begin//we can add it in queue array
        `uvm_info("VALID ETYPE", $sformatf("%s: EType=%h", port_names[PORT3_IDX],tx_mac_port3[i].EType), UVM_LOW);
        valid_pkt_etype_port3.push_back(tx_mac_port3[i]);
      end else begin
        etype_drop[PORT3_IDX]++;
        `uvm_info("INVALID ETYPE", $sformatf("%s: EType=%h - DROPPED",port_names[PORT3_IDX], tx_mac_port3[i].EType), UVM_LOW);
      end
    end
    tx_mac_port3.delete(); // Clear after processing
  end
  endtask
//TAKE DIFFRANET METHOD.....
task check_port3_payload();
  forever begin
    wait (valid_pkt_etype_port3.size()>0);
    foreach (valid_pkt_etype_port3[i])begin
      if(valid_pkt_etype_port3[i].payload.size()<=1500)begin
        `uvm_info("VALID PAYLOAD SIZE", $sformatf("%s: payload size=%d",port_names[PORT3_IDX], valid_pkt_etype_port3[i].payload.size()), UVM_DEBUG);
         valid_mac_pkt_port3.push_back(valid_pkt_etype_port3[i]);
        `uvm_info("[RETURN VALID E MAC PKT]","PORT 3",UVM_LOW)
      end else begin
        payload_drop[PORT3_IDX]++;
        `uvm_info("INVALID PAYLOAD SIZE", $sformatf("%s: PAYLOAD SIZE=%d - DROPPED", port_names[PORT3_IDX],valid_pkt_etype_port3[i].payload.size()), UVM_LOW);
      end
    end
    valid_pkt_etype_port3.delete();
  end
//join
endtask

task check_port4_etype();
  forever begin
    wait (tx_mac_port4.size() > 0);
    `uvm_info("PORT4_ETYPE_CHECK", $sformatf("Processing %0d packets", tx_mac_port4.size()), UVM_DEBUG)
    
    foreach (tx_mac_port4[i]) begin
      if (tx_mac_port4[i].EType inside {valid_etypes}) begin
        `uvm_info("VALID ETYPE", $sformatf("%s: EType=%h",port_names[PORT4_IDX], tx_mac_port4[i].EType), UVM_LOW);
        valid_pkt_etype_port4.push_back(tx_mac_port4[i]);
      end else begin
        etype_drop[PORT4_IDX]++;
        `uvm_info("INVALID ETYPE", $sformatf("%s: EType=%h - DROPPED",port_names[PORT4_IDX], tx_mac_port4[i].EType), UVM_LOW);
      end
    end
    tx_mac_port4.delete(); // Clear after processing
  end
endtask
task check_port4_payload();
    forever begin
      wait (valid_pkt_etype_port4.size()>0);
      `uvm_info("PORT4_PAYLOAD_CHECK", $sformatf("Processing %0d packets", valid_pkt_etype_port4.size()), UVM_DEBUG)
      foreach (valid_pkt_etype_port4[i])begin
         if(valid_pkt_etype_port4[i].payload.size()<=1500)begin
          `uvm_info("VALID PAYLOAD", $sformatf("%s: PAYLOAD SIZE=%d",port_names[PORT4_IDX], valid_pkt_etype_port4[i].payload.size()), UVM_DEBUG)
           valid_mac_pkt_port4.push_back(valid_pkt_etype_port4[i]);
      end else begin
        payload_drop[PORT4_IDX]++;
        `uvm_info("INVALID PAYLOAD SIZE", $sformatf("%s: PAYLOAD=%d - DROPPED",port_names[PORT4_IDX], valid_pkt_etype_port4[i].payload.size()), UVM_LOW)
      end
    end
   valid_pkt_etype_port4.delete();
  end
endtask

task check_port5_etype();
  forever begin
    wait (tx_mac_port5.size() > 0);
    `uvm_info("PORT5_ETYPE_CHECK", $sformatf("Processing %0d packets", tx_mac_port5.size()), UVM_HIGH)
    
    foreach (tx_mac_port5[i]) begin
      if (tx_mac_port5[i].EType inside {valid_etypes}) begin
        `uvm_info("VALID ETYPE", $sformatf("%s: EType=%h",port_names[PORT5_IDX], tx_mac_port5[i].EType), UVM_LOW);
        valid_pkt_etype_port5.push_back(tx_mac_port5[i]);
      end else begin
        etype_drop[PORT5_IDX]++;
        `uvm_info("INVALID ETYPE", $sformatf("%s: EType=%h - DROPPED",port_names[PORT5_IDX],  tx_mac_port5[i].EType), UVM_LOW)
      end
    end
    tx_mac_port5.delete(); // Clear after processing
  end
endtask
task check_port5_payload();
  forever begin
    wait(valid_pkt_etype_port5.size()>0);
    `uvm_info("PORT5_ETYPE_CHECK", $sformatf("Processing %0d packets", valid_pkt_etype_port5.size()), UVM_HIGH)
    foreach (valid_pkt_etype_port5[i])begin
      if (valid_pkt_etype_port5[i].payload.size() <= 1500)begin
        `uvm_info("VALID PAYLOAD", $sformatf("%s: payload=%d",port_names[PORT5_IDX],  valid_pkt_etype_port5[i].payload.size()), UVM_HIGH);
        valid_mac_pkt_port5.push_back(valid_pkt_etype_port5[i]);
      end else begin
        payload_drop[PORT5_IDX]++;
        `uvm_info("INVALID PAYLOAD SIZE", $sformatf("%s: PAYLOAD SIZE=%D - DROPPED", port_names[PORT5_IDX], valid_pkt_etype_port5[i].payload.size()), UVM_LOW)
      end
    end
    valid_pkt_etype_port5.delete();
  end
endtask
 
task cfg_check_port3();
   // bit [31:0] port3_data;
    bit [14:0] addr;
    bit [2:0] port_id = 3;
    bit conn_valid_bit;
    uvm_reg_field conn_valid_field; 
    wait (valid_mac_pkt_port3.size() > 0);
    
    foreach(valid_mac_pkt_port3[i]) begin
        addr = {port_id, valid_mac_pkt_port3[i].VLAN_ID};
       // port3_data = ral.cnn_cfg_mem_h[addr].get();
        
        // Get the connection_valid field
         conn_valid_field = ral.cnn_cfg_mem_h[addr].connection_valid;
         conn_valid_bit = conn_valid_field.get();
        
        $display("CNN_CFG[%5d]:  CONN_VALID=%0d", addr,  conn_valid_bit);
        
        if (conn_valid_bit == 1) begin
            valid[PORT3_IDX]++;
            valid_conn_cfg_port3.push_back(valid_mac_pkt_port3[i]);
            `uvm_info("CONNECTION VALID", $sformatf("%s: CONN_VALID=%0d", port_names[PORT3_IDX], conn_valid_bit), UVM_LOW);
        end else begin
            invalid[PORT3_IDX]++;
            `uvm_info("CONNECTION INVALID", $sformatf("%s: CONN_VALID=%0d", port_names[PORT3_IDX], conn_valid_bit), UVM_LOW);
        end
    end
    
    valid_mac_pkt_port3.delete();
endtask

task cfg_check_port4();
       bit [14:0] addr;
       bit [2:0]  port_id = 4;
       bit conn_valid_bit;
       uvm_reg_field conn_valid_field; 
       wait (valid_mac_pkt_port4.size()>0);
       
       foreach (valid_mac_pkt_port4[i])begin
	       addr = {port_id,valid_mac_pkt_port4[i].VLAN_ID};
	       conn_valid_field = ral.cnn_cfg_mem_h[addr].connection_valid;
	       conn_valid_bit = conn_valid_field.get();
	       $display("CNN_CFG[%5d]: CONN_VALID=%0d", addr, conn_valid_bit);

    if (conn_valid_bit == 1) begin
            valid[PORT4_IDX]++;
            valid_conn_cfg_port4.push_back(valid_mac_pkt_port4[i]);
            `uvm_info("CONNECTION VALID", $sformatf("%s: CONN_VALID=%0d", port_names[PORT4_IDX], conn_valid_bit), UVM_LOW);
        end else begin
            invalid[PORT4_IDX]++;
            `uvm_info("CONNECTION INVALID", $sformatf("%s: CONN_VALID=%0d", port_names[PORT4_IDX], conn_valid_bit), UVM_LOW);
        end
    end
    
    valid_mac_pkt_port4.delete();
endtask 

task cfg_check_port5();
       bit [14:0] addr;
       bit [2:0]  port_id = 5;
       bit conn_valid_bit;
       uvm_reg_field conn_valid_field; 
       wait (valid_mac_pkt_port5.size()>0);
       
       foreach (valid_mac_pkt_port5[i])begin
	       addr = {port_id,valid_mac_pkt_port5[i].VLAN_ID};
	       conn_valid_field = ral.cnn_cfg_mem_h[addr].connection_valid;
	       conn_valid_bit = conn_valid_field.get();
	       $display("CNN_CFG[%5d]: CONN_VALID=%0d", addr, conn_valid_bit);

    if (conn_valid_bit == 1) begin
            valid[PORT5_IDX]++;
            valid_conn_cfg_port5.push_back(valid_mac_pkt_port5[i]);
            `uvm_info("CONNECTION VALID", $sformatf("%s: CONN_VALID=%0d", port_names[PORT5_IDX], conn_valid_bit), UVM_LOW);
        end else begin
            invalid[PORT5_IDX]++;
            `uvm_info("CONNECTION INVALID", $sformatf("%s: CONN_VALID=%0d", port_names[PORT5_IDX], conn_valid_bit), UVM_LOW);
        end
    end
    
    valid_mac_pkt_port5.delete();
endtask 

task vcid_fatch_port3();
	bit [14:0] cnn_addr;
	bit [2:0]  port_id =3;
	bit [4:0]  vcid_addr;
	bit [7:0]  vcid;
	uvm_reg_field conn_id_field;
        uvm_reg_field vcid_field;
	wait(valid_conn_cfg_port3.size()>0);

	foreach (valid_conn_cfg_port3[i])begin
		cnn_addr = {port_id,valid_conn_cfg_port3[i].VLAN_ID};
		conn_id_field = ral.cnn_cfg_mem_h[cnn_addr].connection_id;
		vcid_addr = conn_id_field.get();
		`uvm_info("VCID REG ADDR", $sformatf ("VCID_ADDR=%h",vcid_addr),UVM_LOW)
		vcid_field = ral.vcid_reg_h[vcid_addr].vcid;
		vcid = vcid_field.get();
		`uvm_info("VCID", $sformatf ("VCID=%h",vcid),UVM_LOW)
   end	






endtask
endclass
`endif
