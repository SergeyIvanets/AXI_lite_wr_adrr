class axi_lite_wr_addr_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(axi_lite_wr_addr_scoreboard)

  // Separate ports for master and slave transactions
  uvm_analysis_imp #(axi_lite_wr_addr_transaction, axi_lite_wr_addr_scoreboard) master_analysis_export;
  uvm_analysis_imp #(axi_lite_wr_addr_transaction, axi_lite_wr_addr_scoreboard) slave_analysis_export;

  // Queues for master and slave transactions
  axi_lite_wr_addr_transaction master_trans_queue[$];
  axi_lite_wr_addr_transaction slave_trans_queue[$];

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Separate write functions for master and slave
  extern function void write_m(axi_lite_wr_addr_transaction t);  // Master write function
  extern function void write_s(axi_lite_wr_addr_transaction t);  // Slave write function

  extern function void compare_transactions();
endclass : axi_lite_wr_addr_scoreboard

//---------------------------------------------------------------------------------------
// IMPLEMENTATION
//---------------------------------------------------------------------------------------

function void axi_lite_wr_addr_scoreboard::write_m(axi_lite_wr_addr_transaction t);
  // Master transactions are added to the master queue
  master_trans_queue.push_back(t);
  `uvm_info(get_type_name(), $sformatf("Master AWADDR collected: %h", t.AWADDR), UVM_LOW);
  compare_transactions();  // Compare master and slave transactions
endfunction : write_m

function void axi_lite_wr_addr_scoreboard::write_s(axi_lite_wr_addr_transaction t);
  // Slave transactions are added to the slave queue
  slave_trans_queue.push_back(t);
  `uvm_info(get_type_name(), $sformatf("Slave AWADDR collected: %h", t.AWADDR), UVM_LOW);
  compare_transactions();  // Compare master and slave transactions
endfunction : write_s

function void axi_lite_wr_addr_scoreboard::compare_transactions();
  if (master_trans_queue.size() > 0 && slave_trans_queue.size() > 0) begin
    axi_lite_wr_addr_transaction master_trans = master_trans_queue.pop_front();
    axi_lite_wr_addr_transaction slave_trans = slave_trans_queue.pop_front();

    if (master_trans.AWADDR != slave_trans.AWADDR) begin
      `uvm_error("SCOREBOARD", $sformatf("Address mismatch: Master AWADDR = %0h, Slave AWADDR = %0h", 
                master_trans.AWADDR, slave_trans.AWADDR));
    end else begin
      `uvm_info("SCOREBOARD", $sformatf("Address match: Master AWADDR = %0h, Slave AWADDR = %0h", 
                master_trans.AWADDR, slave_trans.AWADDR), UVM_LOW);
    end
  end
endfunction : compare_transactions
