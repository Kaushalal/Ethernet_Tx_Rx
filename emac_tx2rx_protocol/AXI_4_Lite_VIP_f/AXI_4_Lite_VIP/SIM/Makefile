TOP = axi_lite_top
seed_num = 123

comp:
	vlog \
	 ../TEST/axi_lite_pkg.sv ../TOP/axi_lite_top.sv \
	 +incdir+../TEST \
	 +incdir+../TOP \
	 +incdir+../ENV \
	 +incdir+../ENV/MASTER 

sim: 
	vsim -voptargs=+acc $(TOP) -c -do "run -all;exit" -sv_seed $(seed_num)

sim_gui:
	vsim -voptargs=+acc $(TOP) -do "add wave -r /*;run -all" -sv_seed $(seed_num)

run: comp sim

run_gui: comp sim_gui

