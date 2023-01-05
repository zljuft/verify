`include "macros.vh"
`include "apb_if.sv"
`include "slave_ip.sv"
`include "pgm_test.sv"

import uvm_pkg::*;
import apb_pkg::*;

module top;
    timeunit 1ns;
    timeprecision 1ns;

    bit clk = 0;

    apb_if intf_apb(clk);

    slave_ip dut(
        .apb_addr(intf_apb.addr),
        .apb_sel(intf_apb.sel),
        .apb_enable(intf_apb.enable),
        .apb_write(intf_apb.write),
        .apb_rdata(intf_apb.rdata),
        .apb_wdata(intf_apb.wdata),
        .clk(clk),
        .rst(intf_apb.reset_n)
    );

    pgm_test pgm_test_inst(intf_apb);
    
    always #5 clk = ~clk;

    initial begin
        // uvm_config_db#(virtual apb_if.master)::set(null, "uvm_test_top", "drvr_if", intf_apb.master);
        // uvm_config_db#(virtual apb_if.iMon)::set(null, "uvm_test_top", "iMon_if", intf_apb.iMon);
        // uvm_config_db#(virtual apb_if.oMon)::set(null, "uvm_test_top", "oMon_if", intf_apb.oMon);

        // run_test("apb_test");
        // $dumpfile("dump.vcd");$dumpvars;
    end
endmodule