`ifndef APB_IF__SV
`define APB_IF__SV

interface apb_if(input clk);

    logic           reset_n;
    logic [31:0]    addr;
    logic           write;
    logic           sel;
    logic           ready;
    logic           enable;
    logic [31:0]    wdata;
    logic [31:0]    rdata;
    logic           slvERR;

    //Master clocking
    clocking cb_master @(posedge clk);
        output sel, ready, enable, write, addr, wdata;
        input #0 rdata;
        input slvERR;
    endclocking

    //Slave clocking
    clocking cb_slave @(posedge clk);
        input sel, ready, enable, write, addr, wdata;
        output rdata, slvERR;
    endclocking

    //input monitor
    clocking cb_imon @(posedge clk);
        input sel, enable, ready, write, addr, wdata, rdata;
    endclocking

    //output monitor
    clocking cb_omon @(posedge clk);
        input addr, rdata;
    endclocking

    modport master (clocking cb_master, output reset_n);
    modport slave  (clocking cb_slave, output reset_n);
    modport iMon   (clocking cb_imon);
    modport oMon   (clocking cb_omon);
endinterface

`endif