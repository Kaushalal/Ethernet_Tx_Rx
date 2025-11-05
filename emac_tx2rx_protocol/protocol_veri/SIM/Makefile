seed_num=123

comp:
	vlog -timescale 1ns/1ps \
  		../../AXI_Stream_VIP_f/AXI_Stream_VIP/ENV/MASTER_AGENT/axi_str_mas_pkg.sv \
  		../../AXI_Stream_VIP_f/AXI_Stream_VIP/ENV/SLAVE_AGENT/axi_str_slv_pkg.sv \
  		../../AXI_Stream_VIP_f/AXI_Stream_VIP/ENV/axi_str_env_pkg.sv \
  		../../AXI_Stream_VIP_f/AXI_Stream_VIP/TEST/axi_str_pkg.sv \
  		../../AXI_Stream_VIP_f/AXI_Stream_VIP/TOP/axi_str_top.sv \
		../../AXI_4_Lite_VIP_f/AXI_4_Lite_VIP/TEST/axi_lite_pkg.sv \
  		../ENV/EMAC_TX/emac_tx_pkg.sv \
		../ENV/EMAC_RX/emac_rx_pkg.sv \
		../ENV/REG/emac_tx2rx_reg_pkg.sv \
  		../ENV/emac_tx2rx_env_pkg.sv \
  		../TEST/emac_tx2rx_test_pkg.sv \
		../../e_mac_tx2_rx_rtl/Interface/axi_lite_inf.sv \
		../../e_mac_tx2_rx_rtl/Interface/axi_str_inf.sv \
		../../e_mac_tx2_rx_rtl/e_mac_tx2_rx_top.sv \
  		../TOP/emac_tx2rx_top.sv \
  		+incdir+../../AXI_Stream_VIP_f/AXI_Stream_VIP/ENV/MASTER_AGENT \
  		+incdir+../../AXI_Stream_VIP_f/AXI_Stream_VIP/ENV/SLAVE_AGENT \
  		+incdir+../../AXI_Stream_VIP_f/AXI_Stream_VIP/ENV \
  		+incdir+../../AXI_Stream_VIP_f/AXI_Stream_VIP/TEST \
		+incdir+../../AXI_4_Lite_VIP_f/AXI_4_Lite_VIP/ENV \
		+incdir+../../AXI_4_Lite_VIP_f/AXI_4_Lite_VIP/ENV/MASTER \
		+incdir+../../AXI_4_Lite_VIP_f/AXI_4_Lite_VIP/TEST \
		+incdir+../../AXI_4_Lite_VIP_f/AXI_4_Lite_VIP/TOP \
  		+incdir+../ENV/EMAC_TX \
		+incdir+../ENV/EMAC_RX \
		+incdir+../ENV/REG \
  		+incdir+../ENV \
  		+incdir+../TEST \
		+incdir+../../e_mac_tx2_rx_rtl/Interface \
		+incdir+../../e_mac_tx2_rx_rtl \
  		+incdir+../TOP
	
sim:
	vsim -voptargs=+acc emac_tx2rx_top -c -do "run -all;exit" -sv_seed $(seed_num)

sim_gui:
	vsim -voptargs=+acc emac_tx2rx_top -do "do wave.do; run -all" -sv_seed $(seed_num)
	
run : comp sim

run_gui : comp sim_gui	
