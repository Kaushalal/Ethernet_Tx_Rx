#${1}
vlog ../ENV/MASTER_AGENT/axi_str_mas_pkg.sv ../ENV/SLAVE_AGENT/axi_str_slv_pkg.sv ../ENV/axi_str_env_pkg.sv ../../MAC_Layered_Agent/C2N_MAC_Layered_Agent/c2n_mac_lyr_pkg.sv ../../MAC_Layered_Agent/N2C_MAC_Layered_Agent/n2c_mac_lyr_pkg.sv ../TEST/axi_str_pkg.sv ../TOP/axi_str_top.sv +incdir+../ENV/MASTER_AGENT +incdir+../ENV/SLAVE_AGENT +incdir+../ENV +incdir+../TEST +incdir+../../MAC_Layered_Agent/C2N_MAC_Layered_Agent +incdir+../../MAC_Layered_Agent/C2N_MAC_Layered_Agent +incdir+../../MAC_Layered_Agent/N2C_MAC_Layered_Agent +incdir+../../MAC_Layered_Agent/N2C_MAC_Layered_Agent
vsim -voptargs=+acc axi_str_top -l ${1}.log +UVM_TESTNAME=${1} +UVM_OBJECTION_TRACE -sv_seed ${2}
do ./wave.do
run -all


