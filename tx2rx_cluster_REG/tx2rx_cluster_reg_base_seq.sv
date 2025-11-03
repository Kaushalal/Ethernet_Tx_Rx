/*------------------------------------------------------------------------
                          Name      : Jyoti Vishwakarma
                          File Name : reg_base_seq.sv
                          Date      : Oct 12
------------------------------------------------------------------------ */


class reg_conn_cfg_seq extends uvm_sequence;

   rand bit [12]   vlan = 'b0;
   rand bit [3]    port_id ='b0;;

   rand bit        connection_valid;
   rand bit [5]    connection_id;

   rand bit [4]    out_port_sel;
   rand bit [32]   crc_val;


`uvm_object_utils_begin(reg_conn_cfg_seq)
 `uvm_field_int(vlan            , UVM_ALL_ON)
 `uvm_field_int(port_id         , UVM_ALL_ON)
 `uvm_field_int(connection_valid, UVM_ALL_ON)
 `uvm_field_int(connection_id   , UVM_ALL_ON)
 `uvm_field_int(out_port_sel    , UVM_ALL_ON)
 `uvm_field_int(crc_val         , UVM_ALL_ON)
 `uvm_object_utils_end

 tx2rx_cluster_reg_block reg_blk;

 function new (string name = "reg_conn_cfg_seq");
  	super.new(name);
        endfunction

/*--------------- CONSTRAINT -------------------------*/

 constraint VALID_CNSTR {soft connection_valid == 1'b1;}

 task body;
   uvm_status_e status;
  //STEP -1 : CONNECTION_CONFIG_MEM connection_valid and connection_id setup -> addr - {port,vlan}

   //reg_blk.cnn_cfg_mem_h[{port_id,vlan}].write(status,{24'd0,connection_valid,2'b00,connection_id});

   
   reg_blk.cnn_cfg_mem_reg[{port_id,vlan}].connection_valid.write(status,this.connection_valid);
   reg_blk.cnn_cfg_mem_reg[{port_id,vlan}].connection_id.write(status,this.connection_id);
   //reg_blk.cnn_cfg_mem_reg[{port_id,vlan}].reserved.write(status,'b0);
   //reg_blk.cnn_cfg_mem_reg[{port_id,vlan}].rsvd.write(status,'b0);

   `uvm_info("REG : connection_config_mem_reg",$sformatf("FEILDS : connection_valid : %0h ,connection_id: %0h",connection_valid,connection_id),UVM_MEDIUM)

  //STEP -2  : OUTPUT_PORT -> addr - connection_id
   reg_blk.output_prt_reg[connection_id].output_port_sel.write(status,out_port_sel);
  //reg_blk.output_prt_reg[connection_id].reserved.write(status,'b0);
   `uvm_info("REG : OUTPUT_PORT REG      ",$sformatf("FEILDS : out_port_sel : %0h ",this.out_port_sel),UVM_MEDIUM)

  //STEP -3  : CRC -> addr - connection_id
   reg_blk.crc_reg[connection_id].crc_field.write(status,crc_val);
   `uvm_info("REG : CRC REG              ",$sformatf("FEILDS : crc_reg : %0h ",crc_val),UVM_MEDIUM)


 endtask   

endclass
