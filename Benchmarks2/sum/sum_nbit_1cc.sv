`timescale 1ns / 1ps

module sum_nbit_1cc #(parameter N = 8)(
	input	[N-1:0]	g_input,
	input	[N-1:0]	e_input,
	output	[N:0] 	o
);	 
	 
	ADD #(.N(N)) ADD(
		.A(g_input),
		.B(e_input),
		.CI(1'b0),
		.S(o[N-1:0]), 
		.CO(o[N])
);

endmodule