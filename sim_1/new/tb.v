`timescale 1ns / 1ps

module tb();

    reg reset, clk;
    wire [11 : 0] digits;

    MYCPU TEST(
        .clk(clk),
        .reset(reset),
        .leds(digits)
    );

    initial begin
        reset   = 1;
		clk     = 1;
		#1000 reset = 0;
    end

    always #50 clk = ~clk;


endmodule
