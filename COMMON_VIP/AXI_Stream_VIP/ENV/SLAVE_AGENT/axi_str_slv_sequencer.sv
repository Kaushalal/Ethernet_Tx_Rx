/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_slv_sequencer.sv

* Purpose : data transfer between sequence and driver (BFM) 

* Creation Date : 08-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_SLV_SEQUENCER_SV
`define AXI_STR_SLV_SEQUENCER_SV

class axi_str_slv_sequencer #(shortint DATA_SIZE=32,int USER_SIZE=32) extends uvm_sequencer #(axi_str_slv_seq_item #(DATA_SIZE,USER_SIZE)); 
 
  `uvm_component_param_utils(axi_str_slv_sequencer #(DATA_SIZE,USER_SIZE)) 
   
    //-------------------------------------------------------------------------------- 
     // Method : 
      
       // Arguments : 
        
         // Description : 
          
           //--------------------------------------------------------------------------------- 
   function new (string name="axi_str_slv_sequencer", uvm_component parent=null); 
      super.new(name,parent); 
   endfunction: new 
                   
endclass : axi_str_slv_sequencer

`endif
