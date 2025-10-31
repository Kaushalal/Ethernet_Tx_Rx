`ifndef EMAC_TX2RX_SANITY_TEST_SV
`define EMAC_TX2RX_SANITY_TEST_SV

class emac_tx2rx_sanity_vseqs extends emac_tx2rx_base_vseqs;
	
	emac_tx_seqs tx_seqs[];
	reg_cfg_seqs cfg_seqs;

	`uvm_object_utils_begin(emac_tx2rx_sanity_vseqs)
	`uvm_object_utils_end

	function new(string name = "emac_tx2rx_sanity_vseqs");
		super.new(name);
	endfunction : new

	task body();
		super.body();
		tx_seqs = new[3];
		`uvm_create(tx_seqs[0]);
		`uvm_create(tx_seqs[1]);
		`uvm_create(tx_seqs[2]);
		`uvm_create(cfg_seqs);		
		if(!tx_seqs[0].randomize() with {minn == 104;maxx == 105;vlan_idd == 'h123;})
			`uvm_error(get_full_name(),"Randomization Failed!!")
		if(!tx_seqs[1].randomize() with {minn == 104;maxx == 105;vlan_idd == 'h456;})
			`uvm_error(get_full_name(),"Randomization Failed!!")
		if(!tx_seqs[2].randomize() with {minn == 104;maxx == 105;vlan_idd == 'h789;})
			`uvm_error(get_full_name(),"Randomization Failed!!")
		if(!cfg_seqs.randomize())
			`uvm_error(get_full_name(),"Randomization Failed!!")
		cfg_seqs.start(null);
  		fork
			tx_seqs[0].start(p_sequencer.tx_seqr[0]);
  			tx_seqs[1].start(p_sequencer.tx_seqr[1]);
  			tx_seqs[2].start(p_sequencer.tx_seqr[2]);
		join
	endtask : body
	
endclass : emac_tx2rx_sanity_vseqs	

class emac_tx2rx_sanity_test extends emac_tx2rx_base_test;
    
	emac_tx2rx_sanity_vseqs sanity_vseqs;

  	`uvm_component_utils_begin(emac_tx2rx_sanity_test)
	`uvm_component_utils_end
  
  	function new(string name="emac_tx2rx_sanity_test",uvm_component parent=null);
    		super.new(name,parent);
  	endfunction : new
  
  	task run_phase(uvm_phase phase);
    	super.run_phase(phase);
		phase.raise_objection(this);
		sanity_vseqs = emac_tx2rx_sanity_vseqs::type_id::create("sanity_vseqs");
		sanity_vseqs.start(env.vseqr);
		phase.drop_objection(this);
  	endtask : run_phase 
  
endclass : emac_tx2rx_sanity_test

`endif 
