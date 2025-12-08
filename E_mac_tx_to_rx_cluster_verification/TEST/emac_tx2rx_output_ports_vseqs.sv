/******************************************************************************************************************************************
 File Name   : emac_tx2rx_output_ports_vseqs.sv
 Author Name : Jyoti Vishwakarma
 Date        : Dec 1
 Description : These is seqs to test working of output port
 ****************************************************************************************************************************************/

`ifndef EMAC_TX2RX_OUTPUT_PORTS_VIRTUAL_SEQS
`define EMAC_TX2RX_OUTPUT_PORTS_VIRTUAL_SEQS

class emac_tx2rx_output_ports_vseqs extends emac_tx2rx_base_vseqs;

  `uvm_object_utils(emac_tx2rx_output_ports_vseqs)
  

   function new(string name = "emac_tx2rx_output_ports_vseqs");

      super.new(name);

      endfunction
  

  task body(); 
     begin       
           
     int i = 0, j = 0, k = 0;
     repeat(no_pkt[0]) begin 

         conn_cfg_seqs.randomize with { port_id == 3 ; connection_valid == 1'b1 ; connection_id == conn_id_q[0][i] ; vlan == vln_q[0][i]; 
	                                out_port_sel inside {8, 9, 10} ;          vcid_val      == vcid_q[0][i];
				       };conn_cfg_seqs.start(null);
				       i++;
         end
    
     repeat(no_pkt[1]) begin
         conn_cfg_seqs.randomize with { port_id == 4 ; connection_valid == 1'b1 ; connection_id == conn_id_q[1][j]  ; vlan == vln_q[1][j] ; 
	                                out_port_sel inside {8, 9, 10} ;          vcid_val      == vcid_q[1][j];
				       };conn_cfg_seqs.start(null);
				       j++;
         end
     repeat(no_pkt[2]) begin
         conn_cfg_seqs.randomize with { port_id == 5 ; connection_valid == 1'b1 ; connection_id == conn_id_q[2][k] ; vlan == vln_q[2][k]; 
	                                out_port_sel inside {8, 9, 10} ;          vcid_val      == vcid_q[2][k];
				       };conn_cfg_seqs.start(null);
				       k++;
         end


   
      
       fork 
           begin 
           `uvm_do_on_with( emac_tx_seqs[0], mac_tx_seqr_h[0],
	                    {no_of_packet== no_pkt[0];
			     min_payload_size == 10;
			     max_payload_size == 15;
			     vlan_q.size == no_pkt[0]; foreach(vlan_q[i]) vlan_q[i] == {vln_q[0][i]};} )
           end
           begin
           `uvm_do_on_with( emac_tx_seqs[1], mac_tx_seqr_h[1],
	                    {no_of_packet== no_pkt[1];
			     min_payload_size == 46;
			     max_payload_size == 50;
			     vlan_q.size == no_pkt[1]; foreach(vlan_q[i]) vlan_q[i] == vln_q[1][i];} )
           end
           begin
           `uvm_do_on_with( emac_tx_seqs[2], mac_tx_seqr_h[2],
	                    {no_of_packet== no_pkt[2];
			     min_payload_size == 48;
			     max_payload_size == 50; 
			     vlan_q.size == no_pkt[2]; foreach(vlan_q[i]) vlan_q[i] == vln_q[2][i];} )
           end 
       join
     //  wait_for_tlast(); 
       end
       
   endtask
/* 
   task wait_for_tlast();
   repeat(20) tlast_arrived.wait_trigger();
   endtask
*/
endclass

`endif

