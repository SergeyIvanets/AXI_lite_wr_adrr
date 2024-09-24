class axi_lite_wr_addr_slave_config extends uvm_object;
  `uvm_object_utils(axi_lite_wr_addr_slave_config)
  const string report_id="SLAVE CONFIG";

  uvm_active_passive_enum is_active;
  virtual axi_lite_wr_addr_if vif;  
  int LATENCY;  

  function new(string name = "axi_lite_wr_addr_slave_config");
      super.new(name);
      is_active = UVM_ACTIVE;  
      LATENCY = 5;  
  endfunction : new

  function void print_config();
      `uvm_info(report_id, $sformatf("is_active: %0s, LATENCY: %0d", (is_active == UVM_ACTIVE) ? "UVM_ACTIVE" : "UVM_PASSIVE", LATENCY), UVM_MEDIUM)
  endfunction
endclass : axi_lite_wr_addr_slave_config