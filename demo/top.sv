`ifndef TOP__SV
`define TOP__SV

import uvm_pkg::*;

`include "dut.v"
`include "counter_item.sv"
`include "counter_if.sv"
`include "counter_driver.sv"
`include "counter_monitor.sv"
`include "counter_scoreboard.sv"
`include "counter_agent.sv"

`include "counter_env.sv"
`include "counter_sequence.sv"
`include "base_test.sv"
`include "counter_case0.sv"

module tb;
    reg clk;
    always #10 clk = ~clk;

    counter_if cif(clk);

    counter cnt(.clk(clk), .rst_n(cif.rst_n), .cnt_en(cif.cnt_en), .out(cif.data));

    initial begin
        clk <= 0;
        uvm_config_db#(virtual counter_if)::set(null, "", "counter_vif", cif);//uvm_test_top.*
        run_test("counter_case0");
    end


endmodule

`endif