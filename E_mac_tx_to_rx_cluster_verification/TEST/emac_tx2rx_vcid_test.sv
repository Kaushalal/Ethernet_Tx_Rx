/******************************************************************************************************************************************
 File Name   : emac_tx2rx_vcid_vseqs.sv
 Author Name : Jyoti Vishwakarma
 Date        : Dec 9
 Description : These is seqs to test working of output port
 ****************************************************************************************************************************************/

`ifndef EMAC_TX2RX_VCID_VIRTUAL_SEQS
`define EMAC_TX2RX_VCID_VIRTUAL_SEQS

class emac_tx2rx_vcid_vseqs extends emac_tx2rx_base_vseqs;

  `uvm_object_utils(emac_tx2rx_vcid_vseqs)
  

   function new(string name = "emac_tx2rx_vcid_vseqs");

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
			     min_payload_size == min_pyld_size[0];
			     max_payload_size == max_pyld_size[0];
			     vlan_q.size == no_pkt[0]; foreach(vlan_q[i]) vlan_q[i] == {vln_q[0][i]};} )
           end
           begin
           `uvm_do_on_with( emac_tx_seqs[1], mac_tx_seqr_h[1],
	                    {no_of_packet== no_pkt[1];
			     min_payload_size == min_pyld_size[1];
			     max_payload_size == max_pyld_size[1];
			     vlan_q.size == no_pkt[1]; foreach(vlan_q[i]) vlan_q[i] == vln_q[1][i];} )
           end
           begin
           `uvm_do_on_with( emac_tx_seqs[2], mac_tx_seqr_h[2],
	                    {no_of_packet== no_pkt[2];
			     min_payload_size == min_pyld_size[2];
			     max_payload_size == max_pyld_size[2];
			     vlan_q.size == no_pkt[2]; foreach(vlan_q[i]) vlan_q[i] == vln_q[2][i];} )
           end 
       join
       end
       
   endtask
endclass

`endif


/*******************************************************************************************************************************************/
`ifndef EMAC_TX2RX_VCID_TEST
`define EMAC_TX2RX_VCID_TEST

class emac_tx2rx_vcid_test extends mac_to_axi_s_base_test; 
 
  `uvm_component_utils(emac_tx2rx_vcid_test) 
   
   emac_tx2rx_vcid_vseqs vcid_vseqs;
   
   function new (string name="emac_tx2rx_vcid_test", uvm_component parent=null); 

      super.new(name,parent); 
      vcid_vseqs = emac_tx2rx_vcid_vseqs::type_id::create("vcid_vseqs");
      endfunction: new 

   function void connect_phase(uvm_phase phase);

      super.connect_phase(phase);
      endfunction 
                  

   task run_phase(uvm_phase phase);

      phase.raise_objection(this);
     

      super.run_phase(phase);
      if(!vcid_vseqs.randomize() with {no_pkt[0] == 1; no_pkt[1] == 4; no_pkt[2] == 4;}) `uvm_error(get_full_name(), "vseqs is not reandozmie")
      vcid_vseqs.sprint();

      phase.raise_objection(null,"Raising objection for total num of packet",vcid_vseqs.total_num_packet);
      vcid_vseqs.start(env_h.vseqr_h);




      phase.drop_objection(this);
      endtask
      
   function void report_phase(uvm_phase  phase);
        
      vcid_vseqs.seqs_summary();

   endfunction
    
endclass : emac_tx2rx_vcid_test

`endif
