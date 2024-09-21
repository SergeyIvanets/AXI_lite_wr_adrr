set project_name "axi_lite_uvm"

set project_found [llength [get_projects $project_name] ]
if {$project_found > 0} close_project

# set the reference directory to where the script is
set origin_dir [file dirname [info script]]
cd [file dirname [info script]]

# create project
create_project $project_name "$project_name" -force

# add sources

add_files -norecurse axi_lite_wr_addr_macros.svh
add_files -norecurse axi_lite_wr_addr_if.sv
add_files -norecurse axi_lite_wr_addr_pkg.sv
add_files -norecurse top.sv

add_files -norecurse tb_classes/axi_lite_wr_addr_master_config.svh
add_files -norecurse tb_classes/axi_lite_wr_addr_slave_config.svh

add_files -norecurse tb_classes/axi_lite_wr_addr_env.svh
add_files -norecurse tb_classes/axi_lite_wr_addr_test.svh
add_files -norecurse tb_classes/axi_lite_wr_addr_transaction.svh
add_files -norecurse tb_classes/axi_lite_wr_addr_scoreboard.svh

add_files -norecurse tb_classes/axi_lite_wr_addr_master_driver.svh
add_files -norecurse tb_classes/axi_lite_wr_addr_master_sequencer.svh
add_files -norecurse tb_classes/axi_lite_wr_addr_master_sequence.svh
add_files -norecurse tb_classes/axi_lite_wr_addr_master_monitor.svh
add_files -norecurse tb_classes/axi_lite_wr_addr_master_agent.svh


add_files -norecurse tb_classes/axi_lite_wr_addr_slave_driver.svh
add_files -norecurse tb_classes/axi_lite_wr_addr_slave_sequencer.svh
add_files -norecurse tb_classes/axi_lite_wr_addr_slave_sequence.svh
add_files -norecurse tb_classes/axi_lite_wr_addr_slave_monitor.svh
add_files -norecurse tb_classes/axi_lite_wr_addr_slave_agent.svh

# uvm
set_property -name {xsim.compile.xvlog.more_options} -value {-L uvm} -objects [get_filesets sim_1]
set_property -name {xsim.elaborate.xelab.more_options} -value {-L uvm} -objects [get_filesets sim_1]

# lunch simulation
set_property top top [get_filesets sim_1]
launch_simulation