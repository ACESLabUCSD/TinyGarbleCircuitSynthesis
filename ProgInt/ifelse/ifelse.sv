`timescale 1ns / 1ps

module ifelse #(parameter N = 8)( 
	input [2*N-1:0] g_input,
	input [0:0] e_input,
	output [N-1:0] o
);	
	
	MUX #(.N(N)) MUX(
		.A(g_input[N-1:0]),
		.B(g_input[2*N-1:N]),
		.S(e_input),
		.O(o)
	);

endmodule
