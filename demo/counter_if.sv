`ifndef COUNTER_IF__SV
`define COUNTER_IF__SV

interface counter_if(input clk);
    logic rst_n;
    logic cnt_en;
    logic [7:0] data;
endinterface

`endif