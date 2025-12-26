/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = axi_4_suvc.svh
//  ENGINEER  = Muskan
//  VERSION   = 1.0 
//  DESCRIPTION = contains all macro 
//
/////////////////////////////////////////////////////

`ifndef AXI_4_SUVC
`define AXI_4_SUVC

class axi_4_suvc extends uvm_component;

   `uvm_component_utils(axi_4_suvc)

  axi_sagent#(`AXI_4_DATA_SIZE,`AXI_4_ADD_SIZE) axi_4_sagent_h[];
  axi_sagt_cfg axi_4_scfg_h[]; 
  
  axi_sagt_cfg axi_4_scfg_get; 
 

   function new (string name = "axi_muvc", uvm_component parent = null);
      super.new(name,parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
     
     if(!uvm_config_db #(axi_sagt_cfg)::get(this,"", "scfg_h", axi_4_scfg_get))
       `uvm_fatal(get_name()," AXI_4 slave config failed to get in uvc!!!")
       
       axi_4_sagent_h = new[axi_4_scfg_get.no_of_agent];   
       axi_4_scfg_h = new[axi_4_scfg_get.no_of_agent];   
     
       foreach(axi_4_sagent_h[i]) begin
         axi_4_sagent_h[i] = axi_sagent #(32, 32) ::type_id::create($sformatf("axi_4_sagent_h[%0d]",i),this);
         axi_4_scfg_h[i] = axi_sagt_cfg::type_id::create($sformatf("axi_4_scfg_h[%0d]",i),this);
         axi_4_scfg_h[i].sagt_is_active = axi_4_scfg_get.sagt_is_active;
         axi_4_scfg_h[i].id = i;
         
         uvm_config_db #(axi_sagt_cfg)::set(this,$sformatf("*axi_4_sagent_h[%0d]*",i), "scfg_h", axi_4_scfg_h[i]);

       end
       
   endfunction
   
endclass 

`endif

