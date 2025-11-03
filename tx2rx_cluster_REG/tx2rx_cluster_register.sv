/*------------------------------------------------------------------------
                          Name        : Jyoti Vishwakarma
                          File Name   : register.sv
                          Date        : Oct 12
                          Description : ->  This register file consist in total of three registers( connection_config_mem, output_port, crc)
                                        ->  Connection_config_mem feilds : connection_valid, connectoin_id, reserved
------------------------------------------------------------------------ */

`ifndef CONN_CONFIF_MEM
`define CONN_CONFIF_MEM

class connection_config_mem_reg extends uvm_reg;

 `uvm_object_utils(connection_config_mem_reg)

 rand uvm_reg_field connection_valid;
 rand uvm_reg_field connection_id;
 rand uvm_reg_field reserved;
 rand uvm_reg_field rsvd;


 function new(string name ="connection_config_mem_reg");
   super.new(name, 32 , UVM_NO_COVERAGE);
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

   connection_id    = uvm_reg_field::type_id::create("connection_id");
   connection_id.configure(   .parent(this),
                              .size(5),
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
                              .size(2),
                              .lsb_pos(5),
                              .access("RO"),
                              .volatile(0),
                              .reset('b0),
                              .has_reset(1),
                              .is_rand(0),
                              .individually_accessible(1)
                              );

   rsvd              = uvm_reg_field::type_id::create("rsvd");
   rsvd.configure(        .parent(this),
                              .size(24),
                              .lsb_pos(8),
                              .access("RO"),
                              .volatile(0),
                              .reset('b0),
                              .has_reset(1),
                              .is_rand(0),
                              .individually_accessible(0)
                              );
                            endfunction

endclass 
`endif

/*----------------------------------------------------------------------------------------------*/


`ifndef OUTPUT_PORT_REG
`define OUTPUT_PORT_REG
//TODO:output_port_reg
class output_port_reg extends uvm_reg;

 `uvm_object_utils(output_port_reg)

  rand uvm_reg_field output_port_sel;
  rand uvm_reg_field reserved;

  function new(string name = "output_port_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
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
                              .size(28),
                              .lsb_pos(4),
                              .access("RO"),
                              .volatile(0),
                              .reset('b0),
                              .has_reset(1),
                              .is_rand(0),
                              .individually_accessible(1)
                              );

                            endfunction

endclass
`endif


/*----------------------------------------------------------------------------------------------*/

`ifndef CRC_REG
`define CRC_REG

class crc_register extends uvm_reg;

 `uvm_object_utils(crc_register)
  
  rand uvm_reg_field crc_field; 
   

  function new(string name = "crc_register");
    super.new(name, 32 , UVM_NO_COVERAGE);
    endfunction

  function void build();

   crc_field = uvm_reg_field::type_id::create("crc_field");
   crc_field.configure(         .parent(this),
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


