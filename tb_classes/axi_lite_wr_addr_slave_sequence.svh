class axi_lite_wr_addr_slave_sequence extends uvm_sequence #(axi_lite_wr_addr_transaction);
  `uvm_object_utils(axi_lite_wr_addr_slave_sequence)

  int trans_count = 5;  // Define the transaction count

  function new(string name = "axi_lite_wr_addr_slave_sequence");
    super.new(name);
  endfunction

  task body();
   axi_lite_wr_addr_transaction trans;
   
   /*
    if (!uvm_config_db #(int)::get(this, "", "TRANS_COUNT", trans_count)) begin
      `uvm_fatal("SLAVE SEQENCE:", "TRANS_COUNT value not set in the config DB.");
    end
    `uvm_info("SLAVE AGENT", $sformatf("Retrieved TRANS_COUNT = %0d", trans_count), UVM_LOW);
*/

    repeat (trans_count) begin
      trans = axi_lite_wr_addr_transaction::type_id::create("trans");
      
      start_item(trans);
      finish_item(trans);
    end
  endtask : body
endclass : axi_lite_wr_addr_slave_sequence
