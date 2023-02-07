`ifndef REG_PKG__SV
`define REG_PKG__SV

package reg_pkg;
    import uvm_pkg::*;
    `include "reg_item.sv"
    `include "reg_sequence.sv"
    `include "reg_driver.sv"
    `include "reg_monitor.sv"
    `include "reg_agent.sv"
    `include "reg_adapter.sv"
    `include "reg_regs.sv"
    `include "reg_env.sv"
    `include "reg_test_env.sv"
endpackage


`endif