onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {str_inf[0]} {/emac_tx2rx_top/str_inf[0]/reset_n}
add wave -noupdate -expand -group {str_inf[0]} {/emac_tx2rx_top/str_inf[0]/tvalid}
add wave -noupdate -expand -group {str_inf[0]} {/emac_tx2rx_top/str_inf[0]/tlast}
add wave -noupdate -expand -group {str_inf[0]} {/emac_tx2rx_top/str_inf[0]/tready}
add wave -noupdate -expand -group {str_inf[0]} {/emac_tx2rx_top/str_inf[0]/tdata}
add wave -noupdate -expand -group {str_inf[0]} {/emac_tx2rx_top/str_inf[0]/tkeep}
add wave -noupdate -expand -group {str_inf[0]} {/emac_tx2rx_top/str_inf[0]/tuser}
add wave -noupdate -expand -group {str_inf[1]} {/emac_tx2rx_top/str_inf[1]/reset_n}
add wave -noupdate -expand -group {str_inf[1]} {/emac_tx2rx_top/str_inf[1]/tvalid}
add wave -noupdate -expand -group {str_inf[1]} {/emac_tx2rx_top/str_inf[1]/tlast}
add wave -noupdate -expand -group {str_inf[1]} {/emac_tx2rx_top/str_inf[1]/tready}
add wave -noupdate -expand -group {str_inf[1]} {/emac_tx2rx_top/str_inf[1]/tdata}
add wave -noupdate -expand -group {str_inf[1]} {/emac_tx2rx_top/str_inf[1]/tkeep}
add wave -noupdate -expand -group {str_inf[1]} {/emac_tx2rx_top/str_inf[1]/tuser}
add wave -noupdate -expand -group {str_inf[2]} {/emac_tx2rx_top/str_inf[2]/reset_n}
add wave -noupdate -expand -group {str_inf[2]} {/emac_tx2rx_top/str_inf[2]/tvalid}
add wave -noupdate -expand -group {str_inf[2]} {/emac_tx2rx_top/str_inf[2]/tlast}
add wave -noupdate -expand -group {str_inf[2]} {/emac_tx2rx_top/str_inf[2]/tready}
add wave -noupdate -expand -group {str_inf[2]} {/emac_tx2rx_top/str_inf[2]/tdata}
add wave -noupdate -expand -group {str_inf[2]} {/emac_tx2rx_top/str_inf[2]/tkeep}
add wave -noupdate -expand -group {str_inf[2]} {/emac_tx2rx_top/str_inf[2]/tuser}
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/reset_n
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/awvalid
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/awready
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/awaddr
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/awid
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/awsize
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/awlen
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/awburst
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/wvalid
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/wready
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/wdata
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/wlast
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/wid
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/wstrb
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/bready
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/bvalid
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/bresp
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/bid
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/arready
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/arvalid
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/araddr
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/arid
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/arsize
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/arlen
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/arburst
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/rvalid
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/rready
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/rdata
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/rlast
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/rid
add wave -noupdate -expand -group lite_inf /emac_tx2rx_top/lite_inf/rresp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {403790 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {425250 ps}
