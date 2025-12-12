/////////////////////////////////////////////////////////////
// File Name   : mac_to_aci_s_e_type_check_vseqs.sv
// Author Name : Kaksh Ghelani 
// Date        : Dec 5 
// Description : 
//
//////////////////////////////////////////////////////////////

`ifndef MAC_TO_AXI_S_E_TYPE_CHECK_VSEQS
`define MAC_TO_AXI_S_E_TYPE_CHECK_VSEQS

class mac_to_axi_s_e_type_check_vseqs extends emac_tx2rx_base_vseqs;

  `uvm_object_utils(mac_to_axi_s_e_type_check_vseqs)
  

   function new(string name = "mac_to_axi_s_e_type_check_vseqs");

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
        `uvm_do_on_with(emac_tx_seqs[0], mac_tx_seqr_h[0],
        {
            no_of_packet== no_pkt[0];
            min_payload_size==50;
            max_payload_size==70;
            vlan_q.size == no_pkt[0]; foreach(vlan_q[i]) vlan_q[i] == {vln_q[0][i]};
            temp_Etype inside {16'h0800, 16'h8100};   // VALID Etype
        })
    end

    begin
        
        `uvm_do_on_with(emac_tx_seqs[0], mac_tx_seqr_h[0],
        {
            no_of_packet== no_pkt[0];
            min_payload_size==50;
            max_payload_size==70;
            vlan_q.size == no_pkt[0]; foreach(vlan_q[i]) vlan_q[i] == {vln_q[0][i]};

            !(temp_Etype inside {16'h0800, 16'h8100}); // INVALID Etype
        })
    end

    begin
        
        `uvm_do_on_with(emac_tx_seqs[0], mac_tx_seqr_h[0],
        {
            no_of_packet== no_pkt[0];
            min_payload_size==50;
            max_payload_size==70;
            vlan_q.size == no_pkt[0]; foreach(vlan_q[i]) vlan_q[i] == {vln_q[0][i]};

            temp_Etype inside {16'h0800, 16'h8100};   // VALID Etype
        })
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

       end
       
   endtask

endclass: mac_to_axi_s_e_type_check_vseqs

`endif


