/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : axi_str_slv_define.sv

* Purpose : common parameter or enums

* Creation Date : 16-05-2024

* Last Modified :

* Created By :  

_._._._._._._._._._._._._._._._._._._._._.*/


`ifndef AXI_STR_SLV_DEFINE_SV
`define AXI_STR_SLV_DEFINE_SV

//typedef enum bit {SEQ,NON_SEQ} trans_type;
typedef enum bit {SLV_MANUAL, SLV_RANDOM} tready_drv_mode_enum;
//`define CYCLE 10ns
`define axis_slv_i_skew 0.333ns //0.33ns //0.033ns
`define axis_slv_o_skew 0.333ns //0.33ns //0.033ns
`endif
