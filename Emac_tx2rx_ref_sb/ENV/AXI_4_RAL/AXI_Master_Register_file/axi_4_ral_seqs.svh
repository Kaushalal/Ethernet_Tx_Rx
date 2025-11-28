/*------------------------------------------------------------------------
                          Name      : Jyoti Vishwakarma
                          File Name : reg_base_seq.sv
                          Date      : Oct 12
------------------------------------------------------------------------ */

`ifndef AXI_4_RAL_SEQS
`define AXI_4_RAL_SEQS

class reg_conn_cfg_seq extends uvm_sequence#(uvm_sequence_item);

   rand bit [11:0]   vlan;
   rand bit [2:0]    port_id;

   rand bit        connection_valid;
   rand bit [4:0]    connection_id;

   rand bit [3:0]    out_port_sel;
   rand bit [31:0]   crc_val;
   rand bit [7:0]  vcid_val;
   
`uvm_object_utils_begin(reg_conn_cfg_seq)
 `uvm_field_int(vlan            , UVM_ALL_ON)
 `uvm_field_int(port_id         , UVM_ALL_ON)
 `uvm_field_int(connection_valid, UVM_ALL_ON)
 `uvm_field_int(connection_id   , UVM_ALL_ON)
 `uvm_field_int(out_port_sel    , UVM_ALL_ON)
 `uvm_field_int(crc_val         , UVM_ALL_ON)
`uvm_object_utils_end

 axi_4_reg_block axi_4_reg_block_h;

 function new (string name = "reg_conn_cfg_seq");
  	super.new(name);
 endfunction

/*---------------------------------------------------------*/
/*--------------- CONSTRAINT -------------------------*/
/*---------------------------------------------------------*/

 constraint VALID_CNSTR {soft connection_valid == 1'b1;}

/*---------------------------------------------------------*/
/*--------------- BODY -------------------------*/
/*---------------------------------------------------------*/
 
 task body();
   uvm_status_e status;

   bit[14:0] conn_cfg_addr;

   conn_cfg_addr = {port_id,vlan};
   
  //--------------------------------------------------------------------------------------------------------------//
   //STEP -1 : CONNECTION_CONFIG_MEM connection_valid and connection_id setup -> addr - {port,vlan}
  //--------------------------------------------------------------------------------------------------------------//

   axi_4_reg_block_h.conn_cfg_reg_h[conn_cfg_addr].write(status,{24'd0,connection_valid,2'b00,connection_id});
   
   //axi_4_reg_block_h.conn_cfg_reg_h[conn_cfg_addr].connection_valid.write(status,this.connection_valid);
   //axi_4_reg_block_h.conn_cfg_reg_h[conn_cfg_addr].connection_id.write(status,this.connection_id);
   //axi_4_reg_block_h.conn_cfg_reg_h[conn_cfg_addr].reserved1.write(status,'b0);
   //axi_4_reg_block_h.conn_cfg_reg_h[conn_cfg_addr].reserved2.write(status,'b0);
   `uvm_info("REG : CONNECTION_CONFIG_MEM",$sformatf("FEILDS : connection_valid : %0d || connection_id: %h || ADDR : port_id = %h || vlan = %h || conn_cfg_addr = %h ",connection_valid,connection_id,port_id,vlan, conn_cfg_addr),UVM_DEBUG)
  
  //--------------------------------------------------------------------------------------------------------------//
  //STEP -2  : OUTPUT_PORT -> addr - connection_id
  //--------------------------------------------------------------------------------------------------------------//
   
   axi_4_reg_block_h.output_prt_reg_h[connection_id].write(status,{28'b0,out_port_sel});
   
   //axi_4_reg_block_h.output_prt_reg_h[connection_id].output_port_sel.write(status,out_port_sel);
   //axi_4_reg_block_h.output_prt_reg_h[connection_id].reserved.write(status,'b0);
   
   `uvm_info("REG : OUTPUT_PORT_REG  ",$sformatf("FEILDS : out_port_sel : %0d ",this.out_port_sel),UVM_DEBUG)

  //--------------------------------------------------------------------------------------------------------------//
  //STEP -3  : CRC -> addr - connection_id
  //--------------------------------------------------------------------------------------------------------------//
   
   axi_4_reg_block_h.crc_reg_h[connection_id].crc_reg_field.write(status,crc_val);
   `uvm_info("REG : CRC_REG  ",$sformatf("FEILDS : crc_reg : %h ",crc_val),UVM_DEBUG)
  
  //--------------------------------------------------------------------------------------------------------------//
  //STEP -2  : VCID -> addr - connection_id
  //--------------------------------------------------------------------------------------------------------------//
  
   axi_4_reg_block_h.vcid_reg_h[connection_id].write(status,{24'b0,vcid_val});
   `uvm_info("REG : VCID_REG  ",$sformatf("FEILDS : vcid_reg : %h ",vcid_val),UVM_DEBUG)

   `uvm_info(" == CONNECTION_CONFIGURATION_SUMMARY == ",$sformatf("FEILDS : port_id = %0d || vlan = 'h%0h || connection_id = 'h%0d || vcid_reg : 'd%0d ",port_id,vlan,connection_id,vcid_val),UVM_MEDIUM)
   

 endtask   

endclass

`endif
