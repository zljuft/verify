`include "bus_if.sv"
`include "reg_pkg.sv"
`include "traffic.sv"
`include "reg_test.sv"

// import uvm_pkg::*;
import reg_pkg::*;

module reg_top ;
    bit clk = 0;

    bus_if  vif(clk);

    always #5 clk = !clk;

    initial begin
        $vcdpluson;
    end

    initial begin
        uvm_config_db#(virtual bus_if)::set(null, "uvm_test_top.*", "bus_if", vif);
        run_test("reg_rw_test");
        #1000 $finish;
    end

    traffic ins(
        .pclk(clk),
        .presetn(vif.presetn),
        .paddr(vif.paddr),
        .pwdata(vif.pwdata),
        .psel(vif.psel),
        .pwrite(vif.pwrite),
        .penable(vif.penable),
        .prdata(vif.prdata)
    );

endmodule