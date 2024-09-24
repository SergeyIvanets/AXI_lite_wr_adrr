class axi_lite_wr_addr_transaction extends uvm_sequence_item;
  `uvm_object_utils(axi_lite_wr_addr_transaction)

  rand bit [31:0] AWADDR;

  function new(string name = "axi_lite_wr_addr_transaction");
    super.new(name);
  endfunction

  function void display();
    `uvm_info("TRANSACTION", $sformatf("AWADDR: %0h", AWADDR), UVM_LOW)
  endfunction
endclass : axi_lite_wr_addr_transaction
