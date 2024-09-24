class axi_lite_wr_addr_master_sequencer extends uvm_sequencer #(axi_lite_wr_addr_transaction);
  `uvm_object_utils(axi_lite_wr_addr_master_sequencer)
  
  int unsigned trans_count;

  function new(string name = "axi_lite_wr_addr_master_sequencer");
    super.new(name);
  endfunction

endclass : axi_lite_wr_addr_master_sequencer
