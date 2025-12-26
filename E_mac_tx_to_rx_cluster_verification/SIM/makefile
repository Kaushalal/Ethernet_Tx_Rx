
#Makefile

PKG= ../ENV/AXI_stream_VIP/AXI_STR_MASTER_AGENT/axi_str_mas_pkg.sv ../ENV/AXI_stream_VIP/AXI_STR_SLAVE_AGENT/axi_str_slv_pkg.sv ../ENV/EMAC_TX/emac_tx_agent/mac_tx_pkg.svh ../ENV/EMAC_RX/emac_rx_agent/emac_rx_pkg.sv ../ENV/AXI_4_RAL/AXI_M_AGENT/axi_mpkg.svh ../ENV/AXI_4_RAL/AXI_Master_Register_file/axi_4_ral_pkg.svh ../ENV/mac_to_axi_s_env_pkg.svh ../TEST/mac_to_axi_s_test_pkg.svh 

TOP_DIR= ../TOP/mac_to_axi_s_top.sv
TOP= mac_to_axi_s_top
RTL= ../RTL/e_mac_tx2_rx_top.sv

INCDIR = +incdir+../RTL +incdir+../RTL/Interface +incdir+../ENV +incdir+../TEST +incdir+../TOP +incdir+../ENV/AXI_stream_VIP +incdir+../ENV/AXI_stream_VIP/AXI_STR_MASTER_AGENT +incdir+../ENV/AXI_stream_VIP/AXI_STR_SLAVE_AGENT +incdir+../ENV/EMAC_TX +incdir+../ENV/EMAC_TX/emac_tx_agent +incdir+../ENV/EMAC_RX +incdir+../ENV/EMAC_RX/emac_rx_agent +incdir+../ENV/AXI_4_RAL +incdir+../ENV/AXI_4_RAL/AXI_M_AGENT +incdir+../ENV/AXI_4_RAL/AXI_Master_Register_file	

COV_EN=0
TEST = mac_to_axi_s_base_test

lb:
	vlib work

cmp: 
	vlog -timescale 1ns/1ps +acc $(RTL) $(PKG) $(TOP_DIR) $(INCDIR)  

cmp_coverage:
	vlog -timescale 1ns/1ps -coveropt 3 +cover +acc $(RTL) $(PKG) $(TOP_DIR) $(INCDIR)

sim_cmd:
	vsim -vopt $(TOP) -c -do "run -all; exit" +UVM_TESTNAME=$(TEST) 

sim:
	vsim -vopt $(TOP) -assertdebug -do "do wave.do; run -all; exit" +UVM_TESTNAME=$(TEST)  

sim_coverage:
	vsim -coverage -vopt $(TOP) -c -do "coverage save -onexit -directive -cvg -codeall AXI_CVG.ucdb; run -all; exit" +UVM_TESTNAME=$(TEST) -l TEST.log
	vcover report -details -html AXI_CVG.ucdb -htmldir AXI_CVG_REPORT	

ifeq ($(COV_EN),1)
run: cmp_coverage sim_coverage
else
run: cmp sim
endif

run_cmd: cmp sim_cmd 
