/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = mac_to_axi_s_base_virtual_seqs.svh
//  ENGINEER  = Muskan Thakur
//  VERSION   = 1.0 
//  DESCRIPTION = This file contains the base virtual seqs which will be responsible to start the sequence  
//
/////////////////////////////////////////////////////

`ifndef MAC_TO_AXI_S_BASE_VIRTUAL_SEQS
`define MAC_TO_AXI_S_BASE_VIRTUAL_SEQS

class mac_to_axi_s_base_virtual_seqs extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(mac_to_axi_s_base_virtual_seqs)
  
  `uvm_declare_p_sequencer(mac_to_axi_s_virtual_seqr)

   mac_tx_base_seqs mac_tx_seqs[];
   mac_tx_seqr mac_tx_seqr_h[];

   rand bit [11:0]  temp_vlan_q[$];
   rand bit [2:0]   temp_port_id;
                  
   rand bit         temp_connection_valid;
   rand bit [4:0]   temp_connection_id;
                  
   rand bit [3:0]   temp_out_port_sel;
   rand bit [31:0]  temp_crc_val;
   rand bit [7:0]   temp_vcid_val;

   reg_conn_cfg_seq conn_cfg_seqs;
  
   function new(string name = "mac_to_axi_s_base_virtual_seqs", int no_of_ports = 3);
      super.new(name);
      mac_tx_seqs   = new[no_of_ports];
      mac_tx_seqr_h = new[no_of_ports];
      conn_cfg_seqs = new("conn_cfg_seqs");
   endfunction

////-----------------------------------------------------------------////
////-----------------------------------------------------------------////
////                       PRE_START
////-----------------------------------------------------------------////
////-----------------------------------------------------------------////
   
   task pre_start();
   foreach( mac_tx_seqr_h[i] ) begin 
   mac_tx_seqr_h[i] = p_sequencer.mac_tx_seqr_h[i];
   end
   endtask 

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
     
         repeat( 10 ) begin 
            void'(conn_cfg_seqs.randomize with { port_id inside {3,4,5} ; connection_valid == 1'b1 ; out_port_sel inside {8,9,10} ; crc_val == 32'h01020304 ; });
                conn_cfg_seqs.start(null);
            temp_vlan_q.push_back(conn_cfg_seqs.vlan);
         end
   
   ////-----------------------------------------------------------------////
   ////               MAC SEQS 
   ////-----------------------------------------------------------------////
      
      fork 
          begin 
            `uvm_do_on_with( mac_tx_seqs[0], mac_tx_seqr_h[0], {no_of_packet== 50; min_payload_size == 10; max_payload_size == 15;vlan_q.size == temp_vlan_q.size; foreach(temp_vlan_q[i]) { vlan_q[i] == temp_vlan_q[i];}} )
          end
          begin
            `uvm_do_on_with( mac_tx_seqs[1], mac_tx_seqr_h[1], {no_of_packet== 50; min_payload_size == 46; max_payload_size == 50;vlan_q.size == temp_vlan_q.size; foreach(temp_vlan_q[i]) { vlan_q[i] == temp_vlan_q[i];}} )
          end
          begin
            `uvm_do_on_with( mac_tx_seqs[2], mac_tx_seqr_h[2], {no_of_packet== 50; min_payload_size == 48; max_payload_size == 50; vlan_q.size == temp_vlan_q.size; foreach(temp_vlan_q[i]) { vlan_q[i] == temp_vlan_q[i];}} )
          end
      join
   
      end
      
 endtask

 
endclass

`endif

