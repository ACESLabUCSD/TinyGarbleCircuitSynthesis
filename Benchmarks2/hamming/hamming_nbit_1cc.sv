`include "../Headers/Common_H.vh"
`timescale 1ns / 1ps

module hamming_nbit_1cc #( parameter N=8, CC=1, M = N/CC)(
	input					clk, rst,
	input	[M-1:0] 		g_input,
	input	[M-1:0] 		e_input,
	output	[log2(N)-1:0] 	o
);

	parameter logM = (log2(M) > 0)? log2(M): 1;
	
	logic	[M-1:0] 		xy;	
	assign xy = g_input^e_input;
	
	COUNT #(.N(M)) COUNT_ (
		.A(xy),
		.S(o) 
	);

	

endmodule


