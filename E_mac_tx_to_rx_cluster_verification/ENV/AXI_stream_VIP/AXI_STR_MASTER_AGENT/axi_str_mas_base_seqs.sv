/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_mas_base_seqs.sv

* Purpose : give inputs according to testcase

* Creation Date : 06-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_MAS_BASE_SEQS_SV
`define AXI_STR_MAS_BASE_SEQS_SV

class axi_str_mas_base_seqs #(shortint DATA_SIZE=32,int USER_SIZE=32) extends uvm_sequence #(axi_str_mas_seq_item #(DATA_SIZE,USER_SIZE)); 
 
  `uvm_object_param_utils(axi_str_mas_base_seqs #(DATA_SIZE,USER_SIZE)) 
   
  //axi_str_mas_seq_item #(DATA_SIZE,USER_SIZE) req;
  
   function new (string name="axi_str_mas_base_seqs"); 
      super.new(name);
   endfunction: new 

   task body();
      //write transfer
      `uvm_do_with(req, {total_bytes == 18;});
      `uvm_do_with(req, {total_bytes == 33;});
      `uvm_do_with(req, {total_bytes == 66;})

      //#20;
   endtask : body

endclass : axi_str_mas_base_seqs

`endif
