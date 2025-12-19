/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = mac_tx_to_rx_port_id_check_vseqs.svh
//  ENGINEER  = Muskan Thakur
//  VERSION   = 1.0 
//  DESCRIPTION = This file contains the base virtual seqs which will be responsible to start the sequence  
//
/////////////////////////////////////////////////////

`ifndef MAC_TX_TO_RX_PORT_ID_CHECK_VSEQS
`define MAC_TX_TO_RX_PORT_ID_CHECK_VSEQS

class mac_tx_to_rx_port_id_check_vseqs extends mac_to_axi_s_base_virtual_seqs;

  `uvm_object_utils(mac_tx_to_rx_port_id_check_vseqs)

   function new(string name = "mac_tx_to_rx_port_id_check_vseqs");
      super.new(name,.no_of_seqs(3));
   endfunction

////-----------------------------------------------------------------////
////-----------------------------------------------------------------////
////                       BODY
////-----------------------------------------------------------------////
////-----------------------------------------------------------------////
   
   task body();
     
     mac_tx_seqr_h[0].set_arbitration(SEQ_ARB_STRICT_FIFO);
     mac_tx_seqr_h[1].set_arbitration(SEQ_ARB_STRICT_FIFO);
     mac_tx_seqr_h[2].set_arbitration(SEQ_ARB_STRICT_FIFO);

   ////-----------------------------------------------------------------////
   ////               RAL SEQS 
   ////-----------------------------------------------------------------////
     
         configure_connection(.in_port_no(0),.no_of_configurations(5),.collect_data(1),.range_of_vlan(1),.range_of_conn_id(1) );  // configuring 5 connection at 1st port
         configure_connection(.in_port_no(0),.no_of_configurations(5),.collect_data(1),.range_of_vlan(0),.range_of_conn_id(2) );  // configuring 5 connection at 1st port
         configure_connection(.in_port_no(0),.no_of_configurations(5),.collect_data(1),.range_of_vlan(2),.range_of_conn_id(0) );  // configuring 5 connection at 1st port
         
         configure_connection(.in_port_no(1),.no_of_configurations(5),.collect_data(1),.range_of_vlan(1),.range_of_conn_id(1) );  // configuring 5 connection at 2st port
         configure_connection(.in_port_no(1),.no_of_configurations(5),.collect_data(1),.range_of_vlan(0),.range_of_conn_id(2) );  // configuring 5 connection at 2st port
         configure_connection(.in_port_no(1),.no_of_configurations(5),.collect_data(1),.range_of_vlan(2),.range_of_conn_id(0) );  // configuring 5 connection at 2st port
         
         configure_connection(.in_port_no(2),.no_of_configurations(5),.collect_data(1),.range_of_vlan(1),.range_of_conn_id(1) );  // configuring 5 connection at 3st port
         configure_connection(.in_port_no(2),.no_of_configurations(5),.collect_data(1),.range_of_vlan(0),.range_of_conn_id(2) );  // configuring 5 connection at 3st port
         configure_connection(.in_port_no(2),.no_of_configurations(5),.collect_data(1),.range_of_vlan(2),.range_of_conn_id(0) );  // configuring 5 connection at 3st port
   
   ////-----------------------------------------------------------------////
   ////               MAC SEQS 
   ////-----------------------------------------------------------------////
      
      fork   //// Valid port_ids 
            
            //// PORT 1  
            `uvm_do_on_with( mac_tx_seqs[0][0], mac_tx_seqr_h[0], { no_of_packet== 15; min_payload_size == 90; max_payload_size == 100;vlan_q.size == temp_vlan_q[0].size; foreach(temp_vlan_q[0][i]) { vlan_q[i] == temp_vlan_q[0][i];}} )
            `uvm_do_on_with( mac_tx_seqs[0][1], mac_tx_seqr_h[0], { no_of_packet== 15; min_payload_size == 90; max_payload_size == 100;vlan_q.size == temp_vlan_q[1].size; foreach(temp_vlan_q[1][i]) { vlan_q[i] == temp_vlan_q[1][i];}} )
            `uvm_do_on_with( mac_tx_seqs[0][2], mac_tx_seqr_h[0], { no_of_packet== 15; min_payload_size == 90; max_payload_size == 100;vlan_q.size == temp_vlan_q[2].size; foreach(temp_vlan_q[2][i]) { vlan_q[i] == temp_vlan_q[2][i];}} )
            
            //// PORT 2
            `uvm_do_on_with( mac_tx_seqs[1][0], mac_tx_seqr_h[1], {no_of_packet== 15; min_payload_size == 46; max_payload_size == 50;vlan_q.size == temp_vlan_q[0].size; foreach(temp_vlan_q[0][i]) { vlan_q[i] == temp_vlan_q[0][i];}} )
            `uvm_do_on_with( mac_tx_seqs[1][1], mac_tx_seqr_h[1], {no_of_packet== 15; min_payload_size == 46; max_payload_size == 50;vlan_q.size == temp_vlan_q[1].size; foreach(temp_vlan_q[1][i]) { vlan_q[i] == temp_vlan_q[1][i];}} )
            `uvm_do_on_with( mac_tx_seqs[1][2], mac_tx_seqr_h[1], {no_of_packet== 15; min_payload_size == 46; max_payload_size == 50;vlan_q.size == temp_vlan_q[2].size; foreach(temp_vlan_q[2][i]) { vlan_q[i] == temp_vlan_q[2][i];}} )
            
            //// PORT 3
            `uvm_do_on_with( mac_tx_seqs[2][0], mac_tx_seqr_h[2], {no_of_packet== 15; min_payload_size == 100; max_payload_size == 150; vlan_q.size == temp_vlan_q[0].size; foreach(temp_vlan_q[0][i]) { vlan_q[i] == temp_vlan_q[0][i];}} )
            `uvm_do_on_with( mac_tx_seqs[2][1], mac_tx_seqr_h[2], {no_of_packet== 15; min_payload_size == 100; max_payload_size == 150;vlan_q.size == temp_vlan_q[1].size; foreach(temp_vlan_q[1][i]) { vlan_q[i] == temp_vlan_q[1][i];}} )
            `uvm_do_on_with( mac_tx_seqs[2][2], mac_tx_seqr_h[2], {no_of_packet== 15; min_payload_size == 100; max_payload_size == 150;vlan_q.size == temp_vlan_q[2].size; foreach(temp_vlan_q[2][i]) { vlan_q[i] == temp_vlan_q[2][i];}} )
            
      join
      
  /* 
   ////-----------------------------------------------------------------////
   ////               RAL SEQS (configuring invalid port_ids)
   ////-----------------------------------------------------------------////
    
         configure_connection(.in_port_no(1),.no_of_configurations(5),.collect_data(1),.range_of_vlan(0),.range_of_conn_id(0) );  // configuring 5 connection at 1st port
         configure_connection(.in_port_no(2),.no_of_configurations(5),.collect_data(1),.range_of_vlan(1),.range_of_conn_id(1) );  // configuring 5 connection at 2st port
         configure_connection(.in_port_no(3),.no_of_configurations(5),.collect_data(1),.range_of_vlan(2),.range_of_conn_id(2) );  // configuring 5 connection at 3st port
   
   ////-----------------------------------------------------------------////
   ////               MAC SEQS 
   ////-----------------------------------------------------------------////
      
      fork   //// Valid port_ids 
            
            //// PORT 1  
            `uvm_do_on_with( mac_tx_seqs[3][0], mac_tx_seqr_h[0], {no_of_packet== 15; min_payload_size == 90; max_payload_size == 100;vlan_q.size == temp_vlan_q[3].size; foreach(temp_vlan_q[3][i]) { vlan_q[i] == temp_vlan_q[3][i];}} )
            `uvm_do_on_with( mac_tx_seqs[3][1], mac_tx_seqr_h[0], {no_of_packet== 15; min_payload_size == 90; max_payload_size == 100;vlan_q.size == temp_vlan_q[4].size; foreach(temp_vlan_q[4][i]) { vlan_q[i] == temp_vlan_q[4][i];}} )
            `uvm_do_on_with( mac_tx_seqs[3][2], mac_tx_seqr_h[0], {no_of_packet== 15; min_payload_size == 90; max_payload_size == 100;vlan_q.size == temp_vlan_q[5].size; foreach(temp_vlan_q[5][i]) { vlan_q[i] == temp_vlan_q[5][i];}} )
            
            //// PORT 2
            `uvm_do_on_with( mac_tx_seqs[4][0], mac_tx_seqr_h[1], {no_of_packet== 15; min_payload_size == 46; max_payload_size == 50;vlan_q.size == temp_vlan_q[3].size; foreach(temp_vlan_q[3][i]) { vlan_q[i] == temp_vlan_q[3][i];}} )
            `uvm_do_on_with( mac_tx_seqs[4][1], mac_tx_seqr_h[1], {no_of_packet== 15; min_payload_size == 46; max_payload_size == 50;vlan_q.size == temp_vlan_q[4].size; foreach(temp_vlan_q[4][i]) { vlan_q[i] == temp_vlan_q[4][i];}} )
            `uvm_do_on_with( mac_tx_seqs[4][2], mac_tx_seqr_h[1], {no_of_packet== 15; min_payload_size == 46; max_payload_size == 50;vlan_q.size == temp_vlan_q[5].size; foreach(temp_vlan_q[5][i]) { vlan_q[i] == temp_vlan_q[5][i];}} )
            
            //// PORT 3
            `uvm_do_on_with( mac_tx_seqs[5][0], mac_tx_seqr_h[2], {no_of_packet== 5; min_payload_size == 100; max_payload_size == 150; vlan_q.size == temp_vlan_q[3].size; foreach(temp_vlan_q[3][i]) { vlan_q[i] == temp_vlan_q[3][i];}} )
            `uvm_do_on_with( mac_tx_seqs[5][1], mac_tx_seqr_h[2], {no_of_packet== 5; min_payload_size == 100; max_payload_size == 150;vlan_q.size == temp_vlan_q[4].size; foreach(temp_vlan_q[4][i]) { vlan_q[i] == temp_vlan_q[4][i];}} )
            `uvm_do_on_with( mac_tx_seqs[5][2], mac_tx_seqr_h[2], {no_of_packet== 5; min_payload_size == 100; max_payload_size == 150;vlan_q.size == temp_vlan_q[5].size; foreach(temp_vlan_q[5][i]) { vlan_q[i] == temp_vlan_q[5][i];}} )
            
      join
   */   
 endtask

endclass 
////-----------------------------------------------------------------------------////
////                         TEST 
////-----------------------------------------------------------------------------////
class mac_tx_to_rx_port_id_test extends mac_to_axi_s_base_test; 
 
  `uvm_component_utils(mac_tx_to_rx_port_id_test) 
   
   mac_tx_to_rx_port_id_check_vseqs mac_port_id_vseqs;
   
   function new (string name="axi_str_mas_base_test", uvm_component parent=null); 
      super.new(name,parent); 
   endfunction: new 
                   
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////
////                      RUN PHASE
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////

	task run_phase(uvm_phase phase);
    super.run_phase(phase);
		phase.raise_objection(this);
           
           mac_port_id_vseqs = mac_tx_to_rx_port_id_check_vseqs::type_id::create("mac_port_id_vseqs");
	       mac_port_id_vseqs.start(env_h.vseqr_h);

		phase.drop_objection(this);
	endtask
    
endclass : mac_tx_to_rx_port_id_test

`endif

