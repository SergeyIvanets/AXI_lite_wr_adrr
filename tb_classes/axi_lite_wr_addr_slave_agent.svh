class axi_lite_wr_addr_slave_agent extends uvm_agent;
  `uvm_component_utils(axi_lite_wr_addr_slave_agent)
  const string report_id="SLAVE AGENT";

  uvm_active_passive_enum is_active = UVM_ACTIVE;

  virtual axi_lite_wr_addr_if vif;
  axi_lite_wr_addr_slave_config cfg;

  axi_lite_wr_addr_slave_driver driver;
  axi_lite_wr_addr_slave_sequencer sequencer;
  axi_lite_wr_addr_slave_monitor monitor;

  int t_trans_count;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : axi_lite_wr_addr_slave_agent

//---------------------------------------------------------------------------------------
// IMPLEMENTATION
//---------------------------------------------------------------------------------------

function void axi_lite_wr_addr_slave_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(axi_lite_wr_addr_slave_config)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal("build_phase", "Slave agent: Unable to get config from uvm_config_db");
    end
    
    vif = cfg.vif;

    monitor = axi_lite_wr_addr_slave_monitor::type_id::create("monitor", this);
    if (is_active == UVM_ACTIVE) begin
        sequencer = axi_lite_wr_addr_slave_sequencer::type_id::create("sequencer", this);
        driver = axi_lite_wr_addr_slave_driver::type_id::create("driver", this);

        if (!uvm_config_db#(int)::get(this, "", "TRANS_COUNT", t_trans_count)) begin
          `uvm_fatal(report_id, "TRANS_COUNT not set in the UVM config DB");
        end
        sequencer.trans_count = t_trans_count;
    end
endfunction : build_phase

function void axi_lite_wr_addr_slave_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (cfg.vif == null) begin
        `uvm_fatal("NO_VIF", "Slave agent: Virtual interface not set in the configuration object.")
    end

    if (cfg.is_active == UVM_ACTIVE) begin
        driver.vif = cfg.vif;
        driver.seq_item_port.connect(sequencer.seq_item_export);  
    end

    monitor.vif = cfg.vif;
endfunction : connect_phase

