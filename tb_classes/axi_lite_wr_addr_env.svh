class axi_lite_wr_addr_env extends uvm_env;
  `uvm_component_utils(axi_lite_wr_addr_env)
  const string report_id="MASTER AGENT";

  axi_lite_wr_addr_master_agent master_agent;
  axi_lite_wr_addr_slave_agent slave_agent;
  axi_lite_wr_addr_master_config master_cfg;
  axi_lite_wr_addr_slave_config slave_cfg;
  axi_lite_wr_addr_scoreboard scoreboard;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : axi_lite_wr_addr_env

//---------------------------------------------------------------------------------------
// IMPLEMENTATION
//---------------------------------------------------------------------------------------

function void axi_lite_wr_addr_env::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  master_agent = axi_lite_wr_addr_master_agent::type_id::create("master_agent", this);
  slave_agent  = axi_lite_wr_addr_slave_agent::type_id::create("slave_agent", this);
  scoreboard = axi_lite_wr_addr_scoreboard::type_id::create("scoreboard", this);

  if (!uvm_config_db#(axi_lite_wr_addr_master_config)::get(this, "master_agent", "cfg", master_cfg)) begin
    `uvm_fatal(report_id, "Build phase. Master agent configuration not found.");
  end

  if (!uvm_config_db#(axi_lite_wr_addr_slave_config)::get(this, "slave_agent", "cfg", slave_cfg)) begin
    `uvm_fatal(report_id, "Build phase. Slave agent configuration not found.");
  end
endfunction : build_phase

function void axi_lite_wr_addr_env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  master_agent.cfg = master_cfg;
  slave_agent.cfg = slave_cfg;

  master_agent.monitor.item_collected_port.connect(scoreboard.master_analysis_export);
  slave_agent.monitor.item_collected_port.connect(scoreboard.slave_analysis_fifo.analysis_export);
endfunction : connect_phase