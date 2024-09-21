class axi_lite_wr_addr_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(axi_lite_wr_addr_scoreboard)

  // Analysis ports to receive transactions from master and slave monitors
  uvm_analysis_imp #(axi_lite_wr_addr_transaction, axi_lite_wr_addr_scoreboard) master_analysis_export;
  uvm_analysis_imp #(axi_lite_wr_addr_transaction, axi_lite_wr_addr_scoreboard) slave_analysis_export;

  // Queues to store master and slave transactions
  axi_lite_wr_addr_transaction master_trans_queue[$];  // Master transaction queue
  axi_lite_wr_addr_transaction slave_trans_queue[$];   // Slave transaction queue

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase where the analysis ports are initialized
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Initialize analysis ports
    master_analysis_export = new("master_analysis_export", this);
    slave_analysis_export  = new("slave_analysis_export", this);
  endfunction

  // Write method for master transactions (connected to master_analysis_export)
  function void write(axi_lite_wr_addr_transaction t);
    // Push the transaction into the master queue
    master_trans_queue.push_back(t);
    compare_transactions();  // Compare transactions whenever a new one is received
  endfunction : write

  // Write method for slave transactions (connected to slave_analysis_export)
  function void write_slave_tr(axi_lite_wr_addr_transaction t);
    // Push the transaction into the slave queue
    slave_trans_queue.push_back(t);
    compare_transactions();  // Compare transactions whenever a new one is received
  endfunction : write_slave_tr

  // Compare transactions from master and slave
  function void compare_transactions();
    // Check if both queues have transactions ready for comparison
    if ($size(master_trans_queue) > 0 && $size(slave_trans_queue) > 0) begin
      axi_lite_wr_addr_transaction master_trans = master_trans_queue.pop_front();  // Get oldest master transaction
      axi_lite_wr_addr_transaction slave_trans  = slave_trans_queue.pop_front();   // Get oldest slave transaction

      // Compare the master and slave transactions
      if (master_trans.AWADDR != slave_trans.AWADDR) begin
        `uvm_error("SCOREBOARD", $sformatf("Address mismatch: Master AWADDR = %0h, Slave AWADDR = %0h", 
                  master_trans.AWADDR, slave_trans.AWADDR));
      end
      else begin
        `uvm_info("SCOREBOARD", $sformatf("Address match: Master AWADDR = %0h, Slave AWADDR = %0h", 
                  master_trans.AWADDR, slave_trans.AWADDR), UVM_LOW);
      end
    end
  endfunction : compare_transactions

endclass : axi_lite_wr_addr_scoreboard
