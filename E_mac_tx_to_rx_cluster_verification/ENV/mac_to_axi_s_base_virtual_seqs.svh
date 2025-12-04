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

   mac_tx_base_seqs mac_tx_seqs[int][]; //// 1st index (ID) -> port_id  //// Associative arr -> in case u want to start multiple seqs on a single port ( ex- continous toggling between valid and invalid scenarios )
   mac_tx_seqr mac_tx_seqr_h[];
   reg_conn_cfg_seq conn_cfg_seqs;

   rand bit [11:0]  temp_vlan_q[int][$];  //// 1st index (ID) -> port_id
   rand bit [2:0]   temp_port_id;
                  
   rand bit         temp_connection_valid;
   rand bit [4:0]   temp_connection_id[$];
                  
   rand bit [3:0]   temp_out_port_sel;
   rand bit [31:0]  temp_crc_val;
                               
   rand bit [7:0]   temp_vcid_val[int][int];   //// 1st id -> port_id //// 2nd id -> connection_id ////

  
   function new(string name = "mac_to_axi_s_base_virtual_seqs", int no_of_seqs = 1, int no_of_ports = 3);
      super.new(name);
      mac_tx_seqs[0]   = new[no_of_seqs];
      mac_tx_seqs[1]   = new[no_of_seqs];
      mac_tx_seqs[2]   = new[no_of_seqs];
      mac_tx_seqr_h = new[no_of_ports];
      conn_cfg_seqs = new("conn_cfg_seqs");
   endfunction

////---------------------------------------------------------------------------------////
////              Function to collect vcid id 
////---------------------------------------------------------------------------------////
   virtual function void collect_vcid( int port_no, bit[4:0] conn_id, bit[7:0] vcid );
      temp_vcid_val[port_no][conn_id] = vcid;
   endfunction

////---------------------------------------------------------------------------------////
////              Function to collect vlan id 
////---------------------------------------------------------------------------------////
   virtual function void collect_vlan_id( int port_no, bit[11:0] vlan_id );
      temp_vlan_q[port_no].push_back(vlan_id);
   endfunction

////---------------------------------------------------------------------------------////
////              Function to collect connection id 
////---------------------------------------------------------------------------------////
   virtual function void collect_conn_id( bit[4:0] conn_id );
      temp_connection_id.push_back(conn_id);
   endfunction

////---------------------------------------------------------------------------------////
////---------------------------------------------------------------------------------////
////--------------- We can use this function to configure the connection ------------////
//// in_port_no -> use to select the input_port(0,1,2) ( by default 3 -> select any port ) || out_port_no -> used to select the output port(0,1,2) ( by defualt 3 -> select any port );
////  range ( input argument ) 0 -> min_range; 1 -> in_bet_range; 2 -> max_range; 3 -> completely random 
////---------------------------------------------------------------------------------////
////---------------------------------------------------------------------------------////

  virtual task configure_connection( int in_port_no = 3, int out_port_no = 3, bit conn_valid_bit= 1, int no_of_configurations = 1, bit collect_data = 1, bit[2:0] range_of_vlan=3, bit[2:0] range_of_conn_id=3 );

       int port_no[int];
     
       port_no[3] = 0;
       port_no[4] = 1;
       port_no[5] = 2;
         
         repeat( no_of_configurations ) begin 

            void'(conn_cfg_seqs.randomize with { 
            (in_port_no == 0)->(port_id == 3); 
            (in_port_no==1)->(port_id==4); 
            (in_port_no==2)->(port_id==5);
            port_id inside {3,4,5};
            connection_valid == conn_valid_bit ;
            (out_port_no==0)->(out_port_sel==8); 
            (out_port_no==1)->(out_port_sel==9);
            (out_port_no==2)->(out_port_sel==10); 
            out_port_sel inside {8,9,10}; 
            !(connection_id inside {temp_connection_id}) ; 
            !(vlan inside {temp_vlan_q});
            (range_of_vlan==0)->(vlan inside {[0:500]});
            (range_of_vlan==1)->(vlan inside {[1000:2000]});
            (range_of_vlan==2)->(vlan inside{[3095:4095]}); 
            (range_of_conn_id==0)->(connection_id inside {[0:10]});
            (range_of_conn_id==1)->(connection_id inside {[10:20]}); 
            (range_of_conn_id==2)->(connection_id inside {[20:31]});         });
            
            conn_cfg_seqs.start(null);
            
            if( collect_data == 1 ) begin 
            collect_vcid( port_no[conn_cfg_seqs.port_id],conn_cfg_seqs.connection_id, conn_cfg_seqs.vcid_val );
            collect_vlan_id( port_no[conn_cfg_seqs.port_id], conn_cfg_seqs.vlan );
            collect_conn_id( conn_cfg_seqs.connection_id );
            end 
            
            if( temp_connection_id.size == 32 )
                 temp_connection_id.delete();
         end 
   endtask

////-----------------------------------------------------------------////
////-----------------------------------------------------------------////
////                       PRE_START (psequencer imprementation)
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
     
         configure_connection(.in_port_no(),.no_of_configurations(15),.collect_data(),.range_of_vlan(0),.range_of_conn_id(2) );  // configuring 15 connections

         /*repeat( 15 ) begin 
            void'(conn_cfg_seqs.randomize with { port_id inside {3,4,5} ; connection_valid == 1'b1 ; out_port_sel inside {8,9,10} ; crc_val == 32'h01020304 ; });
                conn_cfg_seqs.start(null)   
            collect_vlan_id( port_no[conn_cfg_seqs.port_id], conn_cfg_seqs.vlan );
         end */
   
   ////-----------------------------------------------------------------////
   ////               MAC SEQS 
   ////-----------------------------------------------------------------////
      
      fork 
          begin 
            `uvm_do_on_with( mac_tx_seqs[0][0], mac_tx_seqr_h[0], {no_of_packet== 5; min_payload_size == 10; max_payload_size == 15;vlan_q.size == temp_vlan_q[0].size; foreach(temp_vlan_q[0][i]) { vlan_q[i] == temp_vlan_q[0][i];}} )
          end
          begin
            `uvm_do_on_with( mac_tx_seqs[1][0], mac_tx_seqr_h[1], {no_of_packet== 5; min_payload_size == 46; max_payload_size == 50;vlan_q.size == temp_vlan_q[1].size; foreach(temp_vlan_q[1][i]) { vlan_q[i] == temp_vlan_q[1][i];}} )
          end
          begin
            `uvm_do_on_with( mac_tx_seqs[2][0], mac_tx_seqr_h[2], {no_of_packet== 5; min_payload_size == 48; max_payload_size == 50; vlan_q.size == temp_vlan_q[2].size; foreach(temp_vlan_q[2][i]) { vlan_q[i] == temp_vlan_q[2][i];}} )
          end 
      join
   
      end
      
 endtask


 task post_body();
 foreach( temp_vlan_q[i] )
 `uvm_info("\n Configured VLAN_IDS",$sformatf(" vlan_q[%0d] = %p \n",i,temp_vlan_q[i]),UVM_LOW)

 foreach( temp_vcid_val[i,j] )
 `uvm_info("\nConfigured VCID_IDS",$sformatf(" vlan_q[PORT_NO : %0d][CONNECTION_ID : %0d] = %p \n",i,j,temp_vcid_val[i][j]),UVM_LOW)
 endtask 

 
endclass

`endif

