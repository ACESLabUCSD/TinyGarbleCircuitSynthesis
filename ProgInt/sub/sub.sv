`timescale 1ns / 1ps

module sub #(parameter N = 8)(
	input	[N-1:0]	g_input,
	input	[N-1:0]	e_input,
	output	[N-1:0] o
);	 		
	logic dummy;
		
	SUB_ #(.N(N)) SUB_( 
		.A(g_input),
		.B(e_input),
		.O({dummy, o})
    );	

endmodule