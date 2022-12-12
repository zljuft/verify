`timescale 1ns/1ps
module counter(
    input clk,
    input rst_n,
    input cnt_en,
    output reg [7:0] out
);
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n) begin
            out<=8'b0;
        end
        else if(cnt_en) begin
            if(out != 10) begin
		out<=out + 1'b1;
            end
            else begin
                out<=8'b0;
            end
        end
        else begin
            out<=8'b0;
        end
    end
endmodule
