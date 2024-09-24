class axi_lite_wr_addr_master_config extends uvm_object;
  `uvm_object_utils(axi_lite_wr_addr_master_config)
  const string report_id="MASTER CONFIG";

  uvm_active_passive_enum is_active;
  virtual axi_lite_wr_addr_if vif; 

  function new(string name = "axi_lite_wr_addr_master_config");
    super.new(name);
    is_active = UVM_ACTIVE;  // Default to active mode
  endfunction : new

  function void print_config();
    `uvm_info(report_id, $sformatf("is_active: %0s", (is_active == UVM_ACTIVE) ? "UVM_ACTIVE" : "UVM_PASSIVE"), UVM_MEDIUM)
  endfunction
endclass : axi_lite_wr_addr_master_config
