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
//
/////////////////////////////////////////////////////

`ifndef EMAC_TX_TO_RX_COVERAGE
`define EMAC_TX_TO_RX_COVERAGE

class emac_tx_to_rx_coverage extends uvm_object;

  `uvm_object_utils(emac_tx_to_rx_coverage)

  covergroup emac_tx_to_rx_cvg with function sample ();
  endgroup

  covergroup payload_cg with function sample (int unsigned payload_sz, int unsigned portid);
    // payload size coverpoint
    cp_payload_size : coverpoint payload_sz {
      //bins below_min  = {[0:45]};
      bins min_exact  = {46};
      bins low_size   = {[47:63]};
      bins med_size   = {[64:511]};
      bins large_size = {[512:1023]};
      bins xlarge_size= {[1024:1499]};
      bins max_exact  = {1500};
      bins above_max  = {[1501:1600]}; // adjust high limit as needed
    }

    // port id coverpoint
    cp_port : coverpoint portid {
      bins p3 = {3};
      bins p4 = {4};
      bins p5 = {5};
    }

    // cross coverage
    cross_payload_port : cross cp_payload_size, cp_port;
  endgroup : payload_cg
  

  function new(string name = "axi_cvg");
    super.new(name);
    emac_tx_to_rx_cvg = new();
    payload_cg = new();
  endfunction

endclass

`endif


