package axi_lite_wr_addr_pkg;
   import uvm_pkg::*;
   `include "uvm_macros.svh"

   `include "tb_classes/axi_lite_wr_addr_transaction.svh"
   `include "tb_classes/axi_lite_wr_addr_scoreboard.svh"

   `include "tb_classes/axi_lite_wr_addr_master_driver.svh"
   `include "tb_classes/axi_lite_wr_addr_master_sequencer.svh"
   `include "tb_classes/axi_lite_wr_addr_master_sequence.svh"
   `include "tb_classes/axi_lite_wr_addr_master_monitor.svh"
   `include "tb_classes/axi_lite_wr_addr_master_config.svh"
   `include "tb_classes/axi_lite_wr_addr_master_agent.svh"

  `include "tb_classes/axi_lite_wr_addr_slave_sequencer.svh"
   `include "tb_classes/axi_lite_wr_addr_slave_sequence.svh"
   `include "tb_classes/axi_lite_wr_addr_slave_monitor.svh"
   `include "tb_classes/axi_lite_wr_addr_slave_config.svh"
   `include "tb_classes/axi_lite_wr_addr_slave_driver.svh"
   `include "tb_classes/axi_lite_wr_addr_slave_agent.svh"

   `include "tb_classes/axi_lite_wr_addr_env.svh"
   `include "tb_classes/axi_lite_wr_addr_test.svh"
endpackage : axi_lite_wr_addr_pkg

