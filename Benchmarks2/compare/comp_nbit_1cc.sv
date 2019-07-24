`timescale 1ns / 1ps

module comp_nbit_1cc #(parameter N = 8)(
	input	[N-1:0]	g_input,
	input	[N-1:0]	e_input,
	output		 	o
);	 
	 
	SUB #(.N(N)) SUB_(
		.A(g_input),
		.B(e_input),
		.S(), 
		.CO(o)
	);

endmodule