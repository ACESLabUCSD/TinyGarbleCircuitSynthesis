`timescale 1ns / 1ps

module comp_nbit_1cc #(parameter N = 8)(
	input	[N-1:0]	g_input,
	input	[N-1:0]	e_input,
	output		 	o
);	 
	 
	COMP #(.N(N)) COMP(
		.A(g_input),
		.B(e_input),
		.O(o)
	);

endmodule