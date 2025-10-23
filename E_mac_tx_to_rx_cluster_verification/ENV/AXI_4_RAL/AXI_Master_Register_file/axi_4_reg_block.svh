/*------------------------------------------------------------------------
                          Name      : Jyoti Vishwakarma
                          File Name : axi_4_reg_block.sv
                          Date      : Oct 9
------------------------------------------------------------------------ */
`ifndef AXI_4_REG_BLOCK
`define AXI_4_REG_BLOCK

class axi_4_reg_block extends uvm_reg_block;

   `uvm_object_utils(axi_4_reg_block)

	rand connection_config_mem       cnn_cfg_mem_h[];
	rand output_port                 output_prt_h[];
	rand crc                         crc_h;

 	function new(string name = "reg_block");
	 	 super.new(name ,build_coverage(UVM_NO_COVERAGE));
                 endfunction

        function void build();

                        cnn_cfg_mem_h = new[96];
                        foreach(cnn_cfg_mem_h[i]) begin
      			cnn_cfg_mem_h[i] = connection_config_mem::type_id::create($sformatf("cnn_cfg_mem_h[%0d]",i)); 
      			cnn_cfg_mem_h[i].configure(this);                            
      			cnn_cfg_mem_h[i].build();                                    
                        end

                        output_prt_h = new[3];
			foreach(output_prt_h[i])begin
      			output_prt_h[i] = output_port::type_id::create($sformatf("output_prt_h[%0d]",i)); 
      			output_prt_h[i].configure(this);                            
      			output_prt_h[i].build();                                    
                        end

                        
      			crc_h = crc::type_id::create("crc_h"); 
      			crc_h.configure(this);                            
      			crc_h.build();                                    
      

  default_map  = create_map(  .name("default_map"),         
	                        .base_addr('b0),	      
                                .n_bytes(4),	  	      
	                        .endian(UVM_LITTLE_ENDIAN),   
	                        .byte_addressing(1)            
                           );		

  foreach(cnn_cfg_mem_h[i])begin
  default_map.add_reg(        .rg(cnn_cfg_mem_h[i]),           
                              .offset(i),                    
                              .rights("RW"),                    
                              .unmapped(0),                  
                              .frontdoor(null)                 
                           );   
  end

  foreach(output_prt_h[i])begin
  default_map.add_reg(        .rg(output_prt_h[i]),
                              .offset(96+i),
                              .rights("RW")
                           );  
  end 

  default_map.add_reg(        .rg(crc_h),
                              .offset(100),
                              .rights("RW")
                           );   

	lock_model(); //lock register model for protect.
		
	endfunction
			
endclass
`endif
