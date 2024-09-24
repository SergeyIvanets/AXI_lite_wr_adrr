interface axi_lite_wr_addr_if(input bit clk, input bit reset_n);
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  const string report_id="INTERFACE ASSERTION";

  logic [31:0] AWADDR;  // Address
  logic AWVALID;        // Address valid
  logic AWREADY;        // Address ready

  modport master (
    input clk, 
    input reset_n, 
    output AWADDR, 
    output AWVALID, 
    input AWREADY
  );

  modport slave  (
    input clk,
    input reset_n,
    input AWADDR,
    input AWVALID,
    output AWREADY
  );

  clocking cb @(posedge clk);
    input AWADDR;
    input AWVALID;
    output AWREADY;
  endclocking

//---------------------------------------------------------------------------------------
// ASSERTIONS
//---------------------------------------------------------------------------------------
property p_awready_requires_awvalid;
  @(posedge clk) disable iff (!reset_n) AWREADY |-> AWVALID;
endproperty
  assert property (p_awready_requires_awvalid)
    else `uvm_error(report_id, "AWREADY asserted without AWVALID being high");
  cover property (p_awready_requires_awvalid)
    `uvm_info(report_id, "AWREADY correctly asserted with AWVALID being high", UVM_LOW);

endinterface
