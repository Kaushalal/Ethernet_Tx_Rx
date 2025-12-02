
`ifndef MAC_TX_RX_REF_MODEL
`define MAC_TX_RX_REF_MODEL

  localparam PORT3_IDX = 0;
  localparam PORT4_IDX = 1;
  localparam PORT5_IDX = 2;
  localparam NUM_PORTS = 3;
  localparam PAYLOAD_DATA_WIDTH = 8;
  localparam FRAME_DATA_WIDTH = 32;



    // Analysis Imp declarations
    `uvm_analysis_imp_decl(_tx_mon_port0)
    `uvm_analysis_imp_decl(_tx_mon_port1)
    `uvm_analysis_imp_decl(_tx_mon_port2)

    `uvm_analysis_imp_decl(_axis_mon_port0)
    `uvm_analysis_imp_decl(_axis_mon_port1)
    `uvm_analysis_imp_decl(_axis_mon_port2)


class emac_tx2rx_ref_model extends uvm_scoreboard;
     
     
     // ----  Implication ports will be connected to emac_tx_mon to get frame format input data
    uvm_analysis_imp_tx_mon_port0 #(mac_tx_seq_item, emac_tx2rx_ref_model)                           frame_port0_imp;
    uvm_analysis_imp_tx_mon_port1 #(mac_tx_seq_item, emac_tx2rx_ref_model)                           frame_port1_imp;
    uvm_analysis_imp_tx_mon_port2 #(mac_tx_seq_item, emac_tx2rx_ref_model)                           frame_port2_imp;
   
    // ----  Implication ports will be connected to axis_mas_mon to get tdata_q format input data
    uvm_analysis_imp_axis_mon_port0 #(axi_str_mas_seq_item #(32,32), emac_tx2rx_ref_model)           tdata_port0_imp;
    uvm_analysis_imp_axis_mon_port1 #(axi_str_mas_seq_item #(32,32), emac_tx2rx_ref_model)           tdata_port1_imp;
    uvm_analysis_imp_axis_mon_port2 #(axi_str_mas_seq_item #(32,32), emac_tx2rx_ref_model)           tdata_port2_imp;
    
    // ---   Ports that will be connected to  SCOREBOARD to send expected data in frame format
    uvm_analysis_port #(emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH))                     frame_scrbd_port[];
  
    // ---   Ports that will be connected to  SCOREBOARD to send expected data in tdata_q format
    uvm_analysis_port #(axi_str_mas_seq_item #(32,32))                                               tdata_scrbd_port[];
   
    //stores input frame packet coming form tx_mon

    axi_str_mas_seq_item #(32,32)     tdata_pkt_q[][$];

    mac_tx_seq_item                   packet_q[][$];
    mac_tx_seq_item                   etype_valid_pkt_q[][$];
    mac_tx_seq_item                   payload_valid_pkt_q[][$];
    mac_tx_seq_item                   conn_cfg_valid_pkt_q[][$];

    bit [15:0]           valid_etypes[$] = '{16'h0800, 16'h8100};
    string               port_names[NUM_PORTS] = '{"PORT3", "PORT4", "PORT5"};
    int                  tdata_ref;
    bit [7:0]            global_clean_data_q[$];
    axi_4_reg_block      ral; 
     
    int                  etype_mismatched_count[NUM_PORTS];
    int                  payload_mismatched_count[NUM_PORTS];
    int                  pkt_in_port[NUM_PORTS];
    int                  valid[NUM_PORTS];
    int                  invalid[NUM_PORTS];


    `uvm_component_utils(emac_tx2rx_ref_model)

        
    function new (string name="", uvm_component parent);

        super.new(name, parent);

        //Input ports
        frame_port0_imp = new ("frame_port0_imp", this);
        frame_port1_imp = new ("frame_port1_imp", this);
        frame_port2_imp = new ("frame_port2_imp", this);

        tdata_port0_imp = new ("tdata_port0_imp",this);
        tdata_port1_imp = new ("tdata_port1_imp",this);
        tdata_port2_imp = new ("tdata_port2_imp",this);

        //Ouput ports
        frame_scrbd_port = new[NUM_PORTS];
        foreach(frame_scrbd_port[i]) frame_scrbd_port[i] = new( $sformatf("frame_scrbd_port[%0d]",i), this);

        tdata_scrbd_port = new[NUM_PORTS];
	foreach(tdata_scrbd_port[i]) tdata_scrbd_port[i] = new( $sformatf("tdata_scrbd_port[%0d]",i), this);

        
        tdata_pkt_q          = new[NUM_PORTS];
        packet_q             = new[NUM_PORTS];
        etype_valid_pkt_q    = new[NUM_PORTS];
        payload_valid_pkt_q  = new[NUM_PORTS];
        conn_cfg_valid_pkt_q = new[NUM_PORTS];

        endfunction

    function void build_phase (uvm_phase phase);

        super.build_phase (phase);

        ral = axi_4_reg_block::type_id::create("ral");

        if (!uvm_config_db#(int)::get(this,"","ref_type",tdata_ref)) 	`uvm_fatal(get_full_name(), "set ref_mod type from env")
        else begin
             $display("REF_TYPE=%d",tdata_ref);
             end
        endfunction

    task run_phase(uvm_phase phase);

        super.run_phase (phase);

        etype_check();
        payload_check();
        cnn_cfg_check();
        vcid_fetch();

    endtask

    virtual function void add_etype(bit [15:0] new_etype);
        valid_etypes.push_back(new_etype);
        `uvm_info("REF_ETYPE_ADDED", $sformatf("Added: 0x%04h, Now: %p", new_etype, valid_etypes), UVM_LOW)
        endfunction

    // -----------------------------------------------------------------
    // WRITE FUNCTIONS 
    // -----------------------------------------------------------------

    // Here all write function will push packet in their respective queue



     virtual function void write_axis_mon_port0(axi_str_mas_seq_item #(32,32) axis_tdata);

         static int port0_pkt_count = 0;  
         
         tdata_pkt_q[0].push_back(axis_tdata);
         port0_pkt_count++;
          
         $display("tdata_pkt_at_port3=%0d", port0_pkt_count);
         $display("tdata inside ref model - PORT0");
         axis_tdata.print(); 
         
         `uvm_info("REF_DEBUG", "=== Component Hierarchy Debug PORT0 ===", UVM_LOW)
         `uvm_info("REF_DEBUG", $sformatf("Instance name: %s", get_name()), UVM_LOW)
         `uvm_info("REF_DEBUG", $sformatf("Full name: %s", get_full_name()), UVM_LOW)  
         `uvm_info("REF_DEBUG", $sformatf("Type name: %s", get_type_name()), UVM_LOW)
         `uvm_info(get_full_name(), $sformatf("Got AXI-S Pkt in ref: %s", axis_tdata.sprint()), UVM_LOW)    
         `uvm_info("REF_QUEUE_STATUS", $sformatf("PORT0 queue size: %0d", tdata_pkt_q[0].size()), UVM_HIGH)
         endfunction

     virtual function void write_axis_mon_port1(axi_str_mas_seq_item #(32,32) axis_tdata_p1);

         static int port1_pkt_count = 0;
     
         tdata_pkt_q[1].push_back(axis_tdata_p1);
         port1_pkt_count++;  // Increment counter
         
         $display("tdata inside ref model - PORT1");
         axis_tdata_p1.print();  
         $display("tdata_pkt_at_port4=%0d", port1_pkt_count);
         
         `uvm_info("REF_DEBUG", "=== Component Hierarchy Debug PORT1 ===", UVM_LOW)
         `uvm_info("REF_DEBUG", $sformatf("Instance name: %s", get_name()), UVM_LOW)
         `uvm_info("REF_DEBUG", $sformatf("Full name: %s", get_full_name()), UVM_LOW)  
         `uvm_info("REF_DEBUG", $sformatf("Type name: %s", get_type_name()), UVM_LOW)
         `uvm_info(get_full_name(), $sformatf("Got AXI-S Pkt in ref: %s", axis_tdata_p1.sprint()), UVM_LOW)  
         
         // Optional: Show queue status
         `uvm_info("REF_QUEUE_STATUS", $sformatf("PORT1 queue size: %0d", tdata_pkt_q[1].size()), UVM_HIGH)
         endfunction
 
     virtual function void write_axis_mon_port2(axi_str_mas_seq_item #(32,32) axis_tdata_p2);

          static int port2_pkt_count = 0; 
          
          tdata_pkt_q[2].push_back(axis_tdata_p2);
          port2_pkt_count++;
          
          // Display only the NEW packet that just arrived
          $display("tdata inside ref model - PORT2");
          axis_tdata_p2.print();
          $display("tdata_pkt_at_port2 = %d", port2_pkt_count);
          
          `uvm_info("REF_DEBUG", "=== Component Hierarchy Debug PORT2 ===", UVM_LOW)
          `uvm_info("REF_DEBUG", $sformatf("Instance name: %s", get_name()), UVM_LOW)
          `uvm_info("REF_DEBUG", $sformatf("Full name: %s", get_full_name()), UVM_LOW)  
          `uvm_info("REF_DEBUG", $sformatf("Type name: %s", get_type_name()), UVM_LOW)
          `uvm_info(get_full_name(), $sformatf("Got AXI-S Pkt in ref port 2: %s", axis_tdata_p2.sprint()), UVM_LOW)
          
          // Display queue status (optional)
          `uvm_info("REF_QUEUE_STATUS", $sformatf("PORT2 queue size: %0d", tdata_pkt_q[2].size()), UVM_HIGH)
         endfunction

     virtual function void write_tx_mon_port0(mac_tx_seq_item pkt_port3);

          if(!tdata_ref)
             begin

             pkt_in_port[PORT3_IDX]++;
             packet_q[0].push_back(pkt_port3); 
             
             `uvm_info("REF_PACKET_ARRIVED",  $sformatf("%s: Received packet #%0d (Queue size: %0d)", port_names[PORT3_IDX], pkt_in_port[PORT3_IDX], packet_q[0].size()), UVM_LOW)
             
             // Restored loop for printing
             foreach (packet_q[0][i]) begin
                 $display("inside ref model");
                 packet_q[0][i].print();
                 $display("VLAN ID =%h", packet_q[0][i].vlan); 
                 `uvm_info("REF_MODEL", $sformatf("%s: Converting MAC frame: %s",   port_names[PORT3_IDX], packet_q[0][i].convert2string()), UVM_MEDIUM)
                 end

             end
          
	  else
             begin
             $display("Reference Model will send expected data in tdata_q format");
             end

          endfunction
     
     virtual function void write_tx_mon_port1(mac_tx_seq_item pkt_port4);

          if(!tdata_ref)
             begin
             pkt_in_port[PORT4_IDX]++;
             packet_q[1].push_back(pkt_port4); 
             
             `uvm_info("REF_PACKET_ARRIVED", $sformatf("%s: Received packet #%0d (Queue size: %0d)", port_names[PORT4_IDX], pkt_in_port[PORT4_IDX],  packet_q[1].size()),UVM_LOW)
             
             foreach (packet_q[1][i]) begin
                `uvm_info("REF_MODEL", $sformatf("%s: Converting MAC frame: %s",  port_names[PORT4_IDX], packet_q[1][i].convert2string()), UVM_MEDIUM)
                 end
             end
          else
             begin
             $display("Reference Model will send expected data in tdata_q format");
             end
          endfunction

    virtual function void write_tx_mon_port2(mac_tx_seq_item pkt_port5);

            if(!tdata_ref)begin
               pkt_in_port[PORT5_IDX]++;
               packet_q[2].push_back(pkt_port5); 
               
               `uvm_info("REF_PACKET_ARRIVED",  $sformatf("%s: Received packet #%0d (Queue size: %0d)", port_names[PORT5_IDX], pkt_in_port[PORT5_IDX],packet_q[2].size()),UVM_LOW)
               
               foreach (packet_q[2][i]) 
	           begin
                   `uvm_info("REF_MODEL", $sformatf("%s: Converting MAC frame: %s", port_names[PORT5_IDX], packet_q[2][i].convert2string()), UVM_MEDIUM)
                   end
               end
            else 
		begin
                $display("Reference Model will send expected data in tdata_q format");
                end
          
    endfunction

    // -----------------------------------------------------------------
    // ETYPE CHECKS (With Restored Logging)
    // ----------------------------------------------------------------- 
    //Here it push packet that have valid etype in etype_valid_pkt_q , and increment the counter of etype_mismatched_count to indicate no of packet with invalid etype 
    //
    task etype_check();

        fork
            etype_check_port0();
            etype_check_port1();
            etype_check_port3();
        join_none
    endtask

    task etype_check_port0();

        forever begin
            wait(packet_q[0].size() > 0);
            `uvm_info("REF_PORT3_CHECK", $sformatf("Processing %0d packets", packet_q[0].size()), UVM_HIGH)

            foreach (packet_q[0][i]) begin
                 if (packet_q[0][i].Etype inside {valid_etypes}) begin
                    `uvm_info("REF_VALID ETYPE", $sformatf("%s: EType=%h", port_names[PORT3_IDX], packet_q[0][i].Etype), UVM_LOW);
                    etype_valid_pkt_q[0].push_back(packet_q[0][i]);
                    end
	         else
                    begin
                    etype_mismatched_count[PORT3_IDX]++;
                    tdata_pkt_q[0].delete();
                    `uvm_info("REF_INVALID ETYPE", $sformatf("%s: EType=%h - DROPPED", port_names[PORT3_IDX], packet_q[0][i].Etype), UVM_LOW);
                    end
            end
            packet_q[0].delete(); 
        end
        endtask

    task etype_check_port1();

        forever begin
            wait (packet_q[1].size() > 0);
            `uvm_info("REF_PORT4_ETYPE_CHECK", $sformatf("Processing %0d packets", packet_q[1].size()), UVM_DEBUG)

            foreach (packet_q[1][i]) begin
                if (packet_q[1][i].Etype inside {valid_etypes}) begin
                    `uvm_info("REF_VALID ETYPE", $sformatf("%s: EType=%h", port_names[PORT4_IDX], packet_q[1][i].Etype), UVM_LOW);
                    etype_valid_pkt_q[1].push_back(packet_q[1][i]);
                    end 
		else 
	            begin
                    etype_mismatched_count[PORT4_IDX]++;
                    tdata_pkt_q[1].delete();
                    `uvm_info("REF_INVALID ETYPE", $sformatf("%s: EType=%h - DROPPED", port_names[PORT4_IDX], packet_q[1][i].Etype), UVM_LOW);
                    end
            end
            packet_q[1].delete();
        end
        endtask

    task etype_check_port3();

        forever begin
            wait (packet_q[2].size() > 0);
            `uvm_info("REF_PORT5_ETYPE_CHECK", $sformatf("Processing %0d packets", packet_q[2].size()), UVM_HIGH)

            foreach (packet_q[2][i]) begin
                if (packet_q[2][i].Etype inside {valid_etypes}) begin
                    `uvm_info("REF_VALID ETYPE", $sformatf("%s: EType=%h", port_names[PORT5_IDX], packet_q[2][i].Etype), UVM_LOW);
                    etype_valid_pkt_q[2].push_back(packet_q[2][i]);
                    end
	        else
                    begin
                    etype_mismatched_count[PORT5_IDX]++;
                    tdata_pkt_q[2].delete();
                    `uvm_info("REF_INVALID ETYPE", $sformatf("%s: EType=%h - DROPPED", port_names[PORT5_IDX], packet_q[2][i].Etype), UVM_LOW)
                    end
            end
            packet_q[2].delete();
        end
        endtask

    // -----------------------------------------------------------------
    // PAYLOAD CHECKS (With Restored Logging)
    // -----------------------------------------------------------------
    // Here it check for payload size of packet for etype_valid_pkt_q and if it is less then 1500 it will store packet in payload_valid_pkt_q or else it will increment count for payload_mismatched_count
    task payload_check();

        fork
            payload_check_port0();
            payload_check_port1();
            payload_check_port2();
        join_none
    endtask

    task payload_check_port0();

        forever begin
            wait (etype_valid_pkt_q[0].size() > 0);
            foreach (etype_valid_pkt_q[0][i]) begin
                if(etype_valid_pkt_q[0][i].payload_q.size() <= 1500) begin
                    `uvm_info("REF_VALID PAYLOAD SIZE", $sformatf("%s: payload_q size=%d", port_names[PORT3_IDX], etype_valid_pkt_q[0][i].payload_q.size()), UVM_DEBUG);
                    payload_valid_pkt_q[0].push_back(etype_valid_pkt_q[0][i]);
                    `uvm_info("REF_[RETURN VALID E MAC PKT]","PORT 3",UVM_LOW)
                    end
	        else
                    begin
                    payload_mismatched_count[PORT3_IDX]++;
                    tdata_pkt_q[0].delete();
                    `uvm_info("REF_INVALID PAYLOAD SIZE", $sformatf("%s: PAYLOAD SIZE=%d - DROPPED", port_names[PORT3_IDX], etype_valid_pkt_q[0][i].payload_q.size()), UVM_LOW);
                end
            end
            etype_valid_pkt_q[0].delete();
        end
    endtask

    task payload_check_port1();

        forever begin
           $display("port4 valid pkt etype queu size=%d",etype_valid_pkt_q[1].size() );
            wait (etype_valid_pkt_q[1].size() > 0);
            `uvm_info("REF_PORT4_PAYLOAD_CHECK", $sformatf("Processing %0d packets", etype_valid_pkt_q[1].size()), UVM_DEBUG)
            foreach (etype_valid_pkt_q[1][i]) begin
                if(etype_valid_pkt_q[1][i].payload_q.size() <= 1500) begin
                    `uvm_info("REF_VALID PAYLOAD", $sformatf("%s: PAYLOAD SIZE=%d", port_names[PORT4_IDX], etype_valid_pkt_q[1][i].payload_q.size()), UVM_DEBUG)
                    payload_valid_pkt_q[1].push_back(etype_valid_pkt_q[1][i]);
                end else begin
                    payload_mismatched_count[PORT4_IDX]++;
                    tdata_pkt_q[1].delete();
                    `uvm_info("REF_INVALID PAYLOAD SIZE", $sformatf("%s: PAYLOAD=%d - DROPPED", port_names[PORT4_IDX], etype_valid_pkt_q[1][i].payload_q.size()), UVM_LOW)
                end
            end
            etype_valid_pkt_q[1].delete();
        end
    endtask

    task payload_check_port2();
        forever begin
            wait (etype_valid_pkt_q[2].size() > 0);
            `uvm_info("REF_PORT5_ETYPE_CHECK", $sformatf("Processing %0d packets", etype_valid_pkt_q[2].size()), UVM_HIGH)
            foreach (etype_valid_pkt_q[2][i]) begin
                if(etype_valid_pkt_q[2][i].payload_q.size() <= 1500) begin
                    `uvm_info("REF_VALID PAYLOAD", $sformatf("%s: payload_q=%d", port_names[PORT5_IDX], etype_valid_pkt_q[2][i].payload_q.size()), UVM_HIGH);
                    payload_valid_pkt_q[2].push_back(etype_valid_pkt_q[2][i]);
                end else begin
                    payload_mismatched_count[PORT5_IDX]++;
                    tdata_pkt_q[2].delete();
                    `uvm_info("REF_INVALID PAYLOAD SIZE", $sformatf("%s: PAYLOAD SIZE=%D - DROPPED", port_names[PORT5_IDX], etype_valid_pkt_q[2][i].payload_q.size()), UVM_LOW)
                end
            end
            etype_valid_pkt_q[2].delete();
        end
    endtask

    // -----------------------------------------------------------------
    // CONFIG CHECKS (With Restored Logging)
    // -----------------------------------------------------------------
    task cnn_cfg_check();
        fork
            cfg_check_port0();
            cfg_check_port1();
            cfg_check_port2();
        join_none
    endtask

    task cfg_check_port0();
        bit [14:0] addr;
        bit [2:0] port_id = 3;
        bit conn_valid_bit;
        uvm_reg_field conn_valid_field; 
        
        forever begin
            wait (payload_valid_pkt_q[0].size() > 0);
            
            foreach(payload_valid_pkt_q[0][i]) begin
                addr = {port_id, payload_valid_pkt_q[0][i].vlan}; 
                
                if (ral.conn_cfg_reg_h[addr] != null) begin
                    conn_valid_field = ral.conn_cfg_reg_h[addr].connection_valid;
                    conn_valid_bit = conn_valid_field.get();
                    
                    $display("CNN_CFG[%5d]: CONN_VALID=%0d", addr, conn_valid_bit); // Restored

                    if (conn_valid_bit == 1) begin
                        valid[PORT3_IDX]++;
                        conn_cfg_valid_pkt_q[0].push_back(payload_valid_pkt_q[0][i]);
                        `uvm_info("REF_CONNECTION VALID", $sformatf("%s: CONN_VALID=%0d", port_names[PORT3_IDX], conn_valid_bit), UVM_LOW);
                    end else begin
                      tdata_pkt_q[0].delete();
                        invalid[PORT3_IDX]++;
                        `uvm_info("REF_CONNECTION INVALID", $sformatf("%s: CONN_VALID=%0d", port_names[PORT3_IDX], conn_valid_bit), UVM_LOW);
                    end
                end
            end  
            payload_valid_pkt_q[0].delete();
        end
    endtask

    task cfg_check_port1();
        bit [14:0] addr;
        bit [2:0] port_id = 4;
        bit conn_valid_bit;
        uvm_reg_field conn_valid_field; 
        forever begin
            $display("VALID PAYLOAD PKY P4=%d",payload_valid_pkt_q[1].size());
            wait (payload_valid_pkt_q[1].size() > 0);
            foreach (payload_valid_pkt_q[1][i]) begin
                addr = {port_id, payload_valid_pkt_q[1][i].vlan};
                if (ral.conn_cfg_reg_h[addr] != null) begin
                    conn_valid_field = ral.conn_cfg_reg_h[addr].connection_valid;
                    conn_valid_bit = conn_valid_field.get();
                    
                    $display("CNN_CFG[%5d]: CONN_VALID=%0d", addr, conn_valid_bit); // Restored

                    if (conn_valid_bit == 1) begin
                        valid[PORT4_IDX]++;
                        conn_cfg_valid_pkt_q[1].push_back(payload_valid_pkt_q[1][i]);
                        `uvm_info("REF_CONNECTION VALID", $sformatf("%s: CONN_VALID=%0d", port_names[PORT4_IDX], conn_valid_bit), UVM_LOW);
                    end else begin
                        invalid[PORT4_IDX]++;
                        tdata_pkt_q[1].delete();
                        `uvm_info("REF_CONNECTION INVALID", $sformatf("%s: CONN_VALID=%0d", port_names[PORT4_IDX], conn_valid_bit), UVM_LOW);
                    end
                end
            end
            payload_valid_pkt_q[1].delete();
        end
    endtask 

    task cfg_check_port2();
        bit [14:0] addr;
        bit [2:0] port_id = 5;
        bit conn_valid_bit;
        uvm_reg_field conn_valid_field; 
        forever begin
            wait (payload_valid_pkt_q[2].size() > 0);
            foreach (payload_valid_pkt_q[2][i]) begin
                addr = {port_id, payload_valid_pkt_q[2][i].vlan};
                if (ral.conn_cfg_reg_h[addr] != null) begin
                    conn_valid_field = ral.conn_cfg_reg_h[addr].connection_valid;
                    conn_valid_bit = conn_valid_field.get();
                    
                    $display("CNN_CFG[%5d]: CONN_VALID=%0d", addr, conn_valid_bit); // Restored

                    if (conn_valid_bit == 1) begin
                        valid[PORT5_IDX]++;
                        conn_cfg_valid_pkt_q[2].push_back(payload_valid_pkt_q[2][i]);
                        `uvm_info("REF_CONNECTION VALID", $sformatf("%s: CONN_VALID=%0d", port_names[PORT5_IDX], conn_valid_bit), UVM_LOW);
                    end else begin
                        invalid[PORT5_IDX]++;
                    tdata_pkt_q[2].delete();
                        `uvm_info("REF_CONNECTION INVALID", $sformatf("%s: CONN_VALID=%0d", port_names[PORT5_IDX], conn_valid_bit), UVM_LOW);
                    end
                end
            end
            payload_valid_pkt_q[2].delete();
        end
    endtask 

    // -----------------------------------------------------------------
    // VCID FETCH & PACKET CONVERSION (With Restored Logging)
    // -----------------------------------------------------------------
    task vcid_fetch();
       fork
          vcid_fetch_port0();
          vcid_fetch_port1();
          vcid_fetch_port2();
       join_none
    endtask

    task vcid_fetch_port0();

        emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) expected_pkt;
        mac_tx_seq_item               current_pkt;
        axi_str_mas_seq_item #(32,32) expected_tdata;  
        axi_str_mas_seq_item #(32,32) current_tdata;  
        bit [14:0] cnn_addr;
        bit [2:0]  port_id = 3;
        bit [4:0]  vcid_addr;
        bit [7:0]  vcid;
        uvm_reg_field conn_id_field;
        uvm_reg_field vcid_field;

        forever begin

            wait(conn_cfg_valid_pkt_q[0].size() > 0);
            //wait(tdata_pkt_q[0].size() >0);
            current_pkt = conn_cfg_valid_pkt_q[0].pop_front(); 
            current_tdata = tdata_pkt_q[0].pop_front();
            cnn_addr = {port_id, current_pkt.vlan}; 
            
            if (ral.conn_cfg_reg_h[cnn_addr] != null)
        	begin
                conn_id_field = ral.conn_cfg_reg_h[cnn_addr].connection_id;
                vcid_addr     = conn_id_field.get();

                `uvm_info("REF_VCID REG ADDR", $sformatf ("VCID_ADDR_PORT3=%h", vcid_addr), UVM_LOW) // Restored

                if (ral.vcid_reg_h[vcid_addr] != null) begin

                    vcid_field = ral.vcid_reg_h[vcid_addr].vcid;
                    vcid       = vcid_field.get();
                    $display("REF_VCID=%h",vcid); 
                    `uvm_info("REF_VCID_PORT0", $sformatf ("VCID_PORT3=%h", vcid), UVM_LOW) // Restored

                    expected_pkt = get_rx_expected(current_pkt, vcid);
                    frame_scrbd_port[0].write(expected_pkt);

                    expected_tdata = expected_tdata_pkt(current_tdata,vcid);
                    tdata_scrbd_port[0].write(expected_tdata);
                end
            end
        end
    endtask
    task vcid_fetch_port1();
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
            wait(conn_cfg_valid_pkt_q[1].size() > 0);

            current_pkt_p4 = conn_cfg_valid_pkt_q[1].pop_front(); 
            current_tdata = tdata_pkt_q[1].pop_front();
            cnn_addr = {port_id, current_pkt_p4.vlan}; 
            
            if (ral.conn_cfg_reg_h[cnn_addr] != null) begin
                conn_id_field = ral.conn_cfg_reg_h[cnn_addr].connection_id;
                vcid_addr     = conn_id_field.get();
                
                `uvm_info("REF_VCID REG ADDR", $sformatf ("VCID_ADDR_PORT4=%h", vcid_addr), UVM_LOW) // Restored
                
                if (ral.vcid_reg_h[vcid_addr] != null) begin
                    vcid_field = ral.vcid_reg_h[vcid_addr].vcid;
                    vcid       = vcid_field.get();
                    $display("REF_VCID=%h",vcid); 
                    `uvm_info("REF_VCID", $sformatf ("VCID_PORT4=%h", vcid), UVM_LOW) // Restored

                    expected_pkt_p4 = get_rx_expected(current_pkt_p4, vcid);
                    frame_scrbd_port[2].write(expected_pkt_p4);
                    expected_tdata_p4 = expected_tdata_pkt(current_tdata,vcid);
                    tdata_scrbd_port[2].write(expected_tdata_p4);
                end
            end
       end
    endtask

    task vcid_fetch_port2();
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
            wait(conn_cfg_valid_pkt_q[2].size() > 0);

            current_pkt_p5 = conn_cfg_valid_pkt_q[2].pop_front(); 
            current_tdata = tdata_pkt_q[2].pop_front();
            cnn_addr = {port_id, current_pkt_p5.vlan}; 
            
            if (ral.conn_cfg_reg_h[cnn_addr] != null) begin
                conn_id_field = ral.conn_cfg_reg_h[cnn_addr].connection_id;
                vcid_addr     = conn_id_field.get();
                
                `uvm_info("REF_VCID REG ADDR", $sformatf ("VCID_ADDR_PORT5=%h", vcid_addr), UVM_LOW) // Restored
                
                if (ral.vcid_reg_h[vcid_addr] != null) begin
                    vcid_field = ral.vcid_reg_h[vcid_addr].vcid;
                    vcid       = vcid_field.get();
                    $display("REF_VCID=%h",vcid); 
                    `uvm_info("REF_VCID", $sformatf ("VCID_PORT5=%h", vcid), UVM_LOW) // Restored

                    expected_pkt_p5 = get_rx_expected(current_pkt_p5, vcid);
                    frame_scrbd_port[2].write(expected_pkt_p5);
                    expected_tdata_p5 = expected_tdata_pkt(current_tdata,vcid);
                    $display("PORT 10 DEBUG");
                    expected_tdata_p5.print();
                    tdata_scrbd_port[2].write(expected_tdata_p5);
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

    `uvm_info("REF_INPUT_DEBUG", "=== ORIGINAL TRANSACTION (FROM MONITOR) ===", UVM_LOW)
    `uvm_info("REF_INPUT_DEBUG", $sformatf("Total words: %0d", original_tdata.tdata_q.size()), UVM_LOW)
    `uvm_info("REF_INPUT_DEBUG", $sformatf("Last word: %08h", original_tdata.tdata_q[original_tdata.tdata_q.size()-1]), UVM_LOW)
    `uvm_info("REF_INPUT_DEBUG", $sformatf("Last TKEEP: %01h", original_tdata.tkeep_q[original_tdata.tkeep_q.size()-1]), UVM_LOW)

    foreach(original_tdata.tdata_q[i]) begin
        `uvm_info("REF_INPUT_DEBUG", 
                  $sformatf("Word[%0d]: DATA=%08h, TKEEP=%01h", 
                           i, original_tdata.tdata_q[i], original_tdata.tkeep_q[i]), 
                  UVM_LOW)
    end
    // Debug original frame
    `uvm_info("REF_ORIGINAL_DEBUG", 
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

    `uvm_info("REF_BYTE_STREAM_BEFORE", 
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
    
    `uvm_info("REF_TKEEP_ADJUST", 
              $sformatf("Last beat: valid_bytes=%0d, padding_bytes=%0d", 
                       valid_bytes_in_last_beat, padding_bytes), 
              UVM_MEDIUM)

    // Remove padding bytes from the end
    repeat(padding_bytes) void'(byte_stream.pop_back());

    `uvm_info("REF_BYTE_STREAM_AFTER", 
              $sformatf("After TKEEP adjustment: %0d bytes", byte_stream.size()), 
              UVM_HIGH)


    if (byte_stream.size() >= 14) begin 
        // Remove 2-byte TCI (bytes 12-13) and insert 1-byte VCID
        byte_stream.delete(12); // Remove TCI High byte
        byte_stream.delete(12); // Remove TCI Low byte  
        byte_stream.insert(12, vcid); // Insert VCID
        
        `uvm_info("REF_VCID_INSERT", 
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

        `uvm_info("REF_WORD_PACK", 
                  $sformatf("Word[%0d]: DATA=%08h, TKEEP=%01h, bytes=%0d", 
                           modified_tdata.tdata_q.size()-1, new_word, new_keep, bytes_to_pop), 
                  UVM_HIGH)
    end
    
    `uvm_info("REF_MODIFIED_DEBUG", 
              $sformatf("Modified: %0d words, Last word: %08h, Last TKEEP: %01h", 
                       modified_tdata.tdata_q.size(),
                       modified_tdata.tdata_q[modified_tdata.tdata_q.size()-1],
                       modified_tdata.tkeep_q[modified_tdata.tkeep_q.size()-1]), 
              UVM_HIGH)
    `uvm_info("REF_OUTPUT_DEBUG", "=== MODIFIED TRANSACTION (AFTER PROCESSING) ===", UVM_LOW)
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
                                                                                      mac_tx_seq_item valid_expected_pkt,
                                                                                      bit [7:0] vcid
                                                                                      );
        emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH) expected_pkt;
        expected_pkt = emac_rx_seqs_item#(PAYLOAD_DATA_WIDTH,FRAME_DATA_WIDTH)::type_id::create("expected_pkt");

        expected_pkt.source_mac_addr = valid_expected_pkt.sa; 
        expected_pkt.dest_mac_addr   = valid_expected_pkt.da;
        expected_pkt.vcid            = vcid;
        expected_pkt.e_type          = valid_expected_pkt.Etype; 
        expected_pkt.payload         = valid_expected_pkt.payload_q;
        $display("REF_EXPECTED PKT SENDING TO SCB");
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
