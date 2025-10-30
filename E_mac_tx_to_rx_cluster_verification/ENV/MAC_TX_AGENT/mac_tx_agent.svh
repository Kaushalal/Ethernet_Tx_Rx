/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = mac_tx_agent.svh
//  ENGINEER  = Muskan Thakur 
//  VERSION   = 1.0 
//  DESCRIPTION = this file is responsible to genereate stimulus   
//
/////////////////////////////////////////////////////

`ifndef MAC_TX_AGENT
`define MAC_TX_AGENT

class mac_tx_agent extends uvm_agent;

   `uvm_component_utils(mac_tx_agent)
   
   mac_tx_cfg mac_tx_cfg_h;
   // MAC components 
   mac_tx_seqr mac_tx_seqr_h;
   mac_tx_mon mac_tx_mon_h;

   // Conversion seqs 
   mac_to_axi_s_conv_seqs conv_seqs;

   // Parent handle of sequencer which will point to axi_master_seqr to start the conv_seqs  
   uvm_sequencer #(axi_str_mas_seq_item#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE))) axi_str_seqr_h;

   function new( string name = "mac_tx_agent", uvm_component parent = null);
   super.new(name,parent);
   endfunction 

   function void build_phase(uvm_phase phase);
      if(!uvm_config_db #(mac_tx_cfg)::get(this,"","tx_cfg",mac_tx_cfg_h))
        `uvm_warning(get_full_name(),"number of tx_agent : default value")
     if ( mac_tx_cfg_h.is_active == UVM_ACTIVE ) begin 
     mac_tx_seqr_h = mac_tx_seqr::type_id::create("mac_tx_seqr_h",this);
     end 
     mac_tx_mon_h = mac_tx_mon::type_id::create("mac_tx_mon_h",this);

   endfunction 

   task run_phase ( uvm_phase phase );
   super.run_phase(phase);

   if( mac_tx_cfg_h.is_active == UVM_ACTIVE ) begin 
   conv_seqs = mac_to_axi_s_conv_seqs::type_id::create("conv_seqs");
   conv_seqs.mac_tx_seqr_conv = this.mac_tx_seqr_h;    // seqr of coversion seqs will point to mac_seqr 
   conv_seqs.start(axi_str_seqr_h);                    // starting conv_seqs on axi_master_seqr ( which will be connected using connect_to_dut_agent method )
   end 

   endtask 

   function void connect_to_dut_agent(axi_str_mas_agent#(.DATA_SIZE(`AXI_STR_DATA_SIZE),.USER_SIZE(`AXI_STR_USER_SIZE)) axi_str_magent_h);

   this.axi_str_seqr_h = axi_str_magent_h.master_seqr;
   axi_str_magent_h.master_mon.item_collected_port.connect(this.mac_tx_mon_h.mac_tx_mon_imp);

   endfunction

endclass

`endif
