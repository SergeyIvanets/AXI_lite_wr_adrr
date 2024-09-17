class axi_lite_wr_addr_scoreboard extends uvm_component;
  `uvm_component_utils(axi_lite_wr_addr_scoreboard)

  uvm_analysis_imp #(axi_lite_wr_addr_transaction, axi_lite_wr_addr_scoreboard)
                    master_analysis_export;
  uvm_analysis_imp #(axi_lite_wr_addr_transaction, axi_lite_wr_addr_scoreboard)
                    slave_analysis_export;

  // Master and slave transactions
  axi_lite_wr_addr_transaction master_trans;
  axi_lite_wr_addr_transaction slave_trans;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    master_analysis_export = new("master_analysis_export", this);
    slave_analysis_export  = new("slave_analysis_export", this);
  endfunction

  extern function void write_master_tr(axi_lite_wr_addr_transaction t);  
  extern function void write_slave_tr(axi_lite_wr_addr_transaction t);
  extern function void compare_transactions();
  
endclass : axi_lite_wr_addr_scoreboard
//---------------------------------------------------------------------------------------
// IMPLEMENTATION
//---------------------------------------------------------------------------------------

  function void write_master_tr(axi_lite_wr_addr_transaction t);
    master_trans = t;
    compare_transactions();
  endfunction : write_master_tr

  function void write_slave_tr(axi_lite_wr_addr_transaction t);
    slave_trans = t;
    compare_transactions();
  endfunction : write_slave_tr

  function void compare_transactions();
    if (master_trans != null && slave_trans != null) begin
      if (master_trans.AWADDR != slave_trans.AWADDR) begin
        `uvm_error("SCOREBOARD", $sformatf("Address mismatch: Master AWADDR = %0h, 
                   Slave AWADDR = %0h", master_trans.AWADDR, slave_trans.AWADDR))
      end
      if (master_trans.AWVALID != slave_trans.AWVALID) begin
        `uvm_error("SCOREBOARD", $sformatf("AWVALID mismatch: Master AWVALID = %0b, 
                    Slave AWVALID = %0b", master_trans.AWVALID, slave_trans.AWVALID))
      end
    end
  endfunction : compare_transactions

