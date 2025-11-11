/*------------------------------------------------------------------------
                          Name      : Jyoti Vishwakarma
                          File Name : reg_block.sv
                          Date      : Oct 9
------------------------------------------------------------------------ */

class tx2rx_cluster_reg_block extends uvm_reg_block;

   `uvm_object_utils(tx2rx_cluster_reg_block)

	rand connection_config_mem_reg       cnn_cfg_mem_reg[];
	rand output_port_reg                 output_prt_reg [];
	rand crc_register                         crc_reg [];

	uvm_reg_map                      cnn_cfg_mem_map;    //maps connection_config_mem
	uvm_reg_map                      misc_reg_map;   //maps output_port and crc

 	function new(string name = "tx2rx_cluster_reg_block");
	 	 super.new(name ,build_coverage(UVM_NO_COVERAGE));
                 endfunction

        function void build();

/*-----------------------CREATE REGISTERS -------------------*/

                        cnn_cfg_mem_reg = new[32768];
                        foreach(cnn_cfg_mem_reg[i]) begin
      			        cnn_cfg_mem_reg[i] = connection_config_mem_reg::type_id::create($sformatf("cnn_cfg_mem_reg[%0d]",i)); 
      			        cnn_cfg_mem_reg[i].configure(this);                            
      			        cnn_cfg_mem_reg[i].build();                                    
                                end

                        output_prt_reg = new[32];
      			foreach(output_prt_reg[i]) begin
			        output_prt_reg[i]  = output_port_reg::type_id::create($sformatf("output_prt_reg[%0d]",i)); 
      		  	        output_prt_reg[i].configure(this);                            
      			        output_prt_reg[i].build(); 
			        end                                   

                        crc_reg  = new[32];
			foreach(crc_reg[i])        begin 
      		         	crc_reg[i] = crc_register::type_id::create($sformatf("crc_reg[%0d]",i)); 
      		         	crc_reg[i].configure(this);                            
      		         	crc_reg[i].build();                                    
                                end 

/*-----------------------CREATE MAP -------------------*/

  cnn_cfg_mem_map   = create_map(  .name("cnn_cfg_mem_map"),         
	                       .base_addr('h4000),	     //0x4000; 
                               .n_bytes(4),	  	      
	                       .endian(UVM_LITTLE_ENDIAN),   
	                       .byte_addressing(1)            
                           );		

  misc_reg_map     = create_map(  .name("misc_reg_map"),         
	                       .base_addr('h3000),	     //0x4000; 
                               .n_bytes(4),	  	      
	                       .endian(UVM_LITTLE_ENDIAN),   
	                       .byte_addressing(1)            
                           );		

/*-----------------------ADD_REG -------------------*/

  foreach(cnn_cfg_mem_reg[i])begin
          cnn_cfg_mem_map.add_reg( .rg(cnn_cfg_mem_reg[i]),           
                               .offset(i),                    
                               .rights("RW"),                    
                               .unmapped(0),                  
                               .frontdoor(null)                 
                           );   
          end

  foreach(output_prt_reg[i])begin
          misc_reg_map.add_reg(.rg(output_prt_reg[i]),
                               .offset(i),
                               .rights("RW")
                           );  
          end

  foreach(crc_reg[i])begin
          misc_reg_map.add_reg(.rg(crc_reg[i]),
                               .offset('h30+i),
                               .rights("RW")
                           );   
        end
	lock_model(); //lock register model for protect.
		
	endfunction
			
endclass	
			

