
#Makefile

PKG= ../ENV/MASTER_AGENT/axi_str_mas_pkg.sv ../ENV/SLAVE_AGENT/axi_str_slv_pkg.sv ../ENV/MAC_TX_AGENT/mac_tx_pkg.svh ../ENV/EMAC_RX/emac_rx_pkg.sv ../ENV/AXI_4_RAL/AXI_M_AGENT/axi_mpkg.svh ../ENV/AXI_4_RAL/AXI_Master_Register_file/axi_4_ral_pkg.svh ../ENV/mac_to_axi_s_env_pkg.svh ../TEST/mac_to_axi_s_test_pkg.svh 

TOP_DIR= ../TOP/mac_to_axi_s_top.sv
TOP= mac_to_axi_s_top
RTL= ../RTL/e_mac_tx2_rx_top.sv

INCDIR = +incdir+../RTL +incdir+../RTL/Interface +incdir+../ENV +incdir+../TEST +incdir+../ENV/MASTER_AGENT +incdir+../ENV/SLAVE_AGENT +incdir+../ENV/MAC_TX_AGENT +incdir+../ENV/EMAC_RX +incdir+../ENV/AXI_4_RAL/AXI_4_AGENT +incdir+../ENV/AXI_Master_Register_file +incdir+../TOP

COV_EN=0
TEST = mac_to_axi_s_sanity_test

lb:
	vlib work

cmp: 
	vlog -timescale 1ns/1ps +acc $(RTL) $(PKG) $(TOP_DIR) $(INCDIR)  

cmp_coverage:
	vlog -timescale 1ns/1ps -coveropt 3 +cover +acc $(RTL) $(PKG) $(TOP_DIR) $(INCDIR)

sim_cmd:
	vsim -vopt $(TOP) -c -do "run -all; exit" +UVM_TESTNAME=$(TEST) 

sim:
	vsim -vopt $(TOP) -assertdebug -do "run -all; do wave.do exit" +UVM_TESTNAME=$(TEST)  

sim_coverage:
	vsim -coverage -vopt $(TOP) -c -do "coverage save -onexit -directive -cvg -codeall AXI_CVG.ucdb; run -all; exit" +UVM_TESTNAME=$(TEST) -l TEST.log
	vcover report -details -html AXI_CVG.ucdb -htmldir AXI_CVG_REPORT	

ifeq ($(COV_EN),1)
run: cmp_coverage sim_coverage
else
run: cmp sim
endif

run_cmd: cmp sim_cmd 
