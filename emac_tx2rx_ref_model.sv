`ifndef MAC_TX_RX_REF_MODEL
`define MAC_TX_RX_REF_MODEL

  localparam PORT3_IDX = 0;
  localparam PORT4_IDX = 1;
  localparam PORT5_IDX = 2;
  localparam NUM_PORTS = 3;
  localparam PAYLOAD_DATA_WIDTH = 8;
  localparam FRAME_DATA_WIDTH = 32;
//------------------------------------------------------------------------------------------//
//port0_imp THIS PORT OF REF MODEL CONNECTS WITH MAC TX MON
//JUST LIKE THIS PORT1 AND PORT2 ALSO COONECT WITH THAT
// I WRITE METHOD FOR THAT AT LINE NO 182* METHOD NAME IS (write_tx_port3) and so on..
// NOW FOR TDATA I COONECT AXI STREAM VIP MONITOR DIRECTLY CONNECTED WITH REF MODEAL
//CONNECTION OF THAT.. (port0_tdata_imp) THE WRITE METHOD FOR IT IS ON (write_tdata_port0) LINE NO 125*

//NOW CONNECTION FOR SCOREBOARD
//expected_port3 FOR FRAME COONECT WITH SCOREBOARD ANAYLYSIS IMP PORT (YOU CAN FINE WRITE AT VCID FATCH TASK)
//tdata_expected_port3 FOR TDATA CONNECT WITH ANAYLYSIS IMP PORT (YOU CAN FIND WRITE AT VCID FATCH TASK)

//OTHER REMAINING PORTS ARE NOT USED YET.
//..........................................................................................//
class emac_tx2rx_ref_model extends uvm_scoreboard;
    `uvm_component_utils(emac_tx2rx_ref_model)
    int tdata_ref;
    // Analysis Imp declarations
    `uvm_analysis_imp_decl(_tx_port3)
    `uvm_analysis_imp_decl(_tx_port4)
    `uvm_analysis_imp_decl(_tx_port5)
    `uvm_analysis_imp_decl(_tdata_port0)
    `uvm_analysis_imp_decl(_tdata_port1)
    `uvm_analysis_imp_decl(_tdata_port2)
bit [7:0] global_clean_data_q[$];
    emac_tx2rx_reg_block ral; 
    
    bit [15:0] valid_etypes[$] = '{16'h0800, 16'h8100};
    string port_names[NUM_PORTS] = '{"PORT3", "PORT4", "PORT5"};
    axi_str_mas_seq_item #(32,32) axis_tdata_port0[$];
    axi_str_mas_seq_item #(32,32) axis_tdata_port1[$];
    axi_str_mas_seq_item #(32,32) axis_tdata_port2[$];
    // Queue Declarations
    emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) tx_mac_port3[$];
    emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) tx_mac_port4[$];
    emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) tx_mac_port5[$];

    emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) valid_pkt_etype_port3[$];
    emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) valid_pkt_etype_port4[$];
    emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) valid_pkt_etype_port5[$];

    emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) valid_mac_pkt_port3[$];
    emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) valid_mac_pkt_port4[$];
    emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) valid_mac_pkt_port5[$];

    emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) valid_conn_cfg_port3[$];
    emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) valid_conn_cfg_port4[$];
    emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) valid_conn_cfg_port5[$];

    // Imp Instantiation
    uvm_analysis_imp_tx_port3 #(emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH), emac_tx2rx_ref_model) port0_imp;
    uvm_analysis_imp_tx_port4 #(emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH), emac_tx2rx_ref_model) port1_imp;
    uvm_analysis_imp_tx_port5 #(emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH), emac_tx2rx_ref_model) port2_imp;
    // Imp Instantiation
    uvm_analysis_imp_tx_port3 #(emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH), emac_tx2rx_ref_model) port0_tdata_imp;
    uvm_analysis_imp_tx_port4 #(emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH), emac_tx2rx_ref_model) port1_tdata_imp;
    uvm_analysis_imp_tx_port5 #(emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH), emac_tx2rx_ref_model) port2_tdata_imp;
    //PORTS FOR SCOREBOARD
	 uvm_analysis_port #(emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)) expected_port3;
	 uvm_analysis_port #(emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)) expected_port4;
	 uvm_analysis_port #(emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)) expected_port5;

	 uvm_analysis_port #(axi_str_mas_seq_item #(32,32)) tdata_expected_port3;
	 uvm_analysis_port #(axi_str_mas_seq_item #(32,32)) tdata_expected_port4;
	 uvm_analysis_port #(axi_str_mas_seq_item #(32,32)) tdata_expected_port5;
   
    uvm_analysis_imp_tdata_port0#(axi_str_mas_seq_item #(32,32), emac_tx2rx_ref_model) tdata_port0;
    uvm_analysis_imp_tdata_port1#(axi_str_mas_seq_item #(32,32), emac_tx2rx_ref_model) tdata_port1;
    uvm_analysis_imp_tdata_port2#(axi_str_mas_seq_item #(32,32), emac_tx2rx_ref_model) tdata_port2;
    // Statistics
    int etype_drop[NUM_PORTS];
    int payload_drop[NUM_PORTS];
    int pkt_in_port[NUM_PORTS];
    //int pkt_in_port4[NUM_PORTS];
   // int pkt_in_port5[NUM_PORTS];
    int valid[NUM_PORTS];
    int invalid[NUM_PORTS];

    function new (string name="", uvm_component parent);
        super.new(name, parent);
        port0_imp = new ("port0_imp", this);
        port1_imp = new ("port1_imp", this);
        port2_imp = new ("port2_imp", this);
        expected_port3 = new ("expected_port3", this);
        expected_port4 = new ("expected_port4", this);
        expected_port5 = new ("expected_port5", this);
        tdata_port0 = new ("tdata_port0",this);
        tdata_port1 = new ("tdata_port1",this);
        tdata_port2 = new ("tdata_port2",this);
        tdata_expected_port3 = new("tdata_expected_port3",this);
        tdata_expected_port4 = new("tdata_expected_port4",this);
        tdata_expected_port5 = new("tdata_expected_port5",this);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        ral = emac_tx2rx_reg_block::type_id::create("ral");
        if (!uvm_config_db#(int)::get(this,"","ref_type",tdata_ref)) begin
    		`uvm_fatal(get_full_name(), "set ref_mod type from env");
        end else begin
        $display("REF_TTPE=%d",tdata_ref);
        end
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase (phase);
       // fork
            etype_check();
            payload_check();
            cnn_cfg_check();
            vcid_fatch();
       // join_none
    endtask

    virtual function void add_etype(bit [15:0] new_etype);
        valid_etypes.push_back(new_etype);
        `uvm_info("ETYPE_ADDED", $sformatf("Added: 0x%04h, Now: %p", new_etype, valid_etypes), UVM_LOW)
    endfunction

    // -----------------------------------------------------------------
    // WRITE FUNCTIONS 
    // -----------------------------------------------------------------

 virtual function void write_tdata_port0(axi_str_mas_seq_item #(32,32) axis_tdata);
  static int port0_pkt_count = 0;  
  
  axis_tdata_port0.push_back(axis_tdata);
  port0_pkt_count++;
   
  $display("tdata_pkt_at_port3=%0d", port0_pkt_count);
  $display("tdata inside ref model - PORT0");
  axis_tdata.print(); 
  
  `uvm_info("DEBUG", "=== Component Hierarchy Debug PORT0 ===", UVM_LOW)
  `uvm_info("DEBUG", $sformatf("Instance name: %s", get_name()), UVM_LOW)
  `uvm_info("DEBUG", $sformatf("Full name: %s", get_full_name()), UVM_LOW)  
  `uvm_info("DEBUG", $sformatf("Type name: %s", get_type_name()), UVM_LOW)
  `uvm_info(get_full_name(), $sformatf("Got AXI-S Pkt in ref: %s", axis_tdata.sprint()), UVM_LOW)    
  `uvm_info("QUEUE_STATUS", $sformatf("PORT0 queue size: %0d", axis_tdata_port0.size()), UVM_HIGH)
endfunction

virtual function void write_tdata_port1(axi_str_mas_seq_item #(32,32) axis_tdata_p1);
  static int port1_pkt_count = 0;

  axis_tdata_port1.push_back(axis_tdata_p1);
  port1_pkt_count++;  // Increment counter
  
  $display("tdata inside ref model - PORT1");
  axis_tdata_p1.print();  
  $display("tdata_pkt_at_port4=%0d", port1_pkt_count);
  
  `uvm_info("DEBUG", "=== Component Hierarchy Debug PORT1 ===", UVM_LOW)
  `uvm_info("DEBUG", $sformatf("Instance name: %s", get_name()), UVM_LOW)
  `uvm_info("DEBUG", $sformatf("Full name: %s", get_full_name()), UVM_LOW)  
  `uvm_info("DEBUG", $sformatf("Type name: %s", get_type_name()), UVM_LOW)
  `uvm_info(get_full_name(), $sformatf("Got AXI-S Pkt in ref: %s", axis_tdata_p1.sprint()), UVM_LOW)  
  
  // Optional: Show queue status
  `uvm_info("QUEUE_STATUS", $sformatf("PORT1 queue size: %0d", axis_tdata_port1.size()), UVM_HIGH)
endfunction
 
virtual function void write_tdata_port2(axi_str_mas_seq_item #(32,32) axis_tdata_p2);
  static int port2_pkt_count = 0; 
  
  axis_tdata_port2.push_back(axis_tdata_p2);
  port2_pkt_count++;
  
  // Display only the NEW packet that just arrived
  $display("tdata inside ref model - PORT2");
  axis_tdata_p2.print();
  $display("tdata_pkt_at_port2 = %d", port2_pkt_count);
  
  `uvm_info("DEBUG", "=== Component Hierarchy Debug PORT2 ===", UVM_LOW)
  `uvm_info("DEBUG", $sformatf("Instance name: %s", get_name()), UVM_LOW)
  `uvm_info("DEBUG", $sformatf("Full name: %s", get_full_name()), UVM_LOW)  
  `uvm_info("DEBUG", $sformatf("Type name: %s", get_type_name()), UVM_LOW)
  `uvm_info(get_full_name(), $sformatf("Got AXI-S Pkt in ref port 2: %s", axis_tdata_p2.sprint()), UVM_LOW)
  
  // Display queue status (optional)
  `uvm_info("QUEUE_STATUS", $sformatf("PORT2 queue size: %0d", axis_tdata_port2.size()), UVM_HIGH)
endfunction

virtual function void write_tx_port3(emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) pkt_port3);
  if(!tdata_ref)begin
        pkt_in_port[PORT3_IDX]++;
        tx_mac_port3.push_back(pkt_port3); 
        
        `uvm_info("REF_PACKET_ARRIVED", 
              $sformatf("%s: Received packet #%0d (Queue size: %0d)", 
                        port_names[PORT3_IDX], pkt_in_port[PORT3_IDX], 
                        tx_mac_port3.size()), 
              UVM_LOW)
        
        // Restored loop for printing
        foreach (tx_mac_port3[i]) begin
            $display("inside ref model");
            tx_mac_port3[i].print();
            $display("VLAN ID =%h", tx_mac_port3[i].vlan_id); 
            `uvm_info("REF_MODEL", $sformatf("%s: Converting MAC frame: %s", 
                              port_names[PORT3_IDX], tx_mac_port3[i].convert2string()), UVM_MEDIUM)
        end
  end
  else begin
     $display("TDATA REF SELECTED");
end
    endfunction

    virtual function void write_tx_port4(emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) pkt_port4);
  if(!tdata_ref)begin
        pkt_in_port[PORT4_IDX]++;
        tx_mac_port4.push_back(pkt_port4); 
        
        `uvm_info("REF_PACKET_ARRIVED", 
              $sformatf("%s: Received packet #%0d (Queue size: %0d)", 
                        port_names[PORT4_IDX], pkt_in_port[PORT4_IDX], 
                        tx_mac_port4.size()), 
              UVM_LOW)
        
        foreach (tx_mac_port4[i]) begin
             `uvm_info("REF_MODEL", $sformatf("%s: Converting MAC frame: %s", 
                              port_names[PORT4_IDX], tx_mac_port4[i].convert2string()), UVM_MEDIUM)
        end
      end
          else begin
             $display("TDATA REF SELECTED");
      end
    endfunction

    virtual function void write_tx_port5(emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) pkt_port5);
  if(!tdata_ref)begin
        pkt_in_port[PORT5_IDX]++;
        tx_mac_port5.push_back(pkt_port5); 
        
        `uvm_info("REF_PACKET_ARRIVED", 
              $sformatf("%s: Received packet #%0d (Queue size: %0d)", 
                        port_names[PORT5_IDX], pkt_in_port[PORT5_IDX], 
                        tx_mac_port5.size()), 
              UVM_LOW)
        
        foreach (tx_mac_port5[i]) begin
             `uvm_info("REF_MODEL", $sformatf("%s: Converting MAC frame: %s", 
                              port_names[PORT5_IDX], tx_mac_port5[i].convert2string()), UVM_MEDIUM)
        end
    end
          else begin
             $display("TDATA REF SELECTED");
      end

    endfunction

    // -----------------------------------------------------------------
    // ETYPE CHECKS (With Restored Logging)
    // -----------------------------------------------------------------
    task etype_check();
        fork
            check_port3_etype();
            check_port4_etype();
            check_port5_etype();
        join_none
    endtask

    task check_port3_etype();
        forever begin
            wait (tx_mac_port3.size() > 0);
            `uvm_info("PORT3_CHECK", $sformatf("Processing %0d packets", tx_mac_port3.size()), UVM_HIGH)
            
            foreach (tx_mac_port3[i]) begin
                if (tx_mac_port3[i].e_type inside {valid_etypes}) begin
                    `uvm_info("VALID ETYPE", $sformatf("%s: EType=%h", port_names[PORT3_IDX], tx_mac_port3[i].e_type), UVM_LOW);
                    valid_pkt_etype_port3.push_back(tx_mac_port3[i]);
                end else begin
                    etype_drop[PORT3_IDX]++;
                    axis_tdata_port0.delete();
                    `uvm_info("INVALID ETYPE", $sformatf("%s: EType=%h - DROPPED", port_names[PORT3_IDX], tx_mac_port3[i].e_type), UVM_LOW);
                end
            end
            tx_mac_port3.delete(); 
        end
    endtask

    task check_port4_etype();
        forever begin
            wait (tx_mac_port4.size() > 0);
            `uvm_info("PORT4_ETYPE_CHECK", $sformatf("Processing %0d packets", tx_mac_port4.size()), UVM_DEBUG)

            foreach (tx_mac_port4[i]) begin
                if (tx_mac_port4[i].e_type inside {valid_etypes}) begin
                    `uvm_info("VALID ETYPE", $sformatf("%s: EType=%h", port_names[PORT4_IDX], tx_mac_port4[i].e_type), UVM_LOW);
                    valid_pkt_etype_port4.push_back(tx_mac_port4[i]);
                end else begin
                    etype_drop[PORT4_IDX]++;
                    axis_tdata_port1.delete();
                    `uvm_info("INVALID ETYPE", $sformatf("%s: EType=%h - DROPPED", port_names[PORT4_IDX], tx_mac_port4[i].e_type), UVM_LOW);
                end
            end
            tx_mac_port4.delete();
        end
    endtask

    task check_port5_etype();
        forever begin
            wait (tx_mac_port5.size() > 0);
            `uvm_info("PORT5_ETYPE_CHECK", $sformatf("Processing %0d packets", tx_mac_port5.size()), UVM_HIGH)

            foreach (tx_mac_port5[i]) begin
                if (tx_mac_port5[i].e_type inside {valid_etypes}) begin
                    `uvm_info("VALID ETYPE", $sformatf("%s: EType=%h", port_names[PORT5_IDX], tx_mac_port5[i].e_type), UVM_LOW);
                    valid_pkt_etype_port5.push_back(tx_mac_port5[i]);
                end else begin
                    etype_drop[PORT5_IDX]++;
                    axis_tdata_port2.delete();
                    `uvm_info("INVALID ETYPE", $sformatf("%s: EType=%h - DROPPED", port_names[PORT5_IDX], tx_mac_port5[i].e_type), UVM_LOW)
                end
            end
            tx_mac_port5.delete();
        end
    endtask

    // -----------------------------------------------------------------
    // PAYLOAD CHECKS (With Restored Logging)
    // -----------------------------------------------------------------
    task payload_check();
        fork
            check_port3_payload();
            check_port4_payload();
            check_port5_payload();
        join_none
    endtask

    task check_port3_payload();
        forever begin
            wait (valid_pkt_etype_port3.size() > 0);
            foreach (valid_pkt_etype_port3[i]) begin
                if(valid_pkt_etype_port3[i].payload.size() <= 1500) begin
                    `uvm_info("VALID PAYLOAD SIZE", $sformatf("%s: payload size=%d", port_names[PORT3_IDX], valid_pkt_etype_port3[i].payload.size()), UVM_DEBUG);
                    valid_mac_pkt_port3.push_back(valid_pkt_etype_port3[i]);
                    `uvm_info("[RETURN VALID E MAC PKT]","PORT 3",UVM_LOW)
                end else begin
                    payload_drop[PORT3_IDX]++;
                    axis_tdata_port0.delete();
                    `uvm_info("INVALID PAYLOAD SIZE", $sformatf("%s: PAYLOAD SIZE=%d - DROPPED", port_names[PORT3_IDX], valid_pkt_etype_port3[i].payload.size()), UVM_LOW);
                end
            end
            valid_pkt_etype_port3.delete();
        end
    endtask

    task check_port4_payload();
        forever begin
           $display("port4 valid pkt etype queu size=%d",valid_pkt_etype_port4.size() );
            wait (valid_pkt_etype_port4.size() > 0);
            `uvm_info("PORT4_PAYLOAD_CHECK", $sformatf("Processing %0d packets", valid_pkt_etype_port4.size()), UVM_DEBUG)
            foreach (valid_pkt_etype_port4[i]) begin
                if(valid_pkt_etype_port4[i].payload.size() <= 1500) begin
                    `uvm_info("VALID PAYLOAD", $sformatf("%s: PAYLOAD SIZE=%d", port_names[PORT4_IDX], valid_pkt_etype_port4[i].payload.size()), UVM_DEBUG)
                    valid_mac_pkt_port4.push_back(valid_pkt_etype_port4[i]);
                end else begin
                    payload_drop[PORT4_IDX]++;
                    axis_tdata_port1.delete();
                    `uvm_info("INVALID PAYLOAD SIZE", $sformatf("%s: PAYLOAD=%d - DROPPED", port_names[PORT4_IDX], valid_pkt_etype_port4[i].payload.size()), UVM_LOW)
                end
            end
            valid_pkt_etype_port4.delete();
        end
    endtask

    task check_port5_payload();
        forever begin
            wait (valid_pkt_etype_port5.size() > 0);
            `uvm_info("PORT5_ETYPE_CHECK", $sformatf("Processing %0d packets", valid_pkt_etype_port5.size()), UVM_HIGH)
            foreach (valid_pkt_etype_port5[i]) begin
                if(valid_pkt_etype_port5[i].payload.size() <= 1500) begin
                    `uvm_info("VALID PAYLOAD", $sformatf("%s: payload=%d", port_names[PORT5_IDX], valid_pkt_etype_port5[i].payload.size()), UVM_HIGH);
                    valid_mac_pkt_port5.push_back(valid_pkt_etype_port5[i]);
                end else begin
                    payload_drop[PORT5_IDX]++;
                    axis_tdata_port2.delete();
                    `uvm_info("INVALID PAYLOAD SIZE", $sformatf("%s: PAYLOAD SIZE=%D - DROPPED", port_names[PORT5_IDX], valid_pkt_etype_port5[i].payload.size()), UVM_LOW)
                end
            end
            valid_pkt_etype_port5.delete();
        end
    endtask

    // -----------------------------------------------------------------
    // CONFIG CHECKS (With Restored Logging)
    // -----------------------------------------------------------------
    task cnn_cfg_check();
        fork
            cfg_check_port3();
            cfg_check_port4();
            cfg_check_port5();
        join_none
    endtask

    task cfg_check_port3();
        bit [14:0] addr;
        bit [2:0] port_id = 3;
        bit conn_valid_bit;
        uvm_reg_field conn_valid_field; 
        
        forever begin
            wait (valid_mac_pkt_port3.size() > 0);
            
            foreach(valid_mac_pkt_port3[i]) begin
                addr = {port_id, valid_mac_pkt_port3[i].vlan_id}; 
                
                if (ral.conn_config_reg_h[addr] != null) begin
                    conn_valid_field = ral.conn_config_reg_h[addr].conn_val;
                    conn_valid_bit = conn_valid_field.get();
                    
                    $display("CNN_CFG[%5d]: CONN_VALID=%0d", addr, conn_valid_bit); // Restored

                    if (conn_valid_bit == 1) begin
                        valid[PORT3_IDX]++;
                        valid_conn_cfg_port3.push_back(valid_mac_pkt_port3[i]);
                        `uvm_info("CONNECTION VALID", $sformatf("%s: CONN_VALID=%0d", port_names[PORT3_IDX], conn_valid_bit), UVM_LOW);
                    end else begin
                      axis_tdata_port0.delete();
                        invalid[PORT3_IDX]++;
                        `uvm_info("CONNECTION INVALID", $sformatf("%s: CONN_VALID=%0d", port_names[PORT3_IDX], conn_valid_bit), UVM_LOW);
                    end
                end
            end  
            valid_mac_pkt_port3.delete();
        end
    endtask

    task cfg_check_port4();
        bit [14:0] addr;
        bit [2:0] port_id = 4;
        bit conn_valid_bit;
        uvm_reg_field conn_valid_field; 
        forever begin
            $display("VALID PAYLOAD PKY P4=%d",valid_mac_pkt_port4.size());
            wait (valid_mac_pkt_port4.size() > 0);
            foreach (valid_mac_pkt_port4[i]) begin
                addr = {port_id, valid_mac_pkt_port4[i].vlan_id};
                if (ral.conn_config_reg_h[addr] != null) begin
                    conn_valid_field = ral.conn_config_reg_h[addr].conn_val;
                    conn_valid_bit = conn_valid_field.get();
                    
                    $display("CNN_CFG[%5d]: CONN_VALID=%0d", addr, conn_valid_bit); // Restored

                    if (conn_valid_bit == 1) begin
                        valid[PORT4_IDX]++;
                        valid_conn_cfg_port4.push_back(valid_mac_pkt_port4[i]);
                        `uvm_info("CONNECTION VALID", $sformatf("%s: CONN_VALID=%0d", port_names[PORT4_IDX], conn_valid_bit), UVM_LOW);
                    end else begin
                        invalid[PORT4_IDX]++;
                        axis_tdata_port1.delete();
                        `uvm_info("CONNECTION INVALID", $sformatf("%s: CONN_VALID=%0d", port_names[PORT4_IDX], conn_valid_bit), UVM_LOW);
                    end
                end
            end
            valid_mac_pkt_port4.delete();
        end
    endtask 

    task cfg_check_port5();
        bit [14:0] addr;
        bit [2:0] port_id = 5;
        bit conn_valid_bit;
        uvm_reg_field conn_valid_field; 
        forever begin
            wait (valid_mac_pkt_port5.size() > 0);
            foreach (valid_mac_pkt_port5[i]) begin
                addr = {port_id, valid_mac_pkt_port5[i].vlan_id};
                if (ral.conn_config_reg_h[addr] != null) begin
                    conn_valid_field = ral.conn_config_reg_h[addr].conn_val;
                    conn_valid_bit = conn_valid_field.get();
                    
                    $display("CNN_CFG[%5d]: CONN_VALID=%0d", addr, conn_valid_bit); // Restored

                    if (conn_valid_bit == 1) begin
                        valid[PORT5_IDX]++;
                        valid_conn_cfg_port5.push_back(valid_mac_pkt_port5[i]);
                        `uvm_info("CONNECTION VALID", $sformatf("%s: CONN_VALID=%0d", port_names[PORT5_IDX], conn_valid_bit), UVM_LOW);
                    end else begin
                        invalid[PORT5_IDX]++;
                    axis_tdata_port2.delete();
                        `uvm_info("CONNECTION INVALID", $sformatf("%s: CONN_VALID=%0d", port_names[PORT5_IDX], conn_valid_bit), UVM_LOW);
                    end
                end
            end
            valid_mac_pkt_port5.delete();
        end
    endtask 

    // -----------------------------------------------------------------
    // VCID FETCH & PACKET CONVERSION (With Restored Logging)
    // -----------------------------------------------------------------
    task vcid_fatch();
       fork
          vcid_fatch_port3();
          vcid_fatch_port4();
          vcid_fatch_port5();
       join_none
    endtask

    task vcid_fatch_port3();
        emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) expected_pkt;
        emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) current_pkt;
        axi_str_mas_seq_item #(32,32) expected_tdata;  
        axi_str_mas_seq_item #(32,32) current_tdata;  
        bit [14:0] cnn_addr;
        bit [2:0]  port_id = 3;
        bit [4:0]  vcid_addr;
        bit [7:0]  vcid;
        uvm_reg_field conn_id_field;
        uvm_reg_field vcid_field;

        forever begin
            wait(valid_conn_cfg_port3.size() > 0);
          //  wait(axis_tdata_port0.size() >0);
            current_pkt = valid_conn_cfg_port3.pop_front(); 
            current_tdata = axis_tdata_port0.pop_front();
            cnn_addr = {port_id, current_pkt.vlan_id}; 
            
            if (ral.conn_config_reg_h[cnn_addr] != null) begin
                conn_id_field = ral.conn_config_reg_h[cnn_addr].conn_id;
                vcid_addr     = conn_id_field.get();
                
                `uvm_info("VCID REG ADDR", $sformatf ("VCID_ADDR_PORT3=%h", vcid_addr), UVM_LOW) // Restored
                
                if (ral.vcid_config_reg_h[vcid_addr] != null) begin
                    vcid_field = ral.vcid_config_reg_h[vcid_addr].vcid;
                    vcid       = vcid_field.get();
                    $display("REF_VCID=%h",vcid); 
                    `uvm_info("VCID_PORT3", $sformatf ("VCID_PORT3=%h", vcid), UVM_LOW) // Restored

                    expected_pkt = get_rx_expected(current_pkt, vcid);
                    expected_port3.write(expected_pkt);
                    expected_tdata = expected_tdata_pkt(current_tdata,vcid);
                    tdata_expected_port3.write(expected_tdata);
                end
            end
       end
    endtask
    task vcid_fatch_port4();
        emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) expected_pkt_p4;
        emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) current_pkt_p4;
        axi_str_mas_seq_item #(32,32) expected_tdata_p4;  
        axi_str_mas_seq_item #(32,32) current_tdata;  
        bit [14:0] cnn_addr;
        bit [2:0]  port_id = 4;
        bit [4:0]  vcid_addr;
        bit [7:0]  vcid;
        uvm_reg_field conn_id_field;
        uvm_reg_field vcid_field;

        forever begin
            wait(valid_conn_cfg_port4.size() > 0);

            current_pkt_p4 = valid_conn_cfg_port4.pop_front(); 
            current_tdata = axis_tdata_port1.pop_front();
            cnn_addr = {port_id, current_pkt_p4.vlan_id}; 
            
            if (ral.conn_config_reg_h[cnn_addr] != null) begin
                conn_id_field = ral.conn_config_reg_h[cnn_addr].conn_id;
                vcid_addr     = conn_id_field.get();
                
                `uvm_info("VCID REG ADDR", $sformatf ("VCID_ADDR_PORT4=%h", vcid_addr), UVM_LOW) // Restored
                
                if (ral.vcid_config_reg_h[vcid_addr] != null) begin
                    vcid_field = ral.vcid_config_reg_h[vcid_addr].vcid;
                    vcid       = vcid_field.get();
                    $display("REF_VCID=%h",vcid); 
                    `uvm_info("VCID", $sformatf ("VCID_PORT4=%h", vcid), UVM_LOW) // Restored

                    expected_pkt_p4 = get_rx_expected(current_pkt_p4, vcid);
                    expected_port4.write(expected_pkt_p4);
                    expected_tdata_p4 = expected_tdata_pkt(current_tdata,vcid);
                    tdata_expected_port4.write(expected_tdata_p4);
                end
            end
       end
    endtask

    task vcid_fatch_port5();
        emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) expected_pkt_p5;
        emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) current_pkt_p5;
        axi_str_mas_seq_item #(32,32) expected_tdata_p5;  
        axi_str_mas_seq_item #(32,32) current_tdata;  
        bit [14:0] cnn_addr;
        bit [2:0]  port_id = 5;
        bit [4:0]  vcid_addr;
        bit [7:0]  vcid;
        uvm_reg_field conn_id_field;
        uvm_reg_field vcid_field;

        forever begin
            wait(valid_conn_cfg_port5.size() > 0);

            current_pkt_p5 = valid_conn_cfg_port5.pop_front(); 
            current_tdata = axis_tdata_port2.pop_front();
            cnn_addr = {port_id, current_pkt_p5.vlan_id}; 
            
            if (ral.conn_config_reg_h[cnn_addr] != null) begin
                conn_id_field = ral.conn_config_reg_h[cnn_addr].conn_id;
                vcid_addr     = conn_id_field.get();
                
                `uvm_info("VCID REG ADDR", $sformatf ("VCID_ADDR_PORT5=%h", vcid_addr), UVM_LOW) // Restored
                
                if (ral.vcid_config_reg_h[vcid_addr] != null) begin
                    vcid_field = ral.vcid_config_reg_h[vcid_addr].vcid;
                    vcid       = vcid_field.get();
                    $display("REF_VCID=%h",vcid); 
                    `uvm_info("VCID", $sformatf ("VCID_PORT5=%h", vcid), UVM_LOW) // Restored

                    expected_pkt_p5 = get_rx_expected(current_pkt_p5, vcid);
                    expected_port5.write(expected_pkt_p5);
                    expected_tdata_p5 = expected_tdata_pkt(current_tdata,vcid);
                    tdata_expected_port5.write(expected_tdata_p5);
                end
            end
       end
    endtask


function axi_str_mas_seq_item #(32,32) expected_tdata_pkt(axi_str_mas_seq_item #(32,32) original_tdata, bit[7:0] vcid);
    axi_str_mas_seq_item #(32,32) modified_tdata;
    bit [7:0] byte_stream[$]; 
    bit [31:0] temp_word;
    int valid_bytes_in_last_beat;
    int padding_bytes;
    int last_idx;
    int i;

    if (original_tdata == null) begin
        `uvm_error("NULL_HANDLE", "Function expected_tdata_pkt received a NULL handle!")
        return null;
    end

    `uvm_info("INPUT_DEBUG", "=== ORIGINAL TRANSACTION (FROM MONITOR) ===", UVM_LOW)
    `uvm_info("INPUT_DEBUG", $sformatf("Total words: %0d", original_tdata.tdata_q.size()), UVM_LOW)
    `uvm_info("INPUT_DEBUG", $sformatf("Last word: %08h", original_tdata.tdata_q[original_tdata.tdata_q.size()-1]), UVM_LOW)
    `uvm_info("INPUT_DEBUG", $sformatf("Last TKEEP: %01h", original_tdata.tkeep_q[original_tdata.tkeep_q.size()-1]), UVM_LOW)

    foreach(original_tdata.tdata_q[i]) begin
        `uvm_info("INPUT_DEBUG", 
                  $sformatf("Word[%0d]: DATA=%08h, TKEEP=%01h", 
                           i, original_tdata.tdata_q[i], original_tdata.tkeep_q[i]), 
                  UVM_LOW)
    end
    // Debug original frame
    `uvm_info("ORIGINAL_DEBUG", 
              $sformatf("Original: %0d words, Last word: %08h, Last TKEEP: %01h", 
                       original_tdata.tdata_q.size(),
                       original_tdata.tdata_q[original_tdata.tdata_q.size()-1],
                       original_tdata.tkeep_q[original_tdata.tkeep_q.size()-1]), 
              UVM_HIGH)

    if (!$cast(modified_tdata, original_tdata.clone())) begin
        `uvm_fatal("CAST_FAIL", "Cast failed")
    end
    

    foreach(original_tdata.tdata_q[i]) begin
        temp_word = {<<8{original_tdata.tdata_q[i]}};
        
        byte_stream.push_back(temp_word[31:24]);
        byte_stream.push_back(temp_word[23:16]);
        byte_stream.push_back(temp_word[15:8]);
        byte_stream.push_back(temp_word[7:0]);
    end

    `uvm_info("BYTE_STREAM_BEFORE", 
              $sformatf("Before TKEEP adjustment: %0d bytes", byte_stream.size()), 
              UVM_HIGH)

    last_idx = original_tdata.tkeep_q.size() - 1;
    
    case(original_tdata.tkeep_q[last_idx])
        4'h1 : valid_bytes_in_last_beat = 1; 
        4'h3 : valid_bytes_in_last_beat = 2; 
        4'h7 : valid_bytes_in_last_beat = 3; 
        4'hF : valid_bytes_in_last_beat = 4;
        default: valid_bytes_in_last_beat = 4;
    endcase
    
    padding_bytes = 4 - valid_bytes_in_last_beat;
    
    `uvm_info("TKEEP_ADJUST", 
              $sformatf("Last beat: valid_bytes=%0d, padding_bytes=%0d", 
                       valid_bytes_in_last_beat, padding_bytes), 
              UVM_MEDIUM)

    // Remove padding bytes from the end
    repeat(padding_bytes) void'(byte_stream.pop_back());

    `uvm_info("BYTE_STREAM_AFTER", 
              $sformatf("After TKEEP adjustment: %0d bytes", byte_stream.size()), 
              UVM_HIGH)


    if (byte_stream.size() >= 14) begin 
        // Remove 2-byte TCI (bytes 12-13) and insert 1-byte VCID
        byte_stream.delete(12); // Remove TCI High byte
        byte_stream.delete(12); // Remove TCI Low byte  
        byte_stream.insert(12, vcid); // Insert VCID
        
        `uvm_info("VCID_INSERT", 
                  $sformatf("Replaced TCI with VCID=%0h, New frame: %0d bytes", 
                           vcid, byte_stream.size()), 
                  UVM_LOW)
    end else begin
        `uvm_error("FRAME_TOO_SHORT", "Frame too short for VCID insertion")
        return null;
    end

    
    modified_tdata.tdata_q.delete();
    modified_tdata.tkeep_q.delete();

    while(byte_stream.size() > 0) begin
        bit [31:0] new_word = 0;
        bit [3:0]  new_keep = 0;
        int bytes_to_pop;

     bytes_to_pop = (byte_stream.size() >= 4) ? 4 : byte_stream.size();

for (int j = 0; j < bytes_to_pop; j++) begin
    case(j)
        0: new_word[31:24] = byte_stream[0];
        1: new_word[23:16] = byte_stream[0];  
        2: new_word[15:8]  = byte_stream[0];
        3: new_word[7:0]   = byte_stream[0];
    endcase
    byte_stream.delete(0);
end        // Set TKEEP based on actual valid bytes
        case(bytes_to_pop)
            1: new_keep = 4'h1; // Only byte 0 valid: 0001
            2: new_keep = 4'h3; // Bytes 0-1 valid: 0011  
            3: new_keep = 4'h7; // Bytes 0-2 valid: 0111
            4: new_keep = 4'hF; // All bytes valid: 1111
        endcase
        
        // Swap to Little Endian for AXI bus
        new_word = {<<8{new_word}};

        modified_tdata.tdata_q.push_back(new_word);
        modified_tdata.tkeep_q.push_back(new_keep);

        `uvm_info("WORD_PACK", 
                  $sformatf("Word[%0d]: DATA=%08h, TKEEP=%01h, bytes=%0d", 
                           modified_tdata.tdata_q.size()-1, new_word, new_keep, bytes_to_pop), 
                  UVM_HIGH)
    end
    
    `uvm_info("MODIFIED_DEBUG", 
              $sformatf("Modified: %0d words, Last word: %08h, Last TKEEP: %01h", 
                       modified_tdata.tdata_q.size(),
                       modified_tdata.tdata_q[modified_tdata.tdata_q.size()-1],
                       modified_tdata.tkeep_q[modified_tdata.tkeep_q.size()-1]), 
              UVM_HIGH)
    `uvm_info("OUTPUT_DEBUG", "=== MODIFIED TRANSACTION (AFTER PROCESSING) ===", UVM_LOW)
    `uvm_info("OUTPUT_DEBUG", $sformatf("Total words: %0d", modified_tdata.tdata_q.size()), UVM_LOW)
    `uvm_info("OUTPUT_DEBUG", $sformatf("Last word: %08h", modified_tdata.tdata_q[modified_tdata.tdata_q.size()-1]), UVM_LOW)
    `uvm_info("OUTPUT_DEBUG", $sformatf("Last TKEEP: %01h", modified_tdata.tkeep_q[modified_tdata.tkeep_q.size()-1]), UVM_LOW)
    
    foreach(modified_tdata.tdata_q[i]) begin
        `uvm_info("OUTPUT_DEBUG", 
                  $sformatf("Word[%0d]: DATA=%08h, TKEEP=%01h", 
                           i, modified_tdata.tdata_q[i], modified_tdata.tkeep_q[i]), 
                  UVM_LOW)
    end
    
    $display("INSIDE TDATA FUNCTION");
     modified_tdata.print();
    return modified_tdata;
endfunction



    function emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) get_rx_expected(
        emac_tx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) valid_expected_pkt,
        bit [7:0] vcid
    );
        emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) expected_pkt;
        expected_pkt = emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)::type_id::create("expected_pkt");

        expected_pkt.source_mac_addr = valid_expected_pkt.source_mac_addr; 
        expected_pkt.dest_mac_addr   = valid_expected_pkt.dest_mac_addr;
        expected_pkt.vcid            = vcid;
        expected_pkt.e_type          = valid_expected_pkt.e_type; 
        expected_pkt.payload         = valid_expected_pkt.payload;
        $display("EXPECTED PKT SENDING TO SCB");
        expected_pkt.print();
        // Restored uvm_info
       /* `uvm_info("REF_GET_RX", $sformatf("Converting MAC frame: %s", 
                                 expected_pkt.convert2string()), UVM_MEDIUM)
        */
        return expected_pkt;
    endfunction

int total_pkts_received;     
int total_conn_invalid_drop;  
int total_crc_drop;            
int expected_out_port[NUM_PORTS];
int actual_out_port[NUM_PORTS];  
// Inside class emac_tx2rx_ref_model

function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    
    // Reset grand total before calculation
    total_pkts_received = 0;
    total_conn_invalid_drop = 0;
    total_crc_drop = 0;
    
    // 1. Calculate Grand Totals based on the single consolidated array (pkt_in_port)
    for (int i = 0; i < NUM_PORTS; i++) begin
        // Total received:
        total_pkts_received += pkt_in_port[i]; 
        
        // Total Dropped (Connection Invalid):
        total_conn_invalid_drop += invalid[i];
        
        // Total Dropped (CRC):
       // total_crc_drop += crc_drop[i]; 
    end
    
    // 2. Print Summary Report
    `uvm_info(get_full_name(), 
        "\n--------------------------- Expected Packet Summary ---------------------------------------", UVM_LOW)

    $display("Total Packets received on all input ports = %0d", total_pkts_received);

    // Consolidated Input Port Counts using the single array:
    $display("No. of packet received at in_port0 = %0d", pkt_in_port[PORT3_IDX]);
    $display("No. of packet received at in_port1 = %0d", pkt_in_port[PORT4_IDX]);
    $display("No. of packet received at in_port2 = %0d", pkt_in_port[PORT5_IDX]);

    $display("No. of packet dropped due to connection invalid = %0d", total_conn_invalid_drop);
 //   $display("No of packet dropped due to incorrect CRC = %0d", total_crc_drop);

    // Expected Output Counts
    $display("No of expected packet at out_port0 = %0d", expected_out_port[PORT3_IDX]);
    $display("No of expected packet at out_port1 = %0d", expected_out_port[PORT4_IDX]);
    $display("No of expected packet at out_port2 = %0d", expected_out_port[PORT5_IDX]);

    // Actual Output Counts
    $display("No of actual packet at out_port0 = %0d", actual_out_port[PORT3_IDX]);
    $display("No of actual packet at out_port1 = %0d", actual_out_port[PORT4_IDX]);
    $display("No of actual packet at out_port2 = %0d", actual_out_port[PORT5_IDX]);

    `uvm_info(get_full_name(), 
        "------------------------------------------------------------------------------------------\n", UVM_LOW)
endfunction
endclass
`endif
