/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = mac_tx_to_rx_sanity_vseqs.svh
//  ENGINEER  = Muskan Thakur
//  VERSION   = 1.0 
//  DESCRIPTION =  
//
/////////////////////////////////////////////////////

`ifndef MAC_TX_TO_RX_SANITY_VSEQS
`define MAC_TX_TO_RX_SANITY_VSEQS

class mac_tx_to_rx_sanity_vseqs extends mac_to_axi_s_base_virtual_seqs;

  `uvm_object_utils(mac_tx_to_rx_sanity_vseqs)

     task body();
   begin

   ////-----------------------------------------------------------------////
   ////               RAL SEQS 
   ////-----------------------------------------------------------------////
     
        /*repeat( 15 ) begin 
            void'(conn_cfg_seqs.randomize with { port_id inside {3,4,5} ; connection_valid == 1'b1 ; out_port_sel inside {8,9,10} ; crc_val == 32'h01020304 ; });
                conn_cfg_seqs.start(null);
            collect_vlan_id( conn_cfg_seqs.port_id, conn_cfg_seqs.vlan );
         end */

         configure_connection(1,0,1,5);
         configure_connection(2,1,1,5);
         configure_connection(3,2,1,5);
   
   ////-----------------------------------------------------------------////
   ////               MAC SEQS 
   ////-----------------------------------------------------------------////
      
      fork 
          begin 
            `uvm_do_on_with( mac_tx_seqs[3][0], mac_tx_seqr_h[0], {no_of_packet== 5; min_payload_size == 10; max_payload_size == 15;vlan_q.size == temp_vlan_q[3].size; foreach(temp_vlan_q[3][i]) { vlan_q[i] == temp_vlan_q[3][i];}} )
          end
          begin
            `uvm_do_on_with( mac_tx_seqs[4][0], mac_tx_seqr_h[1], {no_of_packet== 5; min_payload_size == 46; max_payload_size == 50;vlan_q.size == temp_vlan_q[4].size; foreach(temp_vlan_q[4][i]) { vlan_q[i] == temp_vlan_q[4][i];}} )
          end
          begin
            `uvm_do_on_with( mac_tx_seqs[5][0], mac_tx_seqr_h[2], {no_of_packet== 5; min_payload_size == 48; max_payload_size == 50; vlan_q.size == temp_vlan_q[5].size; foreach(temp_vlan_q[5][i]) { vlan_q[i] == temp_vlan_q[5][i];}} )
          end 
      join
   
      end
      
 endtask

endclass
////-----------------------------------------------------------------------------////
////                         TEST 
////-----------------------------------------------------------------------------////
class mac_to_axi_s_sanity_test extends mac_to_axi_s_base_test; 
 
  `uvm_component_utils(mac_to_axi_s_sanity_test) 
   
   mac_tx_to_rx_sanity_vseqs mac_sanity_vseqs;
   
   function new (string name="axi_str_mas_base_test", uvm_component parent=null); 
      super.new(name,parent); 
   endfunction: new 
                   
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////
////                      RUN PHASE
////----------------------------------------------------------------------/////
////----------------------------------------------------------------------/////

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
           //// Base virtual seqs 
           mac_sanity_vseqs = mac_tx_to_rx_sanity_vseqs::type_id::create("mac_sanity_vseqs");
	       mac_sanity_vseqs.start(env_h.vseqr_h);

           #2000;
		phase.drop_objection(this);
	endtask
    
endclass : mac_to_axi_s_sanity_test

`endif

