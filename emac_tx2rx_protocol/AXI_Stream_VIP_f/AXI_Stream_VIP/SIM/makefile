ENV_MAS_PKG = ../ENV/MASTER_AGENT/axi_str_mas_pkg.sv
ENV_SLV_PKG = ../ENV/SLAVE_AGENT/axi_str_slv_pkg.sv
ENV_PKG = ../ENV/axi_str_env_pkg.sv
LYR_PKG = ../MAC_Layered_Agent/C2N_MAC_Layered_Agent/c2n_mac_lyr_pkg.sv../MAC_Layered_Agent/N2C_MAC_Layered_Agent/n2c_mac_lyr_pkg.sv
PKG = ../TEST/axi_str_pkg.sv
TOP = ../TOP/axi_str_top.sv
MASTER = +incdir+../ENV/MASTER_AGENT
SLAVE = +incdir+../ENV/SLAVE_AGENT
ENV = +incdir+../ENV
TEST = +incdir+../TEST
MAC_TO_AXI=+incdir+../MAC_Layered_Agent/C2N_MAC_Layered_Agent +incdir+../MAC_Layered_Agent/C2N_MAC_Layered_Agent
AXI_TO_MAC=+incdir+../MAC_Layered_Agent/N2C_MAC_Layered_Agent +incdir+../MAC_Layered_Agent/N2C_MAC_Layered_Agent
#seed_num=--seed
comp:
	vlog $(ENV_MAS_PKG) $(ENV_SLV_PKG) $(ENV_PKG) $(PKG) $(TOP) $(MASTER) $(SLAVE) $(ENV) $(TEST) 
axi_str:
	vsim -voptargs=+acc axi_str_top -c -do "run -all;exit" +UVM_TESTNAME="axi_str_mas_base_test" -l axi_stream.log -sv_seed 32
c2n_mac_to_axi:	
	vsim axi_str_top -c -do "run -all;exit" +UVM_TESTNAME="c2n_mac_to_axi_str_test" -l c2n_mac_to_axi_str_test.log -sv_seed 32	
n2c_mac_to_axi:
	vsim -voptargs=+acc axi_str_top -c -do "run -all;exit" +UVM_TESTNAME="n2c_mac_to_axi_str_test" -l n2c_mac_to_axi_str_test.log -sv_seed 32		
