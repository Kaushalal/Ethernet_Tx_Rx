/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_mas_sequencer.sv

* Purpose : data transfer between sequence and driver 

* Creation Date : 04-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_str_MAS_SEQUENCER_SV
`define AXI_str_MAS_SEQUENCER_SV

class axi_str_mas_sequencer #(shortint DATA_SIZE=32, int USER_SIZE=32) extends uvm_sequencer #(axi_str_mas_seq_item #(DATA_SIZE,USER_SIZE)); 
 
  `uvm_component_param_utils(axi_str_mas_sequencer #(DATA_SIZE,USER_SIZE)) 
   
    function new (string name="axi_str_mas_sequencer", uvm_component parent=null); 
       super.new(name,parent); 
    endfunction: new 
                   
 endclass : axi_str_mas_sequencer


`endif
