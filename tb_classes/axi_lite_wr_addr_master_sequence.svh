class axi_lite_wr_addr_master_sequence extends uvm_sequence #(axi_lite_wr_addr_transaction);
  `uvm_object_utils(axi_lite_wr_addr_master_sequence)
  const string report_id="MASTER SEQUENCE";

  int trans_count;

  function new(string name = "axi_lite_wr_addr_master_sequence");
    super.new(name);
  endfunction

  task body();
    axi_lite_wr_addr_transaction trans;
    axi_lite_wr_addr_master_sequencer master_seqr;

    if (!$cast(master_seqr, m_sequencer)) begin
      `uvm_fatal(report_id, "Failed to cast m_sequencer to axi_lite_wr_addr_master_sequencer");
    end
    trans_count = master_seqr.trans_count;
    `uvm_info(report_id, $sformatf("Using TRANS_COUNT = %0d from sequencer",
              trans_count), UVM_LOW);

    repeat (trans_count) begin
      trans = axi_lite_wr_addr_transaction::type_id::create("trans");
      if (!trans.randomize()) begin
        `uvm_error(report_id, "Failed to randomize the transaction");
      end
      `uvm_info(report_id, $sformatf("Master sequence trans.AWADDR: %h", trans.AWADDR), UVM_LOW);
      `uvm_info(report_id, $sformatf("Master sequence trans_count: %d", trans_count), UVM_LOW);

      start_item(trans);
      finish_item(trans);
      trans_count--;
    end
  endtask : body
endclass : axi_lite_wr_addr_master_sequence
