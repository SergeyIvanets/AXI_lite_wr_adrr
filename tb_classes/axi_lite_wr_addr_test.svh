`timescale 100ps/100ps 
class axi_lite_wr_addr_test extends uvm_test;
  `uvm_component_utils(axi_lite_wr_addr_test)

  parameter LATENCY = 3;      // Define parameter for latency
  int TRANS_COUNT = 10; // after radomize with constraint

  axi_lite_wr_addr_env env;
  virtual axi_lite_wr_addr_if vif;
  axi_lite_wr_addr_master_config master_cfg;
  axi_lite_wr_addr_slave_config slave_cfg;

  function new(string name = "axi_lite_wr_addr_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass : axi_lite_wr_addr_test

//---------------------------------------------------------------------------------------
// IMPLEMENTATION 
//---------------------------------------------------------------------------------------

function void axi_lite_wr_addr_test::build_phase(uvm_phase phase);
  super.build_phase(phase);

  uvm_config_db #(int)::set(null, "*", "LATENCY", LATENCY);
  `uvm_info("", $sformatf("The value of LATENCY is: %0d", LATENCY), UVM_LOW);

  uvm_config_db#(int)::set(this, "*", "TRANS_COUNT", TRANS_COUNT);
  `uvm_info("", $sformatf("The value of  TRANS_COUNT is: %0d", TRANS_COUNT), UVM_LOW);

  if (!uvm_config_db#(virtual axi_lite_wr_addr_if)::get(this, "", "axi_if", vif)) begin
    `uvm_fatal(":", "Virtual interface not found.");
  end

  env = axi_lite_wr_addr_env::type_id::create("env", this);

  master_cfg = axi_lite_wr_addr_master_config::type_id::create("master_cfg", this);
  master_cfg.is_active = UVM_ACTIVE;
  master_cfg.vif = vif;
  uvm_config_db#(axi_lite_wr_addr_master_config)::set(this, "env.master_agent", "cfg", master_cfg);

  slave_cfg = axi_lite_wr_addr_slave_config::type_id::create("slave_cfg", this);
  slave_cfg.is_active = UVM_ACTIVE;  
  slave_cfg.vif = vif;
  uvm_config_db#(axi_lite_wr_addr_slave_config)::set(this, "env.slave_agent", "cfg", slave_cfg);
  
  `uvm_info("", $sformatf("Build phase done"), UVM_LOW);

endfunction : build_phase



task axi_lite_wr_addr_test::run_phase(uvm_phase phase);
    axi_lite_wr_addr_master_sequence master_seq;
    axi_lite_wr_addr_slave_sequence slave_seq;

    phase.raise_objection(this);

    master_seq = axi_lite_wr_addr_master_sequence::type_id::create("master_seq");
    fork
      master_seq.start(env.master_agent.sequencer);
    join_none

    slave_seq = axi_lite_wr_addr_slave_sequence::type_id::create("slave_seq");
    fork
      slave_seq.start(env.slave_agent.sequencer);
    join_none

    #1000ns;

    phase.drop_objection(this);
endtask : run_phase


