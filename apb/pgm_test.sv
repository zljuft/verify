`include "apb_pkg.sv"

program automatic pgm_test(apb_if pif);
    import uvm_pkg::*;
    import apb_pkg::*;

    `include "apb_test.sv"

    initial begin
        $timeformat(-9, 1, "ns", 10);
        uvm_config_db#(virtual apb_if.master)::set(null, "uvm_test_top", "drvr_if", pif.master);
        uvm_config_db#(virtual apb_if.iMon)::set(null, "uvm_test_top", "iMon_if", pif.iMon);
        uvm_config_db#(virtual apb_if.oMon)::set(null, "uvm_test_top", "oMon_if", pif.oMon);

        run_test("apb_test");
    end
endprogram