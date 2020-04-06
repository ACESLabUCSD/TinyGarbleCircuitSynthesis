`timescale 1ns / 1ps

module lt #(parameter N = 8)(
	input	[N-1:0]	g_input,
	input	[N-1:0]	e_input,
	output	o
);	 		
	logic [N-1:0] dummy;
		
	SUB_ #(.N(N)) SUB_( 
		.A(g_input),
		.B(e_input),
		.O({o, dummy})
    );	

endmodule