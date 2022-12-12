module counter_tb();
    reg clk;
    reg rst_n;
    reg cnt_en;
    wire [6:0] out;

    counter t_cnt(.clk(clk), .rst_n(rst_n), .cnt_en(cnt_en), .out(out));

    initial
    begin
        clk = 1;
	rst_n = 0;
        cnt_en = 0;
        #10 rst_n = 1;
        cnt_en = 1;
        #100 cnt_en = 0;
        #200 cnt_en = 1;
        #1000 cnt_en = 0;    
    end 

    always #10 clk = ~clk;
endmodule
