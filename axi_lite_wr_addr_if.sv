interface axi_lite_wr_addr_if(input bit clk, input bit reset_n);

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

endinterface
