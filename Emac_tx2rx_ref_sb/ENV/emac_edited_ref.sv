`ifndef MAC_TX_RX_REF_MODEL
`define MAC_TX_RX_REF_MODEL

  localparam PORT3_IDX = 0;
  localparam PORT4_IDX = 1;
  localparam PORT5_IDX = 2;
  localparam NUM_PORTS = 3;
  localparam PAYLOAD_DATA_WIDTH = 8;
  localparam FRAME_DATA_WIDTH = 32;

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
 
    // -----------------------------------------------------------------
    // PORTS
    // -----------------------------------------------------------------
    // Analysis Imps for MAC Packets (Using mac_tx_seq_item)
    uvm_analysis_imp_tx_port3 #(mac_tx_seq_item, emac_tx2rx_ref_model) port0_imp;
    uvm_analysis_imp_tx_port4 #(mac_tx_seq_item, emac_tx2rx_ref_model) port1_imp;
    uvm_analysis_imp_tx_port5 #(mac_tx_seq_item, emac_tx2rx_ref_model) port2_imp;

    // Analysis Imps for AXI Stream TDATA
    uvm_analysis_imp_tdata_port0#(axi_str_mas_seq_item #(32,32), emac_tx2rx_ref_model) tdata_port0;
    uvm_analysis_imp_tdata_port1#(axi_str_mas_seq_item #(32,32), emac_tx2rx_ref_model) tdata_port1;
    uvm_analysis_imp_tdata_port2#(axi_str_mas_seq_item #(32,32), emac_tx2rx_ref_model) tdata_port2;

    // Analysis Ports for Scoreboard (Expected Output)
    uvm_analysis_port #(emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)) expected_port3;
    uvm_analysis_port #(emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)) expected_port4;
    uvm_analysis_port #(emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)) expected_port5;

    uvm_analysis_port #(axi_str_mas_seq_item #(32,32)) tdata_expected_port3;
    uvm_analysis_port #(axi_str_mas_seq_item #(32,32)) tdata_expected_port4;
    uvm_analysis_port #(axi_str_mas_seq_item #(32,32)) tdata_expected_port5;

    // -----------------------------------------------------------------
    // DATA STRUCTURES
    // -----------------------------------------------------------------
    axi_4_reg_block ral; 
    
    bit [15:0] valid_etypes[$] = '{16'h0800, 16'h8100};
    string port_names[NUM_PORTS] = '{"PORT3", "PORT4", "PORT5"};

    // AXI Queues
    axi_str_mas_seq_item #(32,32) axis_tdata_port0[$];
    axi_str_mas_seq_item #(32,32) axis_tdata_port1[$];
    axi_str_mas_seq_item #(32,32) axis_tdata_port2[$];

    // MAC Queues (Updated to mac_tx_seq_item)
    mac_tx_seq_item tx_mac_port3[$];
    mac_tx_seq_item tx_mac_port4[$];
    mac_tx_seq_item tx_mac_port5[$];

    mac_tx_seq_item valid_pkt_etype_port3[$];
    mac_tx_seq_item valid_pkt_etype_port4[$];
    mac_tx_seq_item valid_pkt_etype_port5[$];

    mac_tx_seq_item valid_mac_pkt_port3[$];
    mac_tx_seq_item valid_mac_pkt_port4[$];
    mac_tx_seq_item valid_mac_pkt_port5[$];

    mac_tx_seq_item valid_conn_cfg_port3[$];
    mac_tx_seq_item valid_conn_cfg_port4[$];
    mac_tx_seq_item valid_conn_cfg_port5[$];

    // Statistics
    int etype_drop[NUM_PORTS];
    int payload_drop[NUM_PORTS];
    int pkt_in_port[NUM_PORTS];
    int valid[NUM_PORTS];
    int invalid[NUM_PORTS];
    
    int total_pkts_received;      
    int total_conn_invalid_drop;  
    int total_crc_drop;            
    int expected_out_port[NUM_PORTS];
    int actual_out_port[NUM_PORTS];  

    // -----------------------------------------------------------------
    // CONSTRUCTOR & BUILD
    // -----------------------------------------------------------------
    function new (string name="", uvm_component parent);
        super.new(name, parent);
        port0_imp = new ("port0_imp", this);
        port1_imp = new ("port1_imp", this);
        port2_imp = new ("port2_imp", this);
        
        tdata_port0 = new ("tdata_port0",this);
        tdata_port1 = new ("tdata_port1",this);
        tdata_port2 = new ("tdata_port2",this);
        
        expected_port3 = new ("expected_port3", this);
        expected_port4 = new ("expected_port4", this);
        expected_port5 = new ("expected_port5", this);
        
        tdata_expected_port3 = new("tdata_expected_port3",this);
        tdata_expected_port4 = new("tdata_expected_port4",this);
        tdata_expected_port5 = new("tdata_expected_port5",this);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        ral = axi_4_reg_block::type_id::create("ral");
        if (!uvm_config_db#(int)::get(this,"","ref_type",tdata_ref)) begin
            `uvm_fatal(get_full_name(), "set ref_mod type from env");
        end else begin
            $display("REF_TYPE=%d",tdata_ref);
        end
    endfunction

    // -----------------------------------------------------------------
    // RUN PHASE
    // -----------------------------------------------------------------
    task run_phase(uvm_phase phase);
        super.run_phase (phase);
        // fork // Uncomment if needed, but usually checks are forked
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
    // WRITE FUNCTIONS (INPUTS)
    // -----------------------------------------------------------------
    virtual function void write_tdata_port0(axi_str_mas_seq_item #(32,32) axis_tdata);
        static int port0_pkt_count = 0;  
        axis_tdata_port0.push_back(axis_tdata);
        port0_pkt_count++;
        // Print/Log logic here (omitted for brevity)
        `uvm_info(get_full_name(), $sformatf("Got AXI-S Pkt in ref: %s", axis_tdata.sprint()), UVM_LOW)    
        `uvm_info("QUEUE_STATUS", $sformatf("PORT0 queue size: %0d", axis_tdata_port0.size()), UVM_HIGH)

    endfunction

    virtual function void write_tdata_port1(axi_str_mas_seq_item #(32,32) axis_tdata_p1);
        static int port1_pkt_count = 0;
        axis_tdata_port1.push_back(axis_tdata_p1);
        port1_pkt_count++;
  `uvm_info(get_full_name(), $sformatf("Got AXI-S Pkt in ref: %s", axis_tdata_p1.sprint()), UVM_LOW)  
  
  // Optional: Show queue status
  `uvm_info("QUEUE_STATUS", $sformatf("PORT1 queue size: %0d", axis_tdata_port1.size()), UVM_HIGH)
    endfunction
 
    virtual function void write_tdata_port2(axi_str_mas_seq_item #(32,32) axis_tdata_p2);
        static int port2_pkt_count = 0; 
        axis_tdata_port2.push_back(axis_tdata_p2);
        port2_pkt_count++;
  `uvm_info(get_full_name(), $sformatf("Got AXI-S Pkt in ref port 2: %s", axis_tdata_p2.sprint()), UVM_LOW)
  
  // Display queue status (optional)
  `uvm_info("QUEUE_STATUS", $sformatf("PORT2 queue size: %0d", axis_tdata_port2.size()), UVM_HIGH)
    endfunction

    virtual function void write_tx_port3(mac_tx_seq_item pkt_port3);
        if(!tdata_ref)begin
            pkt_in_port[PORT3_IDX]++;
            tx_mac_port3.push_back(pkt_port3); 
            foreach (tx_mac_port3[i]) begin
              `uvm_info(($sformatf("REF_MODEL %s", port_names[PORT3_IDX])),tx_mac_port3[i].sprint(),UVM_MEDIUM)
            end
        end
        else begin
            $display("TDATA REF SELECTED");
        end
    endfunction

    virtual function void write_tx_port4(mac_tx_seq_item pkt_port4);
        if(!tdata_ref)begin
            pkt_in_port[PORT4_IDX]++;
            tx_mac_port4.push_back(pkt_port4); 
            foreach (tx_mac_port4[i]) begin
              `uvm_info(($sformatf("REF_MODEL %s", port_names[PORT4_IDX])),tx_mac_port4[i].sprint(),UVM_MEDIUM)
            end
        end 
        else begin
             $display("TDATA REF SELECTED");
        end
    endfunction

    virtual function void write_tx_port5(mac_tx_seq_item pkt_port5);
        if(!tdata_ref)begin
            pkt_in_port[PORT5_IDX]++;
            tx_mac_port5.push_back(pkt_port5); 
            foreach (tx_mac_port5[i]) begin
              `uvm_info(($sformatf("REF_MODEL %s", port_names[PORT5_IDX])),tx_mac_port5[i].sprint(),UVM_MEDIUM)
            end
        end 
        else begin
             $display("TDATA REF SELECTED");
        end
    endfunction

    // -----------------------------------------------------------------
    // CHECK TASKS
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
            foreach (tx_mac_port3[i]) begin
                if (tx_mac_port3[i].Etype inside {valid_etypes}) begin
                    valid_pkt_etype_port3.push_back(tx_mac_port3[i]);
                end else begin
                    etype_drop[PORT3_IDX]++;
                    axis_tdata_port0.delete(); // Drop TDATA if MAC is invalid
                end
            end
            tx_mac_port3.delete(); 
        end
    endtask

    task check_port4_etype();
        forever begin
            wait (tx_mac_port4.size() > 0);
            foreach (tx_mac_port4[i]) begin
                if (tx_mac_port4[i].Etype inside {valid_etypes}) begin
                    valid_pkt_etype_port4.push_back(tx_mac_port4[i]);
                end else begin
                    etype_drop[PORT4_IDX]++;
                    axis_tdata_port1.delete();
                end
            end
            tx_mac_port4.delete();
        end
    endtask

    task check_port5_etype();
        forever begin
            wait (tx_mac_port5.size() > 0);
            foreach (tx_mac_port5[i]) begin
                if (tx_mac_port5[i].Etype inside {valid_etypes}) begin
                    valid_pkt_etype_port5.push_back(tx_mac_port5[i]);
                end else begin
                    etype_drop[PORT5_IDX]++;
                    axis_tdata_port2.delete();
                end
            end
            tx_mac_port5.delete();
        end
    endtask

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
                if(valid_pkt_etype_port3[i].payload_q.size() <= 1500) begin
                    valid_mac_pkt_port3.push_back(valid_pkt_etype_port3[i]);
                end else begin
                    payload_drop[PORT3_IDX]++;
                    axis_tdata_port0.delete();
                end
            end
            valid_pkt_etype_port3.delete();
        end
    endtask

    task check_port4_payload();
        forever begin
            wait (valid_pkt_etype_port4.size() > 0);
            foreach (valid_pkt_etype_port4[i]) begin
                if(valid_pkt_etype_port4[i].payload_q.size() <= 1500) begin
                    valid_mac_pkt_port4.push_back(valid_pkt_etype_port4[i]);
                end else begin
                    payload_drop[PORT4_IDX]++;
                    axis_tdata_port1.delete();
                end
            end
            valid_pkt_etype_port4.delete();
        end
    endtask

    task check_port5_payload();
        forever begin
            wait (valid_pkt_etype_port5.size() > 0);
            foreach (valid_pkt_etype_port5[i]) begin
                if(valid_pkt_etype_port5[i].payload_q.size() <= 1500) begin
                    valid_mac_pkt_port5.push_back(valid_pkt_etype_port5[i]);
                end else begin
                    payload_drop[PORT5_IDX]++;
                    axis_tdata_port2.delete();
                end
            end
            valid_pkt_etype_port5.delete();
        end
    endtask

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
                addr = {port_id, valid_mac_pkt_port3[i].vlan}; 
                
                if (ral.conn_cfg_reg_h[addr] != null) begin
                    conn_valid_field = ral.conn_cfg_reg_h[addr].connection_valid;
                    conn_valid_bit = conn_valid_field.get();
                    
                    if (conn_valid_bit == 1) begin
                        valid[PORT3_IDX]++;
                        valid_conn_cfg_port3.push_back(valid_mac_pkt_port3[i]);
                    end else begin
                        axis_tdata_port0.delete();
                        invalid[PORT3_IDX]++;
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
            wait (valid_mac_pkt_port4.size() > 0);
            foreach (valid_mac_pkt_port4[i]) begin
                addr = {port_id, valid_mac_pkt_port4[i].vlan};
                if (ral.conn_cfg_reg_h[addr] != null) begin
                    conn_valid_field = ral.conn_cfg_reg_h[addr].connection_valid;
                    conn_valid_bit = conn_valid_field.get();
                    
                    if (conn_valid_bit == 1) begin
                        valid[PORT4_IDX]++;
                        valid_conn_cfg_port4.push_back(valid_mac_pkt_port4[i]);
                    end else begin
                        invalid[PORT4_IDX]++;
                        axis_tdata_port1.delete();
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
                addr = {port_id, valid_mac_pkt_port5[i].vlan};
                if (ral.conn_cfg_reg_h[addr] != null) begin
                    conn_valid_field = ral.conn_cfg_reg_h[addr].connection_valid;
                    conn_valid_bit = conn_valid_field.get();
                    
                    if (conn_valid_bit == 1) begin
                        valid[PORT5_IDX]++;
                        valid_conn_cfg_port5.push_back(valid_mac_pkt_port5[i]);
                    end else begin
                        invalid[PORT5_IDX]++;
                        axis_tdata_port2.delete();
                    end
                end
            end
            valid_mac_pkt_port5.delete();
        end
    endtask 

    // -----------------------------------------------------------------
    // VCID FETCH & PACKET CONVERSION
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
        mac_tx_seq_item current_pkt; 
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
            
            // REMOVED WAIT FOR TDATA (AS REQUESTED)
            current_pkt = valid_conn_cfg_port3.pop_front(); 
            current_tdata = axis_tdata_port0.pop_front(); 
            
            cnn_addr = {port_id, current_pkt.vlan}; 
            
            if (ral.conn_cfg_reg_h[cnn_addr] != null) begin
                conn_id_field = ral.conn_cfg_reg_h[cnn_addr].connection_id;
                vcid_addr     = conn_id_field.get();
                
                if (ral.vcid_reg_h[vcid_addr] != null) begin
                    vcid_field = ral.vcid_reg_h[vcid_addr].vcid;
                    vcid       = vcid_field.get();

                    // Generate MAC expected
                    expected_pkt = get_rx_expected(current_pkt, vcid);
                    expected_port3.write(expected_pkt);
                    
                    // Generate TDATA expected (With Null Check)
                    if(current_tdata != null) begin
                        expected_tdata = expected_tdata_pkt(current_tdata,vcid);
                        if(expected_tdata != null) begin
                            tdata_expected_port3.write(expected_tdata);
                        end
                    end else begin
                        `uvm_error("TDATA_MISSING", "Expected TDATA packet at Port 3 but queue was empty")
                    end
                end
            end
       end
    endtask

    task vcid_fatch_port4();
        emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) expected_pkt_p4;
        mac_tx_seq_item current_pkt_p4;
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
            
            cnn_addr = {port_id, current_pkt_p4.vlan}; 
            
            if (ral.conn_cfg_reg_h[cnn_addr] != null) begin
                conn_id_field = ral.conn_cfg_reg_h[cnn_addr].connection_id;
                vcid_addr     = conn_id_field.get();
                
                if (ral.vcid_reg_h[vcid_addr] != null) begin
                    vcid_field = ral.vcid_reg_h[vcid_addr].vcid;
                    vcid       = vcid_field.get();

                    expected_pkt_p4 = get_rx_expected(current_pkt_p4, vcid);
                    expected_port4.write(expected_pkt_p4);
                    
                    if(current_tdata != null) begin
                        expected_tdata_p4 = expected_tdata_pkt(current_tdata,vcid);
                        if(expected_tdata_p4 != null) begin
                            tdata_expected_port4.write(expected_tdata_p4);
                        end
                    end else begin
                        `uvm_error("TDATA_MISSING", "Expected TDATA packet at Port 4 but queue was empty")
                    end
                end
            end
       end
    endtask

    task vcid_fatch_port5();
        emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) expected_pkt_p5;
        mac_tx_seq_item current_pkt_p5; 
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

            cnn_addr = {port_id, current_pkt_p5.vlan}; 
            
            if (ral.conn_cfg_reg_h[cnn_addr] != null) begin
                conn_id_field = ral.conn_cfg_reg_h[cnn_addr].connection_id;
                vcid_addr     = conn_id_field.get();
                
                if (ral.vcid_reg_h[vcid_addr] != null) begin
                    vcid_field = ral.vcid_reg_h[vcid_addr].vcid;
                    vcid       = vcid_field.get();

                    expected_pkt_p5 = get_rx_expected(current_pkt_p5, vcid);
                    expected_port5.write(expected_pkt_p5);
                    
                    if(current_tdata != null) begin
                        expected_tdata_p5 = expected_tdata_pkt(current_tdata,vcid);
                        if(expected_tdata_p5 != null) begin
                            tdata_expected_port5.write(expected_tdata_p5);
                        end
                    end else begin
                        `uvm_error("TDATA_MISSING", "Expected TDATA packet at Port 5 but queue was empty")
                    end
                end
            end
       end
    endtask

    // -----------------------------------------------------------------
    // HELPER FUNCTION: TDATA MODIFICATION (THE FIXED LOGIC)
    // -----------------------------------------------------------------
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

        if (!$cast(modified_tdata, original_tdata.clone())) begin
            `uvm_fatal("CAST_FAIL", "Cast failed")
        end
        
        // STEP 1: UNPACK (BIG ENDIAN - MSB FIRST)
        foreach(original_tdata.tdata_q[i]) begin
            temp_word = {<<8{original_tdata.tdata_q[i]}};
            byte_stream.push_back(temp_word[31:24]);
            byte_stream.push_back(temp_word[23:16]);
            byte_stream.push_back(temp_word[15:8]);
            byte_stream.push_back(temp_word[7:0]);
        end

        // STEP 2: STRIP GARBAGE
        last_idx = original_tdata.tkeep_q.size() - 1;
        case(original_tdata.tkeep_q[last_idx])
            4'h1 : valid_bytes_in_last_beat = 1; 
            4'h3 : valid_bytes_in_last_beat = 2; 
            4'h7 : valid_bytes_in_last_beat = 3; 
            4'hF : valid_bytes_in_last_beat = 4;
            default: valid_bytes_in_last_beat = 4;
        endcase
        padding_bytes = 4 - valid_bytes_in_last_beat;
        repeat(padding_bytes) void'(byte_stream.pop_back());

        // STEP 3: MODIFY (Remove TCI, Insert VCID)
        if (byte_stream.size() >= 14) begin 
            byte_stream.delete(12); // Remove TCI High
            byte_stream.delete(12); // Remove TCI Low
            byte_stream.insert(12, vcid); // Insert VCID
        end else begin
            `uvm_error("FRAME_SHORT", "Frame too short")
            return null;
        end

        // STEP 4: REPACK (BIG ENDIAN -> LITTLE ENDIAN SWAP)
        modified_tdata.tdata_q.delete();
        modified_tdata.tkeep_q.delete();

        while(byte_stream.size() > 0) begin
            bit [31:0] new_word = 0;
            bit [3:0]  new_keep = 0;
            int bytes_to_pop;

            bytes_to_pop = (byte_stream.size() >= 4) ? 4 : byte_stream.size();

            // Fill MSB First (Big Endian Construction)
            if (bytes_to_pop >= 1) begin new_word[31:24] = byte_stream.pop_front(); end
            if (bytes_to_pop >= 2) begin new_word[23:16] = byte_stream.pop_front(); end
            if (bytes_to_pop >= 3) begin new_word[15:8]  = byte_stream.pop_front(); end
            if (bytes_to_pop >= 4) begin new_word[7:0]   = byte_stream.pop_front(); end
            
            // Calculate Keep
            case(bytes_to_pop)
                1: new_keep = 4'h1; 
                2: new_keep = 4'h3; 
                3: new_keep = 4'h7; 
                4: new_keep = 4'hF; 
            endcase
            
            // Swap to Little Endian for Bus
            new_word = {<<8{new_word}};

            modified_tdata.tdata_q.push_back(new_word);
            modified_tdata.tkeep_q.push_back(new_keep);
        end
        
        return modified_tdata;
    endfunction

    // -----------------------------------------------------------------
    // HELPER FUNCTION: MAC FIELD MAPPING
    // -----------------------------------------------------------------
    function emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) get_rx_expected(
        mac_tx_seq_item valid_expected_pkt, 
        bit [7:0] vcid
    );
        emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) expected_pkt;
        expected_pkt = emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)::type_id::create("expected_pkt");

        // MAP FIELDS
        expected_pkt.source_mac_addr = valid_expected_pkt.sa;       
        expected_pkt.dest_mac_addr   = valid_expected_pkt.da;      
        expected_pkt.vcid            = vcid;
        expected_pkt.e_type          = valid_expected_pkt.Etype;   
        expected_pkt.payload         = valid_expected_pkt.payload_q; 
        
        return expected_pkt;
    endfunction

    // -----------------------------------------------------------------
    // FINAL REPORT
    // -----------------------------------------------------------------
    function void final_phase(uvm_phase phase);
        super.final_phase(phase);
        
        total_pkts_received = 0;
        total_conn_invalid_drop = 0;
        
        for (int i = 0; i < NUM_PORTS; i++) begin
            total_pkts_received += pkt_in_port[i]; 
            total_conn_invalid_drop += invalid[i];
        end
        
        `uvm_info(get_full_name(), "\n--------------------------- Expected Packet Summary ---------------------------------------", UVM_LOW)
        $display("Total Packets received on all input ports = %0d", total_pkts_received);
        $display("No. of packet received at in_port0 = %0d", pkt_in_port[PORT3_IDX]);
        $display("No. of packet received at in_port1 = %0d", pkt_in_port[PORT4_IDX]);
        $display("No. of packet received at in_port2 = %0d", pkt_in_port[PORT5_IDX]);
        $display("No. of packet dropped due to connection invalid = %0d", total_conn_invalid_drop);
        $display("No of expected packet at out_port0 = %0d", expected_out_port[PORT3_IDX]);
        $display("No of expected packet at out_port1 = %0d", expected_out_port[PORT4_IDX]);
        $display("No of expected packet at out_port2 = %0d", expected_out_port[PORT5_IDX]);
        $display("No of actual packet at out_port0 = %0d", actual_out_port[PORT3_IDX]);
        $display("No of actual packet at out_port1 = %0d", actual_out_port[PORT4_IDX]);
        $display("No of actual packet at out_port2 = %0d", actual_out_port[PORT5_IDX]);
        `uvm_info(get_full_name(), "------------------------------------------------------------------------------------------\n", UVM_LOW)
    endfunction

endclass
`endif
