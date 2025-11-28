onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group IN_PORT_1 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[0]/reset_n}
add wave -noupdate -expand -group IN_PORT_1 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[0]/tvalid}
add wave -noupdate -expand -group IN_PORT_1 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[0]/tlast}
add wave -noupdate -expand -group IN_PORT_1 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[0]/tready}
add wave -noupdate -expand -group IN_PORT_1 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[0]/tdata}
add wave -noupdate -expand -group IN_PORT_1 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[0]/tkeep}
add wave -noupdate -expand -group IN_PORT_1 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[0]/tuser}
add wave -noupdate -expand -group IN_PORT_2 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[1]/reset_n}
add wave -noupdate -expand -group IN_PORT_2 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[1]/tvalid}
add wave -noupdate -expand -group IN_PORT_2 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[1]/tlast}
add wave -noupdate -expand -group IN_PORT_2 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[1]/tready}
add wave -noupdate -expand -group IN_PORT_2 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[1]/tdata}
add wave -noupdate -expand -group IN_PORT_2 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[1]/tkeep}
add wave -noupdate -expand -group IN_PORT_2 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[1]/tuser}
add wave -noupdate -expand -group IN_PORT_3 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[2]/reset_n}
add wave -noupdate -expand -group IN_PORT_3 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[2]/tvalid}
add wave -noupdate -expand -group IN_PORT_3 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[2]/tlast}
add wave -noupdate -expand -group IN_PORT_3 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[2]/tready}
add wave -noupdate -expand -group IN_PORT_3 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[2]/tdata}
add wave -noupdate -expand -group IN_PORT_3 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[2]/tkeep}
add wave -noupdate -expand -group IN_PORT_3 {/mac_to_axi_s_top/dut/u_arbiter/axis_in_inf[2]/tuser}
add wave -noupdate -expand -group Arbiter_output /mac_to_axi_s_top/dut/u_arbiter/axis_out_inf/reset_n
add wave -noupdate -expand -group Arbiter_output /mac_to_axi_s_top/dut/u_arbiter/axis_out_inf/tvalid
add wave -noupdate -expand -group Arbiter_output /mac_to_axi_s_top/dut/u_arbiter/axis_out_inf/tlast
add wave -noupdate -expand -group Arbiter_output /mac_to_axi_s_top/dut/u_arbiter/axis_out_inf/tready
add wave -noupdate -expand -group Arbiter_output /mac_to_axi_s_top/dut/u_arbiter/axis_out_inf/tdata
add wave -noupdate -expand -group Arbiter_output /mac_to_axi_s_top/dut/u_arbiter/axis_out_inf/tkeep
add wave -noupdate -expand -group Arbiter_output /mac_to_axi_s_top/dut/u_arbiter/axis_out_inf/tuser
add wave -noupdate -group OUT_PORT_1 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[0]/DATA_SIZE}
add wave -noupdate -group OUT_PORT_1 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[0]/USER_SIZE}
add wave -noupdate -group OUT_PORT_1 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[0]/reset_n}
add wave -noupdate -group OUT_PORT_1 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[0]/tvalid}
add wave -noupdate -group OUT_PORT_1 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[0]/tlast}
add wave -noupdate -group OUT_PORT_1 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[0]/tready}
add wave -noupdate -group OUT_PORT_1 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[0]/tdata}
add wave -noupdate -group OUT_PORT_1 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[0]/tkeep}
add wave -noupdate -group OUT_PORT_1 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[0]/tuser}
add wave -noupdate -group OUT_PORT_2 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[1]/DATA_SIZE}
add wave -noupdate -group OUT_PORT_2 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[1]/USER_SIZE}
add wave -noupdate -group OUT_PORT_2 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[1]/reset_n}
add wave -noupdate -group OUT_PORT_2 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[1]/tvalid}
add wave -noupdate -group OUT_PORT_2 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[1]/tlast}
add wave -noupdate -group OUT_PORT_2 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[1]/tready}
add wave -noupdate -group OUT_PORT_2 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[1]/tdata}
add wave -noupdate -group OUT_PORT_2 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[1]/tkeep}
add wave -noupdate -group OUT_PORT_2 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[1]/tuser}
add wave -noupdate -group OUT_PORT_3 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[2]/DATA_SIZE}
add wave -noupdate -group OUT_PORT_3 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[2]/USER_SIZE}
add wave -noupdate -group OUT_PORT_3 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[2]/reset_n}
add wave -noupdate -group OUT_PORT_3 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[2]/tvalid}
add wave -noupdate -group OUT_PORT_3 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[2]/tlast}
add wave -noupdate -group OUT_PORT_3 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[2]/tready}
add wave -noupdate -group OUT_PORT_3 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[2]/tdata}
add wave -noupdate -group OUT_PORT_3 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[2]/tkeep}
add wave -noupdate -group OUT_PORT_3 {/mac_to_axi_s_top/dut/u_header_parser/axis_out_inf[2]/tuser}
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/DATA_SIZE
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/ADDR_SIZE
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/ID_SIZE
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/reset_n
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/awvalid
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/awready
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/awaddr
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/awid
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/awsize
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/awlen
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/awburst
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/wvalid
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/wready
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/wdata
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/wlast
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/wid
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/wstrb
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/bready
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/bvalid
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/bresp
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/bid
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/arready
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/arvalid
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/araddr
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/arid
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/arsize
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/arlen
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/arburst
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/rvalid
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/rready
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/rdata
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/rlast
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/rid
add wave -noupdate -group AXI_LITE_DESIGN /mac_to_axi_s_top/axi_lite_design/rresp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {309478 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 408
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {6767250 ps}
