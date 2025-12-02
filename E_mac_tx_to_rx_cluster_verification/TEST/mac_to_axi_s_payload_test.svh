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

		
		repeat(1) begin

    $display(" RAL SEQS ");
		  //port - 3
		  if(!conn_cfg_seqs.randomize() with {
        connection_valid == 1'b1; vlan == 'h7; port_id == 'd3; out_port_sel == 'd8;
      })
			  `uvm_error(get_full_name(),"Randomization Failed!!")
			conn_cfg_seqs.start(null);
      temp_vlan_q[conn_cfg_seqs.port_id].push_back(conn_cfg_seqs.vlan);
		
      //port - 4
		  if(!conn_cfg_seqs.randomize() with {
        connection_valid == 1'b1; vlan == 'h77; port_id == 'd4; out_port_sel == 'd9;
      })
			  `uvm_error(get_full_name(),"Randomization Failed!!")
			conn_cfg_seqs.start(null);
      temp_vlan_q[conn_cfg_seqs.port_id].push_back(conn_cfg_seqs.vlan);
		
      //port - 5
	  	if(!conn_cfg_seqs.randomize() with {
        connection_valid == 1'b1; vlan == 'h11; port_id == 'd5; out_port_sel == 'd10;
      })
			  `uvm_error(get_full_name(),"Randomization Failed!!")
			conn_cfg_seqs.start(null);
      temp_vlan_q[conn_cfg_seqs.port_id].push_back(conn_cfg_seqs.vlan);
		end
		
// /*
		fork
    $display(" MAC SEQS ");
     `uvm_do_on_with(mac_tx_seqs[3][0],mac_tx_seqr_h[0],
                    {
                      min_payload_size == 46; max_payload_size == 46; vlan_q.size == temp_vlan_q[3].size; foreach(temp_vlan_q[3][i]) { vlan_q[i] == temp_vlan_q[3][i]; no_of_packet == 1;}
                    })

     `uvm_do_on_with(mac_tx_seqs[4][0],mac_tx_seqr_h[1],
                    {
                      min_payload_size == 46; max_payload_size == 46; vlan_q.size == temp_vlan_q[4].size; foreach(temp_vlan_q[4][i]) { vlan_q[i] == temp_vlan_q[4][i]; no_of_packet == 1;}
                    })

     `uvm_do_on_with(mac_tx_seqs[5][0],mac_tx_seqr_h[2],
                    {
                      min_payload_size == 46; max_payload_size == 46; vlan_q.size == temp_vlan_q[5].size; foreach(temp_vlan_q[5][i]) { vlan_q[i] == temp_vlan_q[5][i]; no_of_packet == 1;}
                    }) 
    join
// */

// /*
    fork
     `uvm_do_on_with(mac_tx_seqs[3][0],mac_tx_seqr_h[0],
                    {
                      min_payload_size == 45; max_payload_size == 45; vlan_q.size == temp_vlan_q[3].size; foreach(temp_vlan_q[3][i]) { vlan_q[i] == temp_vlan_q[3][i]; no_of_packet == 1;}
                    })

     `uvm_do_on_with(mac_tx_seqs[4][0],mac_tx_seqr_h[1],
                    {
                      min_payload_size == 45; max_payload_size == 45; vlan_q.size == temp_vlan_q[4].size; foreach(temp_vlan_q[4][i]) { vlan_q[i] == temp_vlan_q[4][i]; no_of_packet == 1;}
                    })

     `uvm_do_on_with(mac_tx_seqs[5][0],mac_tx_seqr_h[2],
                    {
                      min_payload_size == 45; max_payload_size == 45; vlan_q.size == temp_vlan_q[5].size; foreach(temp_vlan_q[5][i]) { vlan_q[i] == temp_vlan_q[5][i]; no_of_packet == 1;}
                    })
    join
// */ 

// /*
    fork
     `uvm_do_on_with(mac_tx_seqs[3][0],mac_tx_seqr_h[0],
                    {
                      min_payload_size == 1500; max_payload_size == 1500; vlan_q.size == temp_vlan_q[3].size; foreach(temp_vlan_q[3][i]) { vlan_q[i] == temp_vlan_q[3][i]; no_of_packet == 1;}
                    })

     `uvm_do_on_with(mac_tx_seqs[4][0],mac_tx_seqr_h[1],
                    {
                      min_payload_size == 1500; max_payload_size == 1500; vlan_q.size == temp_vlan_q[4].size; foreach(temp_vlan_q[4][i]) { vlan_q[i] == temp_vlan_q[4][i]; no_of_packet == 1;}
                    })

     `uvm_do_on_with(mac_tx_seqs[5][0],mac_tx_seqr_h[2],
                    {
                      min_payload_size == 1500; max_payload_size == 1500; vlan_q.size == temp_vlan_q[5].size; foreach(temp_vlan_q[5][i]) { vlan_q[i] == temp_vlan_q[5][i]; no_of_packet == 1;}
                    })
    join
// */ 

// /*
    fork
     `uvm_do_on_with(mac_tx_seqs[3][0],mac_tx_seqr_h[0],
                    {
                      min_payload_size == 1501; max_payload_size == 1501; vlan_q.size == temp_vlan_q[3].size; foreach(temp_vlan_q[3][i]) { vlan_q[i] == temp_vlan_q[3][i]; no_of_packet == 1;}
                    })

     `uvm_do_on_with(mac_tx_seqs[4][0],mac_tx_seqr_h[1],
                    {
                      min_payload_size == 1501; max_payload_size == 1501; vlan_q.size == temp_vlan_q[4].size; foreach(temp_vlan_q[4][i]) { vlan_q[i] == temp_vlan_q[4][i]; no_of_packet == 1;}
                    })

     `uvm_do_on_with(mac_tx_seqs[5][0],mac_tx_seqr_h[2],
                    {
                      min_payload_size == 1501; max_payload_size == 1501; vlan_q.size == temp_vlan_q[5].size; foreach(temp_vlan_q[5][i]) { vlan_q[i] == temp_vlan_q[5][i]; no_of_packet == 1;}
                    })
    join
// */ 

// /*
    repeat(1) begin
      fork
        `uvm_do_on_with(mac_tx_seqs[3][0],mac_tx_seqr_h[0],
                       {
                         min_payload_size == 47; max_payload_size == 1499; vlan_q.size == temp_vlan_q[3].size; foreach(temp_vlan_q[3][i]) { vlan_q[i] == temp_vlan_q[3][i]; no_of_packet == 1;}
                       })

        `uvm_do_on_with(mac_tx_seqs[4][0],mac_tx_seqr_h[1],
                       {
                          min_payload_size == 47; max_payload_size == 1499; vlan_q.size == temp_vlan_q[4].size; foreach(temp_vlan_q[4][i]) { vlan_q[i] == temp_vlan_q[4][i]; no_of_packet == 1;}
                       })

        `uvm_do_on_with(mac_tx_seqs[5][0],mac_tx_seqr_h[2],
                       {
                         min_payload_size == 47; max_payload_size == 1499; vlan_q.size == temp_vlan_q[5].size; foreach(temp_vlan_q[5][i]) { vlan_q[i] == temp_vlan_q[5][i]; no_of_packet == 1;}
                       })
      join
    end
// */ 



 /*
    fork
     `uvm_do_on_with(mac_tx_seqs[3][0],mac_tx_seqr_h[0],
                    {
                      min_payload_size == 1501; max_payload_size == 1600; vlan_q.size == temp_vlan_q[3].size; foreach(temp_vlan_q[3][i]) { vlan_q[i] == temp_vlan_q[3][i]; no_of_packet == 1;}
                    })

     `uvm_do_on_with(mac_tx_seqs[4][0],mac_tx_seqr_h[1],
                    {
                      min_payload_size == 1501; max_payload_size == 1600; vlan_q.size == temp_vlan_q[4].size; foreach(temp_vlan_q[4][i]) { vlan_q[i] == temp_vlan_q[4][i]; no_of_packet == 1;}
                    })

     `uvm_do_on_with(mac_tx_seqs[5][0],mac_tx_seqr_h[2],
                    {
                      min_payload_size == 25; max_payload_size == 44; vlan_q.size == temp_vlan_q[5].size; foreach(temp_vlan_q[5][i]) { vlan_q[i] == temp_vlan_q[5][i]; no_of_packet == 1;}
                    })
    join
 */
	endtask : body
	
endclass : mac_to_axi_s_payload_seqs	

class mac_to_axi_s_payload_test extends mac_to_axi_s_base_test;
    
	mac_to_axi_s_payload_seqs payload_seqs;
  
  mac_to_axi_s_base_virtual_seqs mac_vseqs; 
  mac_to_axi_s_virtual_seqr mac_vseqr;

  `uvm_component_utils_begin(mac_to_axi_s_payload_test)
	`uvm_component_utils_end
  
  function new(string name="mac_to_axi_s_payload_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new
 
  function void build_phase(uvm_phase phase);
		super.build_phase(phase);
    payload_seqs = mac_to_axi_s_payload_seqs::type_id::create("payload_seqs");
  endfunction : build_phase
 
  task run_phase(uvm_phase phase);
   	//super.run_phase(phase);
	
    phase.raise_objection(this);
		payload_seqs.start(env_h.vseqr_h);
		#50us;
		phase.drop_objection(this);
  endtask : run_phase 
  
endclass : mac_to_axi_s_payload_test

`endif 
