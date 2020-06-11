`timescale 1ns / 1ps

module DIV_ #( parameter N = 8, M = N )( 
	input  [N-1:0] A,
	input  [M-1:0] B,
	output [N-1:0] O
);

	wire  	[N-1:0] A_; //-A
	wire  	[N-2:0] A__; //abs(A)
	wire  	[M-1:0] B_; //-B
	wire  	[M-2:0] B__; //abs(B)
	wire	[N-2:0] O_; //abs(O)
	wire	[N-1:0] O__; //-abs(O)
	
	TwosComplement #(.N(N)) TwosComplement_A( 
		.A(A),
		.O(A_)
    );
	 
	MUX #(.N(N-1)) MUX_A(
		.A(A[N-2:0]),
		.B(A_[N-2:0]),
		.S(A[N-1]),
		.O(A__)
	);
	
	TwosComplement #(.N(M)) TwosComplement_B( 
		.A(B),
		.O(B_)
    );
	 
	MUX #(.N(M-1)) MUX_B(
		.A(B[M-2:0]),
		.B(B_[M-2:0]),
		.S(B[M-1]),
		.O(B__)
	);
	
	DIV #(.N(N-1), .M(M-1)) DIV ( 
		.A(A__),
		.B(B__),
		.O(O_)
	);
	
	TwosComplement #(.N(N)) TwosComplement_O( 
		.A({1'b0, O_}),
		.O(O__)
    );
	 
	MUX #(.N(N)) MUX_O(
		.A({1'b0, O_}),
		.B(O__),
		.S(A[N-1]^B[M-1]),
		.O(O)
	);

endmodule
