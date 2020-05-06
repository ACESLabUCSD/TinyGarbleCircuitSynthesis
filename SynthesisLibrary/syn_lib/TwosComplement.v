`timescale 1ns / 1ps

module TwosComplement #(parameter N = 8)(
	input [N-1:0] A,
	output [N-1:0] O
);

	ADD #(.N(N)) ADD(
		.A(~A),
		.B({N{1'b0}}),
		.CI(1'b1),
		.S(O), 
		.CO()
	);


endmodule

module signRecover #(parameter N = 8)(
	input [N-1:0] A,
	input s,
	output [N-1:0] O
);

	ADD #(.N(N)) ADD(
		.A(A^{N{s}}),
		.B({N{1'b0}}),
		.CI(s),
		.S(O),
		.CO()
	);


endmodule
