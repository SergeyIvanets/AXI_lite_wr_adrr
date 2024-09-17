class axi_lite_wr_addr_master_agent extends uvm_agent;
  `uvm_component_utils(axi_lite_wr_addr_master_agent)

  uvm_active_passive_enum is_active = UVM_ACTIVE;

  virtual axi_lite_wr_addr_if vif;
  axi_lite_wr_addr_slave_config cfg;

  axi_lite_wr_addr_master_driver driver;
  axi_lite_wr_addr_master_sequencer sequencer;
  axi_lite_wr_addr_master_monitor monitor;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : axi_lite_wr_addr_master_agent

//---------------------------------------------------------------------------------------
// IMPLEMENTATION
//---------------------------------------------------------------------------------------

function void axi_lite_wr_addr_master_agent::build_phase(uvm_phase phase);
super.build_phase(phase);

  if (!uvm_config_db#(axi_lite_wr_addr_master_config)::get(this, "", "cfg", cfg)) begin
    `uvm_fatal("NO_CFG", "Configuration object not set for the master agent.")
  end

  if (!uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active)) begin
    `uvm_warning("NO_CFG", "is_active not set for master agent. Defaulting to UVM_ACTIVE.")
    is_active = UVM_ACTIVE;
  end

  monitor = axi_lite_wr_addr_master_monitor::type_id::create("monitor", this);
  if (cfg.is_active == UVM_ACTIVE) begin
    sequencer = axi_lite_wr_addr_master_sequencer::type_id::create("sequencer", this);
    driver = axi_lite_wr_addr_master_driver::type_id::create("driver", this);
  end
endfunction : build_phase

function void axi_lite_wr_addr_master_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if (cfg.vif == null) begin
    `uvm_fatal("NO_VIF", "Master agent: Virtual interface not set in the configuration object.")
  end

  if (cfg.is_active == UVM_ACTIVE) begin
    driver.vif = cfg.vif;
    driver.seq_item_port.connect(sequencer.seq_item_export); 
  end

  monitor.vif = cfg.vif;
endfunction : connect_phase
