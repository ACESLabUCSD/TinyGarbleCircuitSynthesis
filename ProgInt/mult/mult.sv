`timescale 1ns / 1ps

module mult #(parameter N = 8)( 
	input [N-1:0] g_input,
	input [N-1:0] e_input,
	output [N-1:0] o
);	
	logic [2*N-2:0] o_2;
	
	MULT_ #(.N(N)) MULT_( 
		.A(g_input),
		.B(e_input),
		.O(o_2)
	);
	
	assign o = o_2[N-1:0];

endmodule
