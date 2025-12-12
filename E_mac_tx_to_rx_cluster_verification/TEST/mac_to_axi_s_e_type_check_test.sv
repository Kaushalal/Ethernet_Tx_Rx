/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : mac_to_axi_s_e_type_check_test.sv

* Purpose : build and run sequence

* Creation Date : 

* Last Modified :

* Created By : Kaksh Ghelani

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef MAC_TO_AXI_S_E_TYPE_CHECK_TEST_SV
`define MAC_TO_AXI_S_E_TYPE_CHECK_TEST_SV

class mac_to_axi_s_e_type_check_test extends mac_to_axi_s_base_test; 
   
   mac_to_axi_s_e_type_check_vseqs mac_vseqs; 
   mac_to_axi_s_virtual_seqr mac_vseqr;
   
   `uvm_component_utils(mac_to_axi_s_e_type_check_test) 
   
   function new (string name="mac_to_axi_s_e_type_check_test", uvm_component parent=null); 
      super.new(name,parent); 
   endfunction:new 

                  
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
           mac_vseqs = mac_to_axi_s_e_type_check_vseqs::type_id::create("mac_vseqs");
   endfunction : build_phase
	
    task run_phase(uvm_phase phase);
		phase.raise_objection(this);
         if(!mac_vseqs.randomize() with {no_pkt[0] == 40; no_pkt[1] == 1; no_pkt[2] == 1;}) `uvm_error(get_full_name(), "e_type_check vseqs is not reandozmie")
	       mac_vseqs.start(env_h.vseqr_h);
           #20000;
		phase.drop_objection(this);
	endtask

endclass : mac_to_axi_s_e_type_check_test

`endif


