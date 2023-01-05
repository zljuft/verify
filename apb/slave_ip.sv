`include "macros.vh"

module slave_ip (
    apb_addr,
    apb_sel,
    apb_enable,
    apb_write,
    apb_rdata,
    apb_wdata,
    clk,
    rst
);

input bit   [`AWIDTH-1:0]   apb_addr;
input bit                   apb_sel;
input bit                   apb_enable;
input bit                   apb_write;
output reg  [`DWIDTH-1:0]   apb_rdata;
input logic [`DWIDTH-1:0]   apb_wdata;
input bit                   clk;
input wire                  rst;

bit [`DWIDTH-1:0] ram[0:255];

always @(posedge clk or negedge rst) begin
    if(rst === 0) ram <= '{256{'b0}};
    else if(apb_write && apb_sel && apb_enable) ram[apb_addr] <= apb_wdata;
end

always @(posedge clk) begin
    if(apb_sel && apb_enable && !apb_write)
        apb_rdata <= ram[apb_addr];
end
    
endmodule