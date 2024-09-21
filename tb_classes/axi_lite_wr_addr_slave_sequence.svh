class axi_lite_wr_addr_slave_sequence extends uvm_sequence #(axi_lite_wr_addr_transaction);
  `uvm_object_utils(axi_lite_wr_addr_slave_sequence)

  int unsigned trans_count;  // Define the transaction count

  function new(string name = "axi_lite_wr_addr_slave_sequence");
    super.new(name);
  endfunction

  task body();
    axi_lite_wr_addr_transaction trans;

    repeat (trans_count) begin
      trans = axi_lite_wr_addr_transaction::type_id::create("trans");
      
      start_item(trans);
      finish_item(trans);
    end
  endtask : body
endclass : axi_lite_wr_addr_slave_sequence
