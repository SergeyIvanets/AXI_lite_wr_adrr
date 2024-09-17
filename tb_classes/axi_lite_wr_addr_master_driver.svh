class axi_lite_wr_addr_master_driver extends uvm_driver #(axi_lite_wr_addr_transaction);
  `uvm_component_utils(axi_lite_wr_addr_master_driver);

  virtual axi_lite_wr_addr_if vif;

  function new(string name = "axi_lite_wr_addr_master_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive();
  extern virtual protected task reset_signals();
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task drive_transfer(axi_lite_wr_addr_transaction trans);

endclass : axi_lite_wr_addr_master_driver
//---------------------------------------------------------------------------------------
// IMPLEMENTATION
//---------------------------------------------------------------------------------------
// UVM connect_phase - gets the vif as a config property
function void axi_lite_wr_addr_master_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db #(virtual axi_lite_wr_addr_if)::get(this, get_full_name(), "vif", vif))
    `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
endfunction : connect_phase

task axi_lite_wr_addr_master_driver::run_phase(uvm_phase phase);
  fork
    get_and_drive();
    reset_signals();
  join
endtask : run_phase

// Manages the interaction between driver and sequencer
task axi_lite_wr_addr_master_driver::get_and_drive();
  forever begin
    seq_item_port.get_next_item(req);
    drive_transfer(req);  // Drive the transfer using the transaction
    seq_item_port.item_done();  // Mark the item as done
  end
endtask : get_and_drive

// Reset the AWVALID signal when reset is observed
task axi_lite_wr_addr_master_driver::reset_signals();
  forever begin
    @(negedge vif.reset_n);  // Wait for reset signal to go low
    uvm_report_info("AXI_WR_ADDR_MASTER_DRIVER", "Reset observed", UVM_MEDIUM);
    vif.AWVALID <= 1'b0;    
  end
endtask : reset_signals

// Drive the transfer on the AXI Lite bus
task axi_lite_wr_addr_master_driver::drive_transfer(axi_lite_wr_addr_transaction trans);
  // Drive the transaction onto the AXI Lite interface
  @(posedge vif.clk);
  vif.AWADDR <= trans.addr;
  vif.AWVALID <= 1'b1;

  // Wait for the slave to acknowledge with AWREADY
  wait (vif.AWREADY);

  // Transaction is complete, deassert AWVALID
  @(posedge vif.clk);
  vif.AWVALID <= 1'b0;
endtask : drive_transfer
