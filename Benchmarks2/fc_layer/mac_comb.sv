`timescale 1ns / 1ps

module mac_comb #(parameter N = 8, K = 3)( //N: input bit-width, K: vector dimension
	input	signed	[N-1:0] 	A,
	input	signed	[N-1:0] 	B,
	input	signed	[2*N+K-2:0]	S0,
	output	signed	[2*N+K-2:0]	S
);

	logic	signed	[2*N-1:0]	P;
	logic	signed	[2*N+K-1:0]	S_;

	MULT_ #(.N(N), .M(N)) MULT_(
		.A(A),
		.B(B),
		.O(P)
	);	
	
	ADD_ #(.N(2*N+K-1), .M(2*N)) ADD_(
		.A(S0),
		.B(P),
		.O(S_)
	); 
	
	assign S = S_[2*N+K-2:0];

endmodule
