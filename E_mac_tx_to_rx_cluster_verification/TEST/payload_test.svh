/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : mac_to_axi_s_payload_test.svh

* Purpose : to check whether the design is transfering the payload only when the range is between 46 to 1500 else dropping it. 

* Creation Date : 02-12-2025

* Last Modified :

* Created By : Joel Joseph  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef MAC_TO_AXI_S_PAYLOAD_TEST_SV
`define MAC_TO_AXI_S_PAYLOAD_TEST_SV

class mac_to_axi_s_payload_seqs extends mac_to_axi_s_base_virtual_seqs;
	
	`uvm_object_utils_begin(mac_to_axi_s_payload_seqs)
	`uvm_object_utils_end

	function new(string name = "mac_to_axi_s_payload_seqs");
		super.new(name);
	endfunction : new

	task body();

// description
		repeat(1) begin

    $display(" RAL SEQS ");
		  //port - 3
		  if(!conn_cfg_seqs.randomize() with {
        connection_valid == 1'b1; vlan == 'h7; port_id == 'd3; out_port_sel == 'd8;
      })
			  `uvm_error(get_full_name(),"Randomization Failed!!")
			conn_cfg_seqs.start(null);
      temp_vlan_q[0].push_back(conn_cfg_seqs.vlan);
		
      //port - 4
		  if(!conn_cfg_seqs.randomize() with {
        connection_valid == 1'b1; vlan == 'h77; port_id == 'd4; out_port_sel == 'd9;
      })
			  `uvm_error(get_full_name(),"Randomization Failed!!")
			conn_cfg_seqs.start(null);
      temp_vlan_q[1].push_back(conn_cfg_seqs.vlan);
		
      //port - 5
	  	if(!conn_cfg_seqs.randomize() with {
        connection_valid == 1'b1; vlan == 'h11; port_id == 'd5; out_port_sel == 'd10;
      })
			  `uvm_error(get_full_name(),"Randomization Failed!!")
			conn_cfg_seqs.start(null);
      temp_vlan_q[2].push_back(conn_cfg_seqs.vlan);
		end
// */

 /*		
		repeat(1) begin

      $display(" RAL SEQS ");
		  //port - 3
		  configure_connection(.in_port_no(0),.out_port_no(0),.conn_valid_bit(1),.no_of_configurations(1),.collect_data(1),.range_of_vlan(3),.range_of_conn_id(3));
      //port - 4
		  configure_connection(.in_port_no(1),.out_port_no(1),.conn_valid_bit(1),.no_of_configurations(1),.collect_data(1),.range_of_vlan(3),.range_of_conn_id(3));
      //port - 5
		  configure_connection(.in_port_no(2),.out_port_no(2),.conn_valid_bit(1),.no_of_configurations(1),.collect_data(1),.range_of_vlan(3),.range_of_conn_id(3));
    end
  */

// /*
		fork
    $display(" Scenerio 1 : payload valid range check ");
     `uvm_do_on_with(mac_tx_seqs[0][0],mac_tx_seqr_h[0],
                    {
                      min_payload_size == 46; max_payload_size == 46; vlan_q.size == temp_vlan_q[0].size; foreach(temp_vlan_q[0][i]) { vlan_q[i] == temp_vlan_q[0][i]; no_of_packet == 1;}
                    })

     `uvm_do_on_with(mac_tx_seqs[1][0],mac_tx_seqr_h[1],
                    {
                      min_payload_size == 46; max_payload_size == 46; vlan_q.size == temp_vlan_q[1].size; foreach(temp_vlan_q[1][i]) { vlan_q[i] == temp_vlan_q[1][i]; no_of_packet == 1;}
                    })

     `uvm_do_on_with(mac_tx_seqs[2][0],mac_tx_seqr_h[2],
                    {
                      min_payload_size == 46; max_payload_size == 46; vlan_q.size == temp_vlan_q[2].size; foreach(temp_vlan_q[2][i]) { vlan_q[i] == temp_vlan_q[2][i]; no_of_packet == 1;}
                    }) 
    join
// */

 /*
    fork
     `uvm_do_on_with(mac_tx_seqs[0][0],mac_tx_seqr_h[0],
                    {
                      min_payload_size == 1500; max_payload_size == 1500; vlan_q.size == temp_vlan_q[0].size; foreach(temp_vlan_q[0][i]) { vlan_q[i] == temp_vlan_q[0][i]; no_of_packet == 1;}
                    })

     `uvm_do_on_with(mac_tx_seqs[1][0],mac_tx_seqr_h[1],
                    {
                      min_payload_size == 1500; max_payload_size == 1500; vlan_q.size == temp_vlan_q[1].size; foreach(temp_vlan_q[1][i]) { vlan_q[i] == temp_vlan_q[1][i]; no_of_packet == 1;}
                    })

     `uvm_do_on_with(mac_tx_seqs[2][0],mac_tx_seqr_h[2],
                    {
                      min_payload_size == 1500; max_payload_size == 1500; vlan_q.size == temp_vlan_q[2].size; foreach(temp_vlan_q[2][i]) { vlan_q[i] == temp_vlan_q[2][i]; no_of_packet == 1;}
                    })
    join
*/ 

 /*
    fork
    $display(" Scenerio 2 :payload invalid range check ");
     `uvm_do_on_with(mac_tx_seqs[0][0],mac_tx_seqr_h[0],
                    {
                      min_payload_size == 45; max_payload_size == 45; vlan_q.size == temp_vlan_q[0].size; foreach(temp_vlan_q[0][i]) { vlan_q[i] == temp_vlan_q[0][i]; no_of_packet == 1;}
                    })

     `uvm_do_on_with(mac_tx_seqs[1][0],mac_tx_seqr_h[1],
                    {
                      min_payload_size == 45; max_payload_size == 45; vlan_q.size == temp_vlan_q[1].size; foreach(temp_vlan_q[1][i]) { vlan_q[i] == temp_vlan_q[1][i]; no_of_packet == 1;}
                    })

     `uvm_do_on_with(mac_tx_seqs[2][0],mac_tx_seqr_h[2],
                    {
                      min_payload_size == 45; max_payload_size == 45; vlan_q.size == temp_vlan_q[2].size; foreach(temp_vlan_q[2][i]) { vlan_q[i] == temp_vlan_q[2][i]; no_of_packet == 1;}
                    })
    join
 */ 




 /*
    fork
     `uvm_do_on_with(mac_tx_seqs[0][0],mac_tx_seqr_h[0],
                    {
                      min_payload_size == 1501; max_payload_size == 1501; vlan_q.size == temp_vlan_q[0].size; foreach(temp_vlan_q[0][i]) { vlan_q[i] == temp_vlan_q[0][i]; no_of_packet == 1;}
                    })

     `uvm_do_on_with(mac_tx_seqs[1][0],mac_tx_seqr_h[1],
                    {
                      min_payload_size == 1501; max_payload_size == 1501; vlan_q.size == temp_vlan_q[1].size; foreach(temp_vlan_q[1][i]) { vlan_q[i] == temp_vlan_q[1][i]; no_of_packet == 1;}
                    })

     `uvm_do_on_with(mac_tx_seqs[2][0],mac_tx_seqr_h[2],
                    {
                      min_payload_size == 1501; max_payload_size == 1501; vlan_q.size == temp_vlan_q[2].size; foreach(temp_vlan_q[2][i]) { vlan_q[i] == temp_vlan_q[2][i]; no_of_packet == 1;}
                    })
    join
 */ 


	endtask : body
	
endclass : mac_to_axi_s_payload_seqs	



class mac_to_axi_s_payload_test extends mac_to_axi_s_base_test;
    
	mac_to_axi_s_payload_seqs payload_seqs;
  
  `uvm_component_utils_begin(mac_to_axi_s_payload_test)
	`uvm_component_utils_end
  
  function new(string name="mac_to_axi_s_payload_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new
 
  function void build_phase(uvm_phase phase);
		super.build_phase(phase);
  endfunction : build_phase
 
  task run_phase(uvm_phase phase);
   	//super.run_phase(phase);
	
    payload_seqs = mac_to_axi_s_payload_seqs::type_id::create("payload_seqs");
    phase.raise_objection(this);
		payload_seqs.start(env_h.vseqr_h);
		#50us;
		phase.drop_objection(this);
  endtask : run_phase 
  
endclass : mac_to_axi_s_payload_test

`endif 
