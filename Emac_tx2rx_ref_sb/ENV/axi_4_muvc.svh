/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = axi_4_muvc.svh
//  ENGINEER  = Muskan
//  VERSION   = 1.0 
//  DESCRIPTION = contains all macro 
//
/////////////////////////////////////////////////////

`ifndef AXI_4_MUVC
`define AXI_4_MUVC

class axi_4_muvc extends uvm_component;

   `uvm_component_utils(axi_4_muvc)

  axi_magent#(`AXI_4_DATA_SIZE,`AXI_4_ADD_SIZE) axi_4_magent_h[];
  axi_magt_cfg axi_4_mcfg_h[]; 
  
  axi_magt_cfg axi_4_mcfg_get; 
 

   function new (string name = "axi_muvc", uvm_component parent = null);
      super.new(name,parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
     
     if(!uvm_config_db #(axi_magt_cfg)::get(this,"", "mcfg_h", axi_4_mcfg_get))
       `uvm_fatal(get_name()," AXI_4 master config failed to get in uvc!!!")
       
       axi_4_magent_h = new[axi_4_mcfg_get.no_of_agent];   
       axi_4_mcfg_h = new[axi_4_mcfg_get.no_of_agent];   
     
       foreach(axi_4_magent_h[i]) begin
         axi_4_magent_h[i] = axi_magent #(32, 32) ::type_id::create($sformatf("axi_4_magent_h[%0d]",i),this);
         axi_4_mcfg_h[i] = axi_magt_cfg::type_id::create($sformatf("axi_4_mcfg_h[%0d]",i),this);
         axi_4_mcfg_h[i].magt_is_active = axi_4_mcfg_get.magt_is_active;
         axi_4_mcfg_h[i].id = i;
         
         uvm_config_db #(axi_magt_cfg)::set(this,$sformatf("*axi_4_magent_h[%0d]*",i), "mcfg_h", axi_4_mcfg_h[i]);

       end
       
   endfunction
   
endclass 

`endif

