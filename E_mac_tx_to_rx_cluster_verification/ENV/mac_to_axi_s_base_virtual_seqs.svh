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
   
   function new(string name = "mac_to_axi_s_base_virtual_seqs");
      super.new(name);
      mac_tx_seqs = new[3];
      mac_tx_seqr_h = new[3];
   endfunction

   task pre_start();
   foreach( mac_tx_seqr_h[i] ) begin 
   mac_tx_seqr_h[i] = p_sequencer.mac_tx_seqr_h[i];
   end
   endtask 

   task body();
   fork 
   begin 
     //max_tx_seqs[0].randomize() with {no_of_packet== 10; min_payload_size == 100; max_payload_size == 250;}
     `uvm_do_on_with( mac_tx_seqs[0], mac_tx_seqr_h[0], {no_of_packet== 5; min_payload_size == 50; max_payload_size == 52;} )
     //max_tx_seqs[0].start(p_sequencer.mac_tx_seqr_h[0]);
   end
   begin
     `uvm_do_on_with( mac_tx_seqs[1], mac_tx_seqr_h[1], {no_of_packet== 5; min_payload_size == 46; max_payload_size == 50;} )
     //max_tx_seqs[1].randomize() with {no_of_packet== 10; min_payload_size == 150; max_payload_size == 400;}
     //max_tx_seqs[1].start(p_sequencer.mac_tx_seqr_h[1]);
   end
   begin
     `uvm_do_on_with( mac_tx_seqs[2], mac_tx_seqr_h[2], {no_of_packet== 5; min_payload_size == 48; max_payload_size == 50; da == 'h010203040506; sa == 'h0708090A0B0C ;} )

     //max_tx_seqs[2].randomize() with {no_of_packet== 10; min_payload_size == 150; max_payload_size == 400; da = 'h010203040506; sa = 'h0708090A0B0C} 
     //max_tx_seqs[2].start(p_sequencer.mac_tx_seqr_h[2]);  
   end
   join
   
   endtask

 
endclass

`endif

