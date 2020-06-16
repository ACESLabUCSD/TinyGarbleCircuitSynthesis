`timescale 1ns / 1ps

module logic2 #(parameter N = 8, LOGIC = 0)(
	input	[N-1:0]	g_input,
	input	[N-1:0]	e_input,
	output	[N-1:0] o
);	 		
		
	generate
		if (LOGIC == 0) assign o = g_input & e_input;
		if (LOGIC == 1) assign o = g_input | e_input;
		if (LOGIC == 2) assign o = g_input ^ e_input;
	endgenerate	

endmodule