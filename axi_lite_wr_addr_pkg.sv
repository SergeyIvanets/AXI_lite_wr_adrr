package axi_lite_wr_addr_pkg;
   import uvm_pkg::*;
   `include "uvm_macros.svh"
   `include "common_macros.svh"

   `include "axi_lite_wr_addr_env.svh"
   `include "axi_lite_wr_addr_test.svh"
   `include "axi_lite_wr_addr_transaction.svh"

   `include "axi_lite_wr_addr_master_driver.svh"
   `include "axi_lite_wr_addr_master_sequencer.svh"
   `include "axi_lite_wr_addr_master_sequence.svh"
   `include "axi_lite_wr_addr_master_monitor.svh"
   `include "axi_lite_wr_addr_master_agent.svh"
   `include "axi_lite_wr_addr_master_config.svh"
   
   `include "axi_lite_wr_addr_slave_driver.svh"
   `include "axi_lite_wr_addr_slave_sequencer.svh"
   `include "axi_lite_wr_addr_slave_sequence.svh"
   `include "axi_lite_wr_addr_slave_monitor.svh"
   `include "axi_lite_wr_addr_slave_agent.svh"
   `include "axi_lite_wr_addr_slave_config.svh"
endpackage : axi_lite_wr_addr_pkg