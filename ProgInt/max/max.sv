`timescale 1ns / 1ps

module max #(parameter N = 8)( 
	input [N-1:0] g_input,
	input [N-1:0] e_input,
	output [N-1:0] o
);	
	
	logic c;
	logic [N-1:0] dummy;
		
	SUB_ #(.N(N)) SUB_( 
		.A(g_input),
		.B(e_input),
		.O({c, dummy})
    );	
	
	MUX #(.N(N)) MUX(
		.A(g_input),
		.B(e_input),
		.S(c),
		.O(o)
	);

endmodule
