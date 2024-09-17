class axi_lite_wr_addr_slave_sequencer extends uvm_sequencer #(axi_lite_wr_addr_transaction);
  `uvm_component_utils(axi_lite_wr_addr_slave_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : axi_lite_wr_addr_slave_sequencer
