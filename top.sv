`timescale 100ps/100ps
module top;
  import uvm_pkg::*;                  // UVM package
  `include "uvm_macros.svh"           // UVM macros

  import axi_lite_wr_addr_pkg::*;     // Import my package
  `include "axi_lite_wr_addr_macros.svh" // Import my macros

  logic ACLK;
  logic ARESETN;

  axi_lite_wr_addr_if axi_if(ACLK, ARESETN);

  initial begin
    ACLK = 0;
    forever #5 ACLK = ~ACLK; // 100 MHz
  end

  initial begin
    ARESETN = 0;
    repeat (3) @axi_if.cb;  
    ARESETN = 1; // Deassert reset after 3 clock periods
  end

   // UVM Testbench initialization
  initial begin
    // Pass interface to UVM fabric
    uvm_config_db #(virtual axi_lite_wr_addr_if)::set(null, "*", "axi_if", axi_if);

    run_test("axi_lite_wr_addr_test");  // UVM run test routine
  end

endmodule : top
