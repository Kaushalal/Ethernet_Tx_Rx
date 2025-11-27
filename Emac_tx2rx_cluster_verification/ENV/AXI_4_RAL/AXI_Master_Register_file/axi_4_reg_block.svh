/*------------------------------------------------------------------------
                          Name      : Jyoti Vishwakarma
                          File Name : axi_4_reg_block.sv
                          Date      : Oct 9
------------------------------------------------------------------------ */
`ifndef AXI_4_REG_BLOCK
`define AXI_4_REG_BLOCK

class axi_4_reg_block extends uvm_reg_block;

   `uvm_object_utils(axi_4_reg_block)

    //// All Registers  
	rand connection_config_reg       conn_cfg_reg_h[];
	rand output_port_reg                 output_prt_reg_h[];
	rand crc_reg                         crc_reg_h[];
	rand vcid_reg                         vcid_reg_h[];
	
    //// Maps
    uvm_reg_map                      vcid_reg_map;    //maps for vcid reg 
    uvm_reg_map                      cfg_mem_map;    //maps connection_config_mem
	uvm_reg_map                      misc_reg_map;   //maps output_port_reg and crc_reg

/*---------------------------------------------------------*/
/*--------------------- NEW FUNCTION ----------------------*/
/*---------------------------------------------------------*/

 	function new(string name = "axi_4_reg_block");
	 	 super.new(name ,build_coverage(UVM_NO_COVERAGE));
                 endfunction

/*---------------------------------------------------------*/
/*-------------------BUILD FUNCTION -----------------------*/
/*---------------------------------------------------------*/
     
     function void build();

         /*---------------------------------------------------------*/
         /*-------------------CONFIGURE REGISTER -------------------*/
         /*---------------------------------------------------------*/

          conn_cfg_reg_h = new[32768];
          foreach(conn_cfg_reg_h[i]) begin
      	  conn_cfg_reg_h[i] = connection_config_reg::type_id::create($sformatf("conn_cfg_reg_h[%0d]",i)); 
      	  conn_cfg_reg_h[i].configure(this);                            
      	  conn_cfg_reg_h[i].build();                                    
          end

          output_prt_reg_h = new[32];
		  foreach(output_prt_reg_h[i])begin
      	  output_prt_reg_h[i] = output_port_reg::type_id::create($sformatf("output_prt_reg_h[%0d]",i)); 
      	  output_prt_reg_h[i].configure(this);                            
      	  output_prt_reg_h[i].build();                                    
          end

          crc_reg_h = new[32];
          foreach(crc_reg_h[i]) begin 
      	  crc_reg_h[i] = crc_reg::type_id::create($sformatf("crc_reg_h[%0d]",i)); 
      	  crc_reg_h[i].configure(this);                            
      	  crc_reg_h[i].build(); 
          end 
          
          vcid_reg_h = new[32];
          foreach(vcid_reg_h[i]) begin 
      	  vcid_reg_h[i] = vcid_reg::type_id::create($sformatf("vcid_reg_h[%0d]",i)); 
      	  vcid_reg_h[i].configure(this);                            
      	  vcid_reg_h[i].build(); 
          end 
      
         /*-----------------------------------------------------*/
         /*-----------------------CREATE MAP -------------------*/
         /*-----------------------------------------------------*/

          vcid_reg_map   = create_map(  .name("vcid_reg_map"),         
        	                       .base_addr('h2900),	     
                                   .n_bytes(4),	  	      
        	                       .endian(UVM_LITTLE_ENDIAN),   
        	                       .byte_addressing(1)            
                                   );

          cfg_mem_map   = create_map(  .name("cfg_mem_map"),         
        	                       .base_addr('h4000),	    
                                   .n_bytes(4),	  	      
        	                       .endian(UVM_LITTLE_ENDIAN),   
        	                       .byte_addressing(1)            
                                   );		
        
          misc_reg_map  = create_map(  .name("misc_reg_map"),         
        	                       .base_addr('h3000),	     //0x3000; 
                                   .n_bytes(4),	  	      
        	                       .endian(UVM_LITTLE_ENDIAN),   
        	                       .byte_addressing(1)            
                                   );		

        /*-----------------------------------------------------*/
        /*-----------------------ADD_REG_TO_MAP ---------------*/
        /*-----------------------------------------------------*/

          foreach(conn_cfg_reg_h[i])begin
                  cfg_mem_map.add_reg( .rg(conn_cfg_reg_h[i]),           
                                       .offset(i),                    
                                       .rights("RW"),                    
                                       .unmapped(0),                  
                                       .frontdoor(null)                 
                                   );   
                  end
        
          foreach(output_prt_reg_h[i])begin
                  misc_reg_map.add_reg(.rg(output_prt_reg_h[i]),
                                       .offset(i),
                                       .rights("RW")
                                   );  
                  end
        
          foreach(vcid_reg_h[i])begin
                  vcid_reg_map.add_reg(.rg(vcid_reg_h[i]),
                                       .offset(i),
                                       .rights("RW")
                                   );  
                  end

          foreach(crc_reg_h[i])begin
                  misc_reg_map.add_reg(.rg(crc_reg_h[i]),
                                       .offset('h30+i),
                                       .rights("RW")
                                   );   
                end
        
           lock_model(); //lock register model for protect.
		
	endfunction
			
endclass
`endif
