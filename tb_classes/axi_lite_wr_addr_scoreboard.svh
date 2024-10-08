class axi_lite_wr_addr_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(axi_lite_wr_addr_scoreboard)
  const string report_id="SCOREBOARD";

  uvm_analysis_imp #(axi_lite_wr_addr_transaction, axi_lite_wr_addr_scoreboard) master_analysis_export;
  uvm_tlm_analysis_fifo #(axi_lite_wr_addr_transaction) slave_analysis_fifo;

  axi_lite_wr_addr_transaction master_trans_queue[$];
  axi_lite_wr_addr_transaction slave_trans_queue[$];

  int unsigned num_mismatch_transactions = 0;
  int unsigned num_match_transactions = 0;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    master_analysis_export = new("master_analysis_export", this);
    slave_analysis_fifo = new("slave_analysis_fifo", this);
  endfunction

  extern function void write(axi_lite_wr_addr_transaction t);
  extern task handle_slave_transactions();
  extern task run_phase(uvm_phase phase);
  extern function void compare_transactions();
  extern function void report_phase(uvm_phase phase);

endclass : axi_lite_wr_addr_scoreboard
//---------------------------------------------------------------------------------------
// IMPLEMENTATION
//---------------------------------------------------------------------------------------

function void axi_lite_wr_addr_scoreboard::write(axi_lite_wr_addr_transaction t);
  master_trans_queue.push_back(t);
//  `uvm_info(report_id, $sformatf("Master transaction collected: %h", t.AWADDR), UVM_LOW);
  compare_transactions();
endfunction : write

task axi_lite_wr_addr_scoreboard::handle_slave_transactions();
  axi_lite_wr_addr_transaction slave_trans;

  while (slave_analysis_fifo.try_get(slave_trans)) begin
    slave_trans_queue.push_back(slave_trans);
//    `uvm_info(report_id, $sformatf("Slave transaction collected: %h", slave_trans.AWADDR), UVM_LOW);
  compare_transactions();
  end
endtask : handle_slave_transactions

task axi_lite_wr_addr_scoreboard::run_phase(uvm_phase phase);
  phase.raise_objection(this);
    forever begin
      handle_slave_transactions();
      #10ns;
    end
  phase.drop_objection(this);
endtask : run_phase

function void axi_lite_wr_addr_scoreboard::compare_transactions();
  if (master_trans_queue.size() > 0 && slave_trans_queue.size() > 0) begin
    axi_lite_wr_addr_transaction master_trans = master_trans_queue.pop_front();
    axi_lite_wr_addr_transaction slave_trans = slave_trans_queue.pop_front();

    if (master_trans.AWADDR != slave_trans.AWADDR) begin
      `uvm_error(report_id, $sformatf(
        "Address mismatch: Master AWADDR = %0h, Slave AWADDR = %0h, mismatch transaction = %0d", 
        master_trans.AWADDR, slave_trans.AWADDR, num_mismatch_transactions++));
    end else begin
      `uvm_info(report_id, $sformatf(
        "Address match: Master AWADDR = %h, Slave AWADDR = %h, match transaction = %0d", 
        master_trans.AWADDR, slave_trans.AWADDR, num_match_transactions++), UVM_LOW);
    end
  end
endfunction : compare_transactions

function void axi_lite_wr_addr_scoreboard::report_phase(uvm_phase phase);
  `uvm_info(report_id, $sformatf("Report: Scoreboard collected %0d fail transfers", 
            num_mismatch_transactions), UVM_LOW);
  `uvm_info(report_id, $sformatf("Report: Scoreboard collected %0d success transfers", 
            num_match_transactions), UVM_LOW);

endfunction : report_phase  