onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -label sim:/axi_str_top/mas_inf/drv_cb/Group1 -group {Region: sim:/axi_str_top/mas_inf/drv_cb} /axi_str_top/mas_inf/drv_cb/drv_cb_event
add wave -noupdate -expand -label sim:/axi_str_top/mas_inf/drv_cb/Group1 -group {Region: sim:/axi_str_top/mas_inf/drv_cb} /axi_str_top/mas_inf/drv_cb/tvalid
add wave -noupdate -expand -label sim:/axi_str_top/mas_inf/drv_cb/Group1 -group {Region: sim:/axi_str_top/mas_inf/drv_cb} /axi_str_top/mas_inf/drv_cb/tready
add wave -noupdate -expand -label sim:/axi_str_top/mas_inf/drv_cb/Group1 -group {Region: sim:/axi_str_top/mas_inf/drv_cb} /axi_str_top/mas_inf/drv_cb/tdata
add wave -noupdate -expand -label sim:/axi_str_top/mas_inf/drv_cb/Group1 -group {Region: sim:/axi_str_top/mas_inf/drv_cb} /axi_str_top/mas_inf/drv_cb/tkeep
add wave -noupdate -expand -label sim:/axi_str_top/mas_inf/drv_cb/Group1 -group {Region: sim:/axi_str_top/mas_inf/drv_cb} /axi_str_top/mas_inf/drv_cb/tlast
add wave -noupdate -expand -label sim:/axi_str_top/mas_inf/drv_cb/Group1 -group {Region: sim:/axi_str_top/mas_inf/drv_cb} /axi_str_top/mas_inf/drv_cb/tuser
add wave -noupdate -label sim:/axi_str_top/mas_inf/mon_cb/Group1 -group {Region: sim:/axi_str_top/mas_inf/mon_cb} /axi_str_top/mas_inf/mon_cb/mon_cb_event
add wave -noupdate -label sim:/axi_str_top/mas_inf/mon_cb/Group1 -group {Region: sim:/axi_str_top/mas_inf/mon_cb} /axi_str_top/mas_inf/mon_cb/tvalid
add wave -noupdate -label sim:/axi_str_top/mas_inf/mon_cb/Group1 -group {Region: sim:/axi_str_top/mas_inf/mon_cb} /axi_str_top/mas_inf/mon_cb/tready
add wave -noupdate -label sim:/axi_str_top/mas_inf/mon_cb/Group1 -group {Region: sim:/axi_str_top/mas_inf/mon_cb} /axi_str_top/mas_inf/mon_cb/tdata
add wave -noupdate -label sim:/axi_str_top/mas_inf/mon_cb/Group1 -group {Region: sim:/axi_str_top/mas_inf/mon_cb} /axi_str_top/mas_inf/mon_cb/tkeep
add wave -noupdate -label sim:/axi_str_top/mas_inf/mon_cb/Group1 -group {Region: sim:/axi_str_top/mas_inf/mon_cb} /axi_str_top/mas_inf/mon_cb/tlast
add wave -noupdate -label sim:/axi_str_top/mas_inf/mon_cb/Group1 -group {Region: sim:/axi_str_top/mas_inf/mon_cb} /axi_str_top/mas_inf/mon_cb/tuser
add wave -noupdate -label sim:/axi_str_top/mas_inf/slv_drv_cb/Group1 -group {Region: sim:/axi_str_top/mas_inf/slv_drv_cb} /axi_str_top/mas_inf/slv_drv_cb/slv_drv_cb_event
add wave -noupdate -label sim:/axi_str_top/mas_inf/slv_drv_cb/Group1 -group {Region: sim:/axi_str_top/mas_inf/slv_drv_cb} /axi_str_top/mas_inf/slv_drv_cb/tvalid
add wave -noupdate -label sim:/axi_str_top/mas_inf/slv_drv_cb/Group1 -group {Region: sim:/axi_str_top/mas_inf/slv_drv_cb} /axi_str_top/mas_inf/slv_drv_cb/tready
add wave -noupdate -label sim:/axi_str_top/mas_inf/slv_drv_cb/Group1 -group {Region: sim:/axi_str_top/mas_inf/slv_drv_cb} /axi_str_top/mas_inf/slv_drv_cb/tlast
add wave -noupdate -expand -label sim:/axi_str_top/mas_inf/Group1 -group {Region: sim:/axi_str_top/mas_inf} /axi_str_top/mas_inf/aclk
add wave -noupdate -expand -label sim:/axi_str_top/mas_inf/Group1 -group {Region: sim:/axi_str_top/mas_inf} /axi_str_top/mas_inf/areset_n
add wave -noupdate -expand -label sim:/axi_str_top/mas_inf/Group1 -group {Region: sim:/axi_str_top/mas_inf} /axi_str_top/mas_inf/tvalid
add wave -noupdate -expand -label sim:/axi_str_top/mas_inf/Group1 -group {Region: sim:/axi_str_top/mas_inf} /axi_str_top/mas_inf/tready
add wave -noupdate -expand -label sim:/axi_str_top/mas_inf/Group1 -group {Region: sim:/axi_str_top/mas_inf} /axi_str_top/mas_inf/tdata
add wave -noupdate -expand -label sim:/axi_str_top/mas_inf/Group1 -group {Region: sim:/axi_str_top/mas_inf} /axi_str_top/mas_inf/tkeep
add wave -noupdate -expand -label sim:/axi_str_top/mas_inf/Group1 -group {Region: sim:/axi_str_top/mas_inf} /axi_str_top/mas_inf/tlast
add wave -noupdate -expand -label sim:/axi_str_top/mas_inf/Group1 -group {Region: sim:/axi_str_top/mas_inf} /axi_str_top/mas_inf/tuser
add wave -noupdate -expand -label sim:/axi_str_top/mas_inf/Group1 -group {Region: sim:/axi_str_top/mas_inf} /axi_str_top/mas_inf/DATA_SIZE
add wave -noupdate -expand -label sim:/axi_str_top/mas_inf/Group1 -group {Region: sim:/axi_str_top/mas_inf} /axi_str_top/mas_inf/USER_SIZE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50764 ps} 0}
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
WaveRestoreZoom {0 ps} {213762 ps}
