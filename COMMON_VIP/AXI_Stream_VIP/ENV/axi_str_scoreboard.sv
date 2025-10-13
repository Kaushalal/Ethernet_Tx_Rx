/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_scoreboard.sv

* Purpose : checker

* Creation Date : 15-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_SCOREBOARD_SV
`define AXI_STR_SCOREBOARD_SV

`uvm_analysis_imp_decl (_c2n)
`uvm_analysis_imp_decl (_n2c)
`uvm_analysis_imp_decl (_cpu)
//`uvm_analysis_imp_decl(_c2n_mac)
//`uvm_analysis_imp_decl(_n2c_mac)
class axi_str_scoreboard extends uvm_scoreboard; 
 
  `uvm_component_utils(axi_str_scoreboard) 

   uvm_analysis_imp_c2n #(c2n_mac_lyr_seq_item,axi_str_scoreboard) c2n_mac_imp;
   uvm_analysis_imp_n2c #(n2c_mac_lyr_seq_item,axi_str_scoreboard) n2c_mac_imp;
   uvm_analysis_imp_cpu #(cpu_mac_lyr_seq_item,axi_str_scoreboard) cpu_mac_imp;
    //-------------------------------------------------------------------------------- 
     // Method : 
      
       // Arguments : 
        
         // Description : 
          
           //--------------------------------------------------------------------------------- 
   function new (string name="axi_str_scoreboard", uvm_component parent=null); 
      super.new(name,parent); 
      c2n_mac_imp = new("c2n_mac_imp",this);
      n2c_mac_imp = new("n2c_mac_imp",this);
      cpu_mac_imp = new("cpu_mac_imp",this);
   endfunction: new 

   function void write_c2n(c2n_mac_lyr_seq_item c2n_pkt_sample);
      `uvm_info("axi_scoreboard",$sformatf("c2n trans sample in scoreboard : %0s",c2n_pkt_sample.sprint()),UVM_HIGH) 
   endfunction : write_c2n

   function void write_n2c(n2c_mac_lyr_seq_item n2c_pkt_sample);
      `uvm_info("axi_scoreboard",$sformatf("n2c trans samplpe in scoreboard : %0s",n2c_pkt_sample.sprint()),UVM_HIGH)
   endfunction : write_n2c
   
   function void write_cpu(cpu_mac_lyr_seq_item cpu_pkt_sample);
      `uvm_info("axi_scoreboard",$sformatf("cpu trans samplpe in scoreboard : %0s",cpu_pkt_sample.sprint()),UVM_HIGH)
   endfunction : write_cpu
endclass : axi_str_scoreboard

  `endif
