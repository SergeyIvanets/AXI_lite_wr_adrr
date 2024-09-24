class axi_lite_wr_addr_master_sequence extends uvm_sequence #(axi_lite_wr_addr_transaction);
  `uvm_object_utils(axi_lite_wr_addr_master_sequence)

  int m_trans_count = 5;

  function new(string name = "axi_lite_wr_addr_master_sequence");
    super.new(name);
  endfunction

  task body();
    axi_lite_wr_addr_transaction trans;

  /*  if (!uvm_config_db#(int)::get(this, "", "TRANS_COUNT", m_trans_count)) begin
      `uvm_fatal("MASTER AGENT", "TRANS_COUNT not set in the UVM config DB");
    end
    `uvm_info("MASTER AGENT", $sformatf("Retrieved TRANS_COUNT = %0d", m_trans_count), UVM_LOW);
*/

    repeat (m_trans_count) begin
      trans = axi_lite_wr_addr_transaction::type_id::create("trans");

      // Optionally, constrain AWADDR if needed (e.g., specific address range)
      trans.AWADDR = $urandom_range(32'h0000_0000, 32'hFFFF_FFFF);
      `uvm_info(get_type_name(), $sformatf("\n "), UVM_LOW);
      `uvm_info(get_type_name(), $sformatf("Master sequence trans.AWADDR: %0h", trans.AWADDR), UVM_LOW);

      start_item(trans);
      finish_item(trans);

      // Small delay between transactions
    //  repeat(5) @(posedge p_sequencer.vif.clk);
    end
  endtask : body
endclass : axi_lite_wr_addr_master_sequence
