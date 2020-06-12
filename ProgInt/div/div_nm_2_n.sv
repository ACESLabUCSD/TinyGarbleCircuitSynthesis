`timescale 1ns / 1ps

module div_nm_2_n #(parameter N = 8, M = N)( 
	input signed [N-1:0] g_input,
	input signed [M-1:0] e_input,
	output signed [N-1:0] o
);

	DIV_ #(.N(N), .M(M)) DIV_(
		.A(g_input),
		.B(e_input),
		.O(o)
	);

endmodule
