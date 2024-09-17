class axi_lite_wr_addr_env extends uvm_env;
  `uvm_component_utils(axi_lite_wr_addr_env)

  axi_lite_wr_addr_master_agent master_agent;
  axi_lite_wr_addr_slave_agent slave_agent;
  axi_lite_wr_addr_scoreboard scoreboard;

  virtual axi_lite_wr_addr_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : axi_lite_wr_addr_env

//---------------------------------------------------------------------------------------
// IMPLEMENTATION
//---------------------------------------------------------------------------------------

function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db #(virtual axi_lite_wr_addr_if)::get(this, "", "vif", vif)) begin
    `uvm_fatal("NO_VIF", "Virtual interface not set for the environment.")
  end

  master_agent = axi_lite_wr_addr_master_agent::type_id::create("master_agent", this);
  slave_agent  = axi_lite_wr_addr_slave_agent::type_id::create("slave_agent", this);
  scoreboard = axi_lite_wr_addr_scoreboard::type_id::create("scoreboard", this);
endfunction : build_phase

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  master_agent.vif = vif;
  slave_agent.vif  = vif;

  master_agent.monitor.item_collected_port.connect(scoreboard.master_analysis_export);
  slave_agent.monitor.item_collected_port.connect(scoreboard.slave_analysis_export);
endfunction : connect_phase