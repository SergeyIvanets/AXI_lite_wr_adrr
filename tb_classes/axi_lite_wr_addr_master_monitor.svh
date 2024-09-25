class axi_lite_wr_addr_master_monitor extends uvm_monitor;
  `uvm_component_utils(axi_lite_wr_addr_master_monitor)
  const string report_id="MASTER MONITOR";

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

endclass : axi_lite_wr_addr_master_monitor

//---------------------------------------------------------------------------------------
// IMPLEMENTATION
//---------------------------------------------------------------------------------------

function void axi_lite_wr_addr_master_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db #(virtual axi_lite_wr_addr_if)::get(this, "", "axi_if", vif)) begin
    `uvm_fatal(report_id, "Virtual interface not set for the master monitor.")
  end
endfunction : connect_phase

task axi_lite_wr_addr_master_monitor::run_phase(uvm_phase phase);
  axi_lite_wr_addr_transaction trans_collected;
  logic [31:0] temp_addr;

  forever begin
    @(posedge vif.clk);    
    if (vif.AWVALID) begin
      trans_collected = axi_lite_wr_addr_transaction::type_id::create("trans_collected");
      temp_addr = vif.AWADDR;
      if (vif.AWREADY) begin
        if (temp_addr == vif.AWADDR) begin
          trans_collected.AWADDR  = vif.AWADDR;
          item_collected_port.write(trans_collected);
          `uvm_info(report_id, $sformatf("Transfer collected master monitor:\n%s",
                    trans_collected.sprint()), UVM_HIGH);
        end 
        else begin
          `uvm_error(report_id, "Address changed during AXI write transaction");
        end
      end
      num_transactions++;
    end
  end
endtask : run_phase

function void axi_lite_wr_addr_master_monitor::report_phase(uvm_phase phase);
  `uvm_info(report_id, $sformatf("Report: Master monitor collected %0d transfers", 
            num_transactions), UVM_LOW);
endfunction : report_phase
