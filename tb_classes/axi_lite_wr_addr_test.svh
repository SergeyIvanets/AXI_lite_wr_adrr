class axi_lite_wr_addr_test extends uvm_test;
  `uvm_component_utils(axi_lite_wr_addr_test)
  
  parameter LATENCY = 3;      // Define parameter for latency

  int transaction_count = 10; // after radomize with constraint

  // Environment instance
  axi_lite_wr_addr_env env;

  function new(string name = "axi_lite_wr_addr_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task void run_phase(uvm_phase phase);
endclass : axi_lite_wr_addr_test

//---------------------------------------------------------------------------------------
// IMPLEMENTATION
//---------------------------------------------------------------------------------------

function void axi_lite_wr_addr_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  env = axi_lite_wr_addr_env::type_id::create("env", this);

  // Pass LATENCY value to UVM components
  uvm_config_db #(int)::set(null, "*", "LATENCY", LATENCY);  

endfunction : build_phase


task void axi_lite_wr_addr_test::run_phase(uvm_phase phase);
    axi_lite_wr_addr_master_sequence master_seq;
    axi_lite_wr_addr_slave_sequence slave_seq;

    phase.raise_objection(this);

    master_seq = axi_lite_wr_addr_master_sequence::type_id::create("master_seq");
    master_seq.trans_count = transaction_count;  
    fork
      master_seq.start(env.master_agent.sequencer);
    join_none

    slave_seq = axi_lite_wr_addr_slave_sequence::type_id::create("slave_seq");
    slave_seq.trans_count = transaction_count;
    fork
      slave_seq.start(env.slave_agent.sequencer);
    join_none

    #1000ns;

    phase.drop_objection(this);
endtask : run_phase


