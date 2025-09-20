module PLL(clk_out1, reset, locked, clk_in1);
	output clk_out1;
	
	input reset;
	output locked;
	input clk_in1;
	
	clk_wiz_0 clkwiz(
		.clk_out1(clk_out1),
		.reset(reset),
		.locked(locked),
		.clk_in1(clk_in1)
	);
