class axi_lite_wr_addr_master_sequence extends uvm_sequence #(axi_lite_wr_addr_transaction);
  `uvm_object_utils(axi_lite_wr_addr_master_sequence)

  int unsigned trans_count;  // Define the transaction count

  function new(string name = "axi_lite_wr_addr_master_sequence");
    super.new(name);
  endfunction

  task body();
    axi_lite_wr_addr_transaction trans;

    repeat (trans_count) begin
      trans = axi_lite_wr_addr_transaction::type_id::create("trans");

      // Optionally, constrain AWADDR if needed (e.g., specific address range)
      trans.AWADDR = $urandom_range(32'h0000_0000, 32'hFFFF_FFFF);

      start_item(trans);
      finish_item(trans);

      // Small delay between transactions
    //  repeat(5) @(posedge p_sequencer.vif.clk);
    end
  endtask : body
endclass : axi_lite_wr_addr_master_sequence
