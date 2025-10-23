/*------------------------------------------------------------------------
                          Name      : Jyoti Vishwakarma
                          File Name : register.sv
                          Date      : Oct 12
------------------------------------------------------------------------ */
`ifndef RAL_REG
`define RAL_REG

class connection_config_mem extends uvm_reg;

 `uvm_object_utils(connection_config_mem)

 rand uvm_reg_field connection_valid;
 rand uvm_reg_field connection_id;
 rand uvm_reg_field reserved;


 function new(string name ="connection_config_mem");
   super.new(name, 8 , UVM_NO_COVERAGE);
   endfunction

 function void build();

   connection_valid = uvm_reg_field::type_id::create("connection_valid");
   connection_valid.configure(.parent(this),
                              .size(1),
                              .lsb_pos(7),
                              .access("RW"),
                              .volatile(0),
                              .reset(1'b0),
                              .has_reset(1),
                              .is_rand(1),
                              .individually_accessible(1)
                              );

   connection_id = uvm_reg_field::type_id::create("connection_id");
   connection_id.configure(.parent(this),
                              .size(5),
                              .lsb_pos(0),
                              .access("RW"),
                              .volatile(0),
                              .reset(1'b0),
                              .has_reset(1),
                              .is_rand(1),
                              .individually_accessible(1)
                              );


   reserved         = uvm_reg_field::type_id::create("reserved");
   reserved.configure(        .parent(this),
                              .size(2),
                              .lsb_pos(5),
                              .access("RO"),
                              .volatile(0),
                              .reset('b0),
                              .has_reset(1),
                              .is_rand(1),
                              .individually_accessible(1)
                              );

                            endfunction

endclass 


/*----------------------------------------------------------------------------------------------*/

class output_port extends uvm_reg;

 `uvm_object_utils(output_port)

  rand uvm_reg_field output_port_sel;
  rand uvm_reg_field reserved;

  function new(string name = "output_port");
    super.new(name, 8, UVM_NO_COVERAGE);
    endfunction

  function void build();

   output_port_sel = uvm_reg_field::type_id::create("output_port_sel");
   output_port_sel.configure(.parent(this),
                              .size(4),
                              .lsb_pos(0),
                              .access("RW"),
                              .volatile(0),
                              .reset('b0),
                              .has_reset(1),
                              .is_rand(1),
                              .individually_accessible(1)
                              );

   reserved         = uvm_reg_field::type_id::create("reserved");
   reserved.configure(        .parent(this),
                              .size(4),
                              .lsb_pos(4),
                              .access("RO"),
                              .volatile(0),
                              .reset('b0),
                              .has_reset(1),
                              .is_rand(1),
                              .individually_accessible(1)
                              );

                            endfunction

endclass



/*----------------------------------------------------------------------------------------------*/

class crc extends uvm_reg;

 `uvm_object_utils(crc)
  
  rand uvm_reg_field crc_reg; 
   

  function new(string name = "crc");
    super.new(name, 32 , UVM_NO_COVERAGE);
    endfunction

  function void build();

   crc_reg = uvm_reg_field::type_id::create("crc_reg");
   crc_reg.configure(         .parent(this),
                              .size(32),
                              .lsb_pos(0),
                              .access("RW"),
                              .volatile(0),
                              .reset('b0),
                              .has_reset(1),
                              .is_rand(1),
                              .individually_accessible(1)
                              );


  endfunction

endclass

`endif
