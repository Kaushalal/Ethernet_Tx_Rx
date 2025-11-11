/*------------------------------------------------------------------------
                          Name      : Jyoti Vishwakarma
                          File Name : register.sv
                          Date      : Oct 12
------------------------------------------------------------------------ */
`ifndef RAL_REG
`define RAL_REG

/*----------------------------------------------------------------------------------------------*/
/*--------------------------- CONNECTION CONFIGURATION REGISTER --------------------------------*/
/*----------------------------------------------------------------------------------------------*/
class connection_config_reg extends uvm_reg;

 `uvm_object_utils(connection_config_reg)

 rand uvm_reg_field connection_valid;
 rand uvm_reg_field connection_id;
      uvm_reg_field reserved1;
      uvm_reg_field reserved2;


 function new(string name ="connection_config_reg");
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


   reserved1         = uvm_reg_field::type_id::create("reserved1");
   reserved1.configure(        .parent(this),
                              .size(2),
                              .lsb_pos(5),
                              .access("RO"),
                              .volatile(0),
                              .reset('b0),
                              .has_reset(1),
                              .is_rand(0),
                              .individually_accessible(0)
                              );
   
   reserved2         = uvm_reg_field::type_id::create("reserved2");
   reserved2.configure(        .parent(this),
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

/*----------------------------------------------------------------------------------------------*/
/*---------------------------OUTPUT_PORT REGISTER ----------------------------------------------*/
/*----------------------------------------------------------------------------------------------*/

class output_port_reg extends uvm_reg;  ////TODO output_port_reg 

 `uvm_object_utils(output_port_reg)

  rand uvm_reg_field output_port_sel;
       uvm_reg_field reserved;

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
                              .individually_accessible(0)
                              );

                            endfunction

endclass

/*----------------------------------------------------------------------------------------------*/
/*---------------------------CRC REGISTER ------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------*/

class crc_reg extends uvm_reg;

 `uvm_object_utils(crc_reg)
  
  rand uvm_reg_field crc_reg_field; 
   

  function new(string name = "crc_reg");
    super.new(name, 32 , UVM_NO_COVERAGE);
    endfunction

  function void build();

   crc_reg_field = uvm_reg_field::type_id::create("crc_reg_field");
   crc_reg_field.configure(         .parent(this),
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

/*----------------------------------------------------------------------------------------------*/
/*---------------------------VCID REGISTER ----------------------------------------------*/
/*----------------------------------------------------------------------------------------------*/

class vcid_reg extends uvm_reg;   

 `uvm_object_utils(vcid_reg)

  rand uvm_reg_field vcid;
       uvm_reg_field reserved;

  function new(string name = "vcid_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
    endfunction

  function void build();

   vcid = uvm_reg_field::type_id::create("vcid");
   vcid.configure(.parent(this),
                              .size(8),
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
