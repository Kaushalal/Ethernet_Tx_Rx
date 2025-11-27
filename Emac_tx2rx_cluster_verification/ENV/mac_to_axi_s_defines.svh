/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = mac_to_axi_s_defines.svh
//  CREATED_BY  = Muskan Thakur 
//  MODIFIED_BY  =  
//  VERSION   = 1.0 
//  DESCRIPTION = These macros are responsible to give the size / type of agent   
//
/////////////////////////////////////////////////////

`ifndef MAC_TO_AXI_S_DEFINE
`define MAC_TO_AXI_S_DEFINE

`define AXI_STR_DATA_SIZE 32
`define AXI_STR_USER_SIZE 32
`define AXI_4_DATA_SIZE 32
`define AXI_4_ADD_SIZE 32
`define AXI_4_ID_SIZE 8
`define RX_PAYLOAD_DATA_WIDTH 8
`define RX_FRAME_DATA_WIDTH 32
`define NO_OF_OUTPUT_PORT   3


`define DATA_WIDTH 32
`define USER_WIDTH 32
//AXI4
`define ADDR_WIDTH 32 
`define AXI_LITE_ID_WIDTH 16


`endif
