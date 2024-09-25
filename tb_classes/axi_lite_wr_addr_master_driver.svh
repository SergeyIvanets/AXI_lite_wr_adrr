class axi_lite_wr_addr_master_driver extends uvm_driver #(axi_lite_wr_addr_transaction);
  `uvm_component_utils(axi_lite_wr_addr_master_driver)
  const string report_id="MASTER DRIVER";
  
  axi_lite_wr_addr_transaction trans;
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
function void axi_lite_wr_addr_master_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db #(virtual axi_lite_wr_addr_if)::get(this, get_full_name(), "axi_if", vif))
    `uvm_error(report_id, {"virtual interface must be set for: ", get_full_name(), ".vif"})
endfunction : connect_phase

task axi_lite_wr_addr_master_driver::run_phase(uvm_phase phase);
  fork
    get_and_drive();
    reset_signals();
  join
endtask : run_phase

task axi_lite_wr_addr_master_driver::get_and_drive();
  forever begin
    seq_item_port.get_next_item(trans);
    drive_transfer(trans);      
    seq_item_port.item_done();  
  end
endtask : get_and_drive

task axi_lite_wr_addr_master_driver::reset_signals();
  forever begin
    @(negedge vif.reset_n);  
    uvm_report_info(report_id, "Reset observed", UVM_MEDIUM);
    vif.AWVALID <= 1'b0;    
  end
endtask : reset_signals

task axi_lite_wr_addr_master_driver::drive_transfer(axi_lite_wr_addr_transaction trans);
  // Drive the transaction onto the AXI Lite interface
  @(posedge vif.clk);
  vif.AWADDR <= trans.AWADDR;
  vif.AWVALID <= 1'b1;

  wait (vif.AWREADY);
  @(posedge vif.clk);
  vif.AWVALID <= 1'b0;
endtask : drive_transfer
