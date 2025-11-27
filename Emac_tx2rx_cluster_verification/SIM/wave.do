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
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {181 ps} 0}
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
WaveRestoreZoom {0 ps} {1926750 ps}
