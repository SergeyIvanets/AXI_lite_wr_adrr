class axi_lite_wr_addr_slave_monitor extends uvm_monitor;
  `uvm_component_utils(axi_lite_wr_addr_slave_monitor)

  virtual axi_lite_wr_addr_if vif;

  uvm_analysis_port #(axi_lite_wr_addr_transaction) item_collected_port;
  int unsigned num_transactions = 0;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction
  
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void report_phase(uvm_phase phase);

endclass : axi_lite_wr_addr_slave_monitor

//---------------------------------------------------------------------------------------
// IMPLEMENTATION
//---------------------------------------------------------------------------------------

function void axi_lite_wr_addr_slave_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db #(virtual axi_lite_wr_addr_if)::get(this, "", "axi_if", vif)) begin
      `uvm_fatal("NOVIF", "Virtual interface not set for the slave monitor.")
    end
  endfunction : connect_phase

  task axi_lite_wr_addr_slave_monitor::run_phase(uvm_phase phase);
    axi_lite_wr_addr_transaction trans_collected;

    forever begin
      @(posedge vif.clk);
      if (vif.AWVALID) begin
        // Create a new transaction to store observed values
        trans_collected = axi_lite_wr_addr_transaction::type_id::create("trans_collected");
        trans_collected.AWADDR  = vif.AWADDR;
        `uvm_info(get_type_name(), $sformatf("AWADDR collected by slave monitor:%h", trans_collected.AWADDR), UVM_LOW);


        item_collected_port.write(trans_collected);

        `uvm_info(get_type_name(), $sformatf("Transfer collected slave monitor:\n%s",
                                            trans_collected.sprint()), UVM_HIGH);
        num_transactions++;
      end
    end
  endtask : run_phase

  function void axi_lite_wr_addr_slave_monitor::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("Report: Slave monitor collected %0d transfers", 
                                        num_transactions), UVM_LOW);
endfunction : report_phase  