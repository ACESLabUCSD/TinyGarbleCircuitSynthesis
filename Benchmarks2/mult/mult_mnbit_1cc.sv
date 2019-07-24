`timescale 1ns / 1ps

module mult_mnbit_1cc #(parameter N = 8, M = N)( 
	input [N-1:0] g_input,
	input [M-1:0] e_input,
	output [N+M-1:0] o
);

	MULT #(.N(N), .M(M)) MULT(
		.A(g_input),
		.B(e_input),
		.O(o)
	);

endmodule
