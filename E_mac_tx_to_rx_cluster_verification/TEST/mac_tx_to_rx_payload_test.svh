//------------------------------------------------------------------------------
// File Name     : mac_tx_to_rx_payload_test.svh
//
// Purpose       : To verify that the design transfers payload only when the
//                 payload size is within the valid range of 46 to 1500 bytes.
//                 Packets above 1500 are expected to be dropped and packets below 46 are padded to 46
//
// Creation Date : 02-12-2025
// Last Modified : --
//
// Created By    : Joel Joseph
//------------------------------------------------------------------------------


`ifndef MAC_TX_TO_RX_PAYLOAD_TEST_SV
`define MAC_TX_TO_RX_PAYLOAD_TEST_SV

// -----------------------------------------------------------------------------
// mac_tx_to_rx_payload_seqs
// To verify DUT payload-size handling using per-port
// mac_tx sequences. Uses pre-configured VLAN data from temp_vlan_q and
// executes valid ([46:1500]) and invalid ([0:45], [1501:1600]) payload tests
// using constrained `uvm_do_on_with`.
// -----------------------------------------------------------------------------
class mac_tx_to_rx_payload_seqs extends mac_to_axi_s_base_virtual_seqs;
	
	`uvm_object_utils_begin(mac_tx_to_rx_payload_seqs)
	`uvm_object_utils_end

	function new(string name = "mac_tx_to_rx_payload_seqs");
		super.new(name);
	endfunction : new

	task body();

    // -------------------------------------------------------------
    // Randomize port_id and out_port_sel based on in_port_no/out_port_no
    // Generate unique VLAN and Connection IDs
    // Program the registers via conn_cfg_seqs
    // Collect VLAN/VCID/Connection ID into temp_* queues for later use		  
    // -------------------------------------------------------------
		repeat(7) begin
      $display(" RAL SEQS ");
		  
      //port - 3
		  configure_connection(.in_port_no(0),.out_port_no(0),.conn_valid_bit(1),.no_of_configurations(1),.collect_data(1),.range_of_vlan(3),.range_of_conn_id(3));
      //port - 4
		  configure_connection(.in_port_no(1),.out_port_no(1),.conn_valid_bit(1),.no_of_configurations(1),.collect_data(1),.range_of_vlan(3),.range_of_conn_id(3));
      //port - 5
		  configure_connection(.in_port_no(2),.out_port_no(2),.conn_valid_bit(1),.no_of_configurations(1),.collect_data(1),.range_of_vlan(3),.range_of_conn_id(3));
    end

    // -------------------------------------------------------------
    // Scenario 1: Valid payload range check
    // Generates packets with payload size strictly within [46:1500]
    // Ensures min_payload_size <= max_payload_size
    // Uses pre-configured VLANs from temp_vlan_q for each port
    // -------------------------------------------------------------
    $display(" Scenerio 1 : payload valid range check ");
    repeat(5) begin
      fork
        `uvm_do_on_with(mac_tx_seqs[0][0],mac_tx_seqr_h[0],{
                                                              min_payload_size inside {[46:1500]}; 
                                                              max_payload_size inside {[46:1500]}; 
                                                              min_payload_size <= max_payload_size; 
                                                              vlan_q.size == temp_vlan_q[0].size;
                                                              foreach(temp_vlan_q[0][i]) { 
                                                                // enforce same VLAN list collected earlier
                                                                vlan_q[i] == temp_vlan_q[0][i]; 
                                                              }
                                                              no_of_packet == 1;
                                                            })


        `uvm_do_on_with(mac_tx_seqs[1][0],mac_tx_seqr_h[1],{
                                                              min_payload_size inside {[46:1500]}; 
                                                              max_payload_size inside {[46:1500]}; 
                                                              min_payload_size <= max_payload_size;
                                                              vlan_q.size == temp_vlan_q[1].size;
                                                              foreach(temp_vlan_q[1][i]) { 
                                                                vlan_q[i] == temp_vlan_q[1][i]; 
                                                              }
                                                              no_of_packet == 1;
                                                            })

        `uvm_do_on_with(mac_tx_seqs[2][0],mac_tx_seqr_h[2], {
                                                              min_payload_size inside {[46:1500]}; 
                                                              max_payload_size inside {[46:1500]}; 
                                                              min_payload_size <= max_payload_size; 
                                                              vlan_q.size == temp_vlan_q[2].size;
                                                              foreach(temp_vlan_q[2][i]) { 
                                                                vlan_q[i] == temp_vlan_q[2][i]; 
                                                              }
                                                              no_of_packet == 1;
                                                            })
      join
    end

    // -------------------------------------------------------------
    // Scenario 2: Invalid payload range check
    // Generates payloads in invalid ranges: [0:45] and [1501:1600]
    // Ensures min and max lie in the same invalid range
    // Enforces max_payload_size >= min_payload_size
    // Uses pre-configured VLANs from temp_vlan_q
    // -------------------------------------------------------------
    $display(" Scenerio 2 :payload invalid range check ");
    repeat(2) begin
      fork
        `uvm_do_on_with(mac_tx_seqs[0][0],mac_tx_seqr_h[0], {(
                                                             (min_payload_size inside {[0:45]} &&
                                                              max_payload_size inside {[0:45]} &&
                                                              max_payload_size >= min_payload_size)
                                                             ||
                                                             (min_payload_size inside {[1501:1600]} &&
                                                              max_payload_size inside {[1501:1600]} &&
                                                              max_payload_size >= min_payload_size)
                                                            );
                                                            vlan_q.size == temp_vlan_q[0].size;
                                                            foreach(temp_vlan_q[0][i]) { 
                                                              // preserve VLANs collected earlier
                                                              vlan_q[i] == temp_vlan_q[0][i];
                                                              }
                                                             no_of_packet == 1;
                                                            })

        `uvm_do_on_with(mac_tx_seqs[1][0],mac_tx_seqr_h[1],{(
                                                             (min_payload_size inside {[0:45]} &&
                                                              max_payload_size inside {[0:45]} &&
                                                              max_payload_size >= min_payload_size)
                                                             ||
                                                             (min_payload_size inside {[1501:1600]} &&
                                                              max_payload_size inside {[1501:1600]} &&
                                                              max_payload_size >= min_payload_size)
                                                            );
                                                            vlan_q.size == temp_vlan_q[1].size;
                                                            foreach(temp_vlan_q[1][i]) { 
                                                              vlan_q[i] == temp_vlan_q[1][i]; 
                                                              }
                                                             no_of_packet == 1;
                                                            })

        `uvm_do_on_with(mac_tx_seqs[2][0],mac_tx_seqr_h[2],{(
                                                             (min_payload_size inside {[0:45]} &&
                                                              max_payload_size inside {[0:45]} &&
                                                              max_payload_size >= min_payload_size)
                                                             ||
                                                             (min_payload_size inside {[1501:1600]} &&
                                                              max_payload_size inside {[1501:1600]} &&
                                                              max_payload_size >= min_payload_size)
                                                            );
                                                            vlan_q.size == temp_vlan_q[2].size;
                                                            foreach(temp_vlan_q[2][i]) { 
                                                              vlan_q[i] == temp_vlan_q[2][i]; 
                                                              }
                                                             no_of_packet == 1;
                                                            })
      join
    end
	endtask : body
endclass : mac_tx_to_rx_payload_seqs	



class mac_tx_to_rx_payload_test extends mac_to_axi_s_base_test;
    
	mac_tx_to_rx_payload_seqs payload_seqs;
  
  `uvm_component_utils_begin(mac_tx_to_rx_payload_test)
	`uvm_component_utils_end
  
  function new(string name="mac_tx_to_rx_payload_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new
 
  function void build_phase(uvm_phase phase);
		super.build_phase(phase);
  endfunction : build_phase
 
  task run_phase(uvm_phase phase);
    //super.run_phase(phase);
	
    // Create the sequence instance and start it on the virtual sequencer
    payload_seqs = mac_tx_to_rx_payload_seqs::type_id::create("payload_seqs");
    phase.raise_objection(this); // keep simulation running while sequence runs
		payload_seqs.start(env_h.vseqr_h);
		#50us; // wait for test activity (timing is test-specific)
		phase.drop_objection(this); // allow simulation to finish
  endtask : run_phase 
  
endclass : mac_tx_to_rx_payload_test

`endif 

