`timescale 1ns / 1ps

module mac_comb #(parameter N = 8, K = 3, L = 2*(N-1)+K)( //N: input bit-width, K: vector dimension
	input	signed	[N-1:0] A,
	input	signed	[N-1:0] B,
	input	signed	[L-1:0]	S0,
	output	signed	[L-1:0]	S
);

	logic	signed	[2*N-2:0]	P;
	logic	signed	[L:0]		S_;

	MULT_ #(.N(N), .M(N)) MULT_(
		.A(A),
		.B(B),
		.O(P)
	);	
	
	ADD_ #(.N(L), .M(2*N-1)) ADD_(
		.A(S0),
		.B(P),
		.O(S_)
	); 
	
	assign S = S_[L-1:0];

endmodule
