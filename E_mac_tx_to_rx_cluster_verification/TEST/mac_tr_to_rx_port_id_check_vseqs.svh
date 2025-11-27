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
      super.new(name);
   endfunction


////-----------------------------------------------------------------////
////-----------------------------------------------------------------////
////                       BODY
////-----------------------------------------------------------------////
////-----------------------------------------------------------------////
   
   task body();
   begin

   ////-----------------------------------------------------------------////
   ////               RAL SEQS 
   ////-----------------------------------------------------------------////
     
         repeat( 20 ) begin 
            void'(conn_cfg_seqs.randomize with { port_id inside {3,4,5,8,9,10,0,1} ; connection_valid == 1'b1 ; out_port_sel inside {8,9,10} ; crc_val == 32'h01020304 ; });
                conn_cfg_seqs.start(null);
            temp_vlan_q[conn_cfg_seqs.port_id].push_back(conn_cfg_seqs.vlan);
         end
   
   ////-----------------------------------------------------------------////
   ////               MAC SEQS 
   ////-----------------------------------------------------------------////
      
      fork 
          begin 
            `uvm_do_on_with( mac_tx_seqs[0], mac_tx_seqr_h[0], {no_of_packet== 5; min_payload_size == 10; max_payload_size == 15;vlan_q.size == temp_vlan_q[3].size; foreach(temp_vlan_q[3][i]) { vlan_q[i] == temp_vlan_q[4][i];}} )
          end
          begin
            `uvm_do_on_with( mac_tx_seqs[1], mac_tx_seqr_h[1], {no_of_packet== 5; min_payload_size == 46; max_payload_size == 50;vlan_q.size == temp_vlan_q[4].size; foreach(temp_vlan_q[4][i]) { vlan_q[i] == temp_vlan_q[5][i];}} )
          end
          begin
            `uvm_do_on_with( mac_tx_seqs[2], mac_tx_seqr_h[2], {no_of_packet== 5; min_payload_size == 48; max_payload_size == 50; vlan_q.size == temp_vlan_q[5].size; foreach(temp_vlan_q[5][i]) { vlan_q[i] == temp_vlan_q[3][i];}} )
          end 
      join
   
      end
      
 endtask

endclass 

`endif

