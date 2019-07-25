`include "../Headers/Common_H.vh"
`timescale 1ns / 1ps

module hamming #( parameter N=8, CC=1, M = N/CC)(
	input					clk, rst,
	input	[M-1:0] 		g_input,
	input	[M-1:0] 		e_input,
	output	[log2(N)-1:0] 	o
);

	parameter logM = (log2(M) > 0)? log2(M): 1;

	logic	[log2(N)-1:0] 	oglobal;
	logic 	[logM-1:0] 	olocal;
	logic	[M-1:0] 		xy;	

	assign xy = g_input^e_input;
	
	COUNT #(.N(M)) COUNT_ (
		.A(xy),
		.S(olocal) 
	);

	generate
		if(CC>1) begin
			ADD #( .N(log2(N))) ADD_ (
				.A(oglobal),
				.B({{(log2(N) - log2(M)){1'b0}}, olocal}),
				.CI(1'b0),
				.S(o),
				.CO()
			);

			always@(posedge clk or posedge rst) begin
				if(rst) oglobal <= 0;
				else oglobal <= o;
			end
		end
		else begin
			assign o = olocal;
			always@(*)
			begin
				oglobal <= 'b0;
			end
		end
	endgenerate

	

endmodule


