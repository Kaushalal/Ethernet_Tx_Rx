/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = emac_tx_to_rx_coverage.svh
//  CREATED_BY  = Muskan
//  MODIFIED_BY  =
//  VERSION   = 1.0 
//  DESCRIPTION =  
//
/////////////////////////////////////////////////////

`ifndef EMAC_TX_TO_RX_COVERAGE
`define EMAC_TX_TO_RX_COVERAGE

class emac_tx_to_rx_coverage extends uvm_object;  

   `uvm_object_utils(emac_tx_to_rx_coverage)

   covergroup emac_tx_to_rx_cvg with function sample (  );

   endgroup  
   
   function new (string name = "axi_cvg");
      super.new(name);
      emac_tx_to_rx_cvg = new();
   endfunction
 
endclass 

`endif
