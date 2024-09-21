class axi_lite_wr_addr_slave_driver extends uvm_driver #(axi_lite_wr_addr_transaction);
  `uvm_component_utils(axi_lite_wr_addr_slave_driver);

  virtual axi_lite_wr_addr_if vif;
  axi_lite_wr_addr_transaction trans;
  int latency_value;

  function new(string name = "axi_lite_wr_addr_slave_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive();
  extern virtual protected task reset_signals();
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task drive_transfer();

endclass : axi_lite_wr_addr_slave_driver
//---------------------------------------------------------------------------------------
// IMPLEMENTATION
//---------------------------------------------------------------------------------------

function void axi_lite_wr_addr_slave_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  if (!uvm_config_db #(int)::get(this, "", "LATENCY", latency_value)) begin
    `uvm_fatal("NO_LATENCY", "LATENCY value not set in the config DB.");
  end
endfunction : build_phase

// UVM connect_phase - gets the vif as a config property
function void axi_lite_wr_addr_slave_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db #(virtual axi_lite_wr_addr_if)::get(this, get_full_name(), "axi_if", vif))
    `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
endfunction : connect_phase

task axi_lite_wr_addr_slave_driver::run_phase(uvm_phase phase);
  fork
    get_and_drive(); 
    reset_signals(); 
  join
endtask : run_phase

// Manages the interaction between driver and sequencer
task axi_lite_wr_addr_slave_driver::get_and_drive();
  forever begin
    seq_item_port.get_next_item(trans);
      drive_transfer();
    seq_item_port.item_done();
  end
endtask : get_and_drive

// Reset the AWVALID signal when reset is observed
task axi_lite_wr_addr_slave_driver::reset_signals();
  forever begin
    @(negedge vif.reset_n);  // Wait for reset signal to go low
    uvm_report_info("AXI_WR_ADDR_SLAVE_DRIVER", "Reset observed", UVM_MEDIUM);
    vif.AWREADY <= 1'b0; 
  end
endtask : reset_signals

// Drive AWREADY in response to AWVALID from master
task axi_lite_wr_addr_slave_driver::drive_transfer();
  int delay_counter; 
  delay_counter = latency_value;

  wait (vif.AWVALID);

  while (delay_counter > 0) begin
    @(posedge vif.clk);
    delay_counter--;
  end

  @(posedge vif.clk) begin
    vif.AWREADY <= 1'b1;
  end

  wait (!vif.AWVALID);
  @(posedge vif.clk);
  vif.AWREADY <= 1'b0;
endtask : drive_transfer
