`timescale 1ns / 1ps

module sum_nbit_ncc(
	input	clk, rst,
	input	g_input,
	input	e_input,
	output	o
);	

	logic carry, carry_d;
	always@(posedge clk or posedge rst)
		if(rst) carry <= 1'b0;
		else carry <= carry_d;
	 
	ADD #(.N(1)) ADD(
		.A(g_input),
		.B(e_input),
		.CI(carry),
		.S(o), 
		.CO(carry_d)
	);

endmodule