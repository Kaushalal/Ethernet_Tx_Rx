/******************************************************************************************************************************************
 File Name   : emac_tx2rx_vcid_test.sv
 Author Name : Jyoti Vishwakarma
 Date        : Dec 1
 Description : These is seqs to test working of output port
 ****************************************************************************************************************************************/

`ifndef EMAC_TX2RX_OUTPUT_PORTS_TEST
`define EMAC_TX2RX_OUTPUT_PORTS_TEST

class emac_tx2rx_output_ports_test extends mac_to_axi_s_base_test; 
 
  `uvm_component_utils(emac_tx2rx_output_ports_test) 
   
   emac_tx2rx_output_ports_vseqs output_prt_vseqs;
   
   function new (string name="emac_tx2rx_output_ports_test", uvm_component parent=null); 

      super.new(name,parent); 
      output_prt_vseqs = emac_tx2rx_output_ports_vseqs::type_id::create("output_prt_vseqs");
      endfunction: new 

   function void connect_phase(uvm_phase phase);

      super.connect_phase(phase);
      endfunction 
                  

   task run_phase(uvm_phase phase);

      phase.raise_objection(this);
     

      if(!output_prt_vseqs.randomize() with {no_pkt[0] == 5; no_pkt[1] == 14; no_pkt[2] == 40;}) `uvm_error(get_full_name(), "vseqs is not reandozmie")
      output_prt_vseqs.sprint();

      output_prt_vseqs.start(env_h.vseqr_h);


      #10000;

      phase.drop_objection(this);
      endtask
      
   function void report_phase(uvm_phase  phase);
    
      output_prt_vseqs.seqs_summary();


   endfunction
    
endclass : emac_tx2rx_output_ports_test

`endif
