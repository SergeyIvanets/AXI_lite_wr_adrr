create_libs:
	vlib work
	vlib work/test

map_libs:
	vmap test work/test

comp_sv:
	vlog -64 \
	-work def_lib \
	-L test \
	-work def_lib axi_lite_wr_addr_if.sv \
	-work def_lib axi_lite_wr_addr_pkg.sv \
	-work def_lib top.sv

run_sim:
	vsim -64 -voptargs="+acc" \
	-L test \
	-L def_lib -lib def_lib def_lib.top \
	-do "run -all" \

all: \
	create_libs \
	map_libs \
	comp_sv \
	run_sim \