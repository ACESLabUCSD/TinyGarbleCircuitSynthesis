`timescale 1ns / 1ps

module mult_n_2_2n #(parameter N = 8, M = N)( 
	input signed [N-1:0] g_input,
	input signed [M-1:0] e_input,
	output signed [N+M-2:0] o
);

	MULT_ #(.N(N), .M(M)) MULT_(
		.A(g_input),
		.B(e_input),
		.O(o)
	);

endmodule
