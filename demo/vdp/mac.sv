`timescale 1ns / 1ps

module mac_TG #(parameter N = 8, M = N, L = 64)( 
	input			clk, rst,
	input	signed	[N-1:0] g_input,
	input	signed	[M-1:0] e_input,
	output	signed	[L-1:0]	o   
);

	mac #(.N(N), .M(M), .L(L)) mac (
		.clk(clk), .rst(rst),
		.A(g_input),
		.B(e_input),
		.Y(o) 	
	);

endmodule

module mac #(parameter N = 8, M = N, L = 64)( 
	input			clk, rst,
	input	signed	[N-1:0] A,
	input	signed	[M-1:0] B,
	output	signed	[L-1:0]	Y   
);

	logic	signed	[M+N-2:0]	product; 
	logic	signed	[L-1:0]	Y_reg;
	logic	signed	[L:0]	Y_1;
	
	always@(posedge clk or posedge rst) begin
		if(rst) Y_reg <= {L{1'b0}};
		else Y_reg <= Y;
	end

	MULT_ #(.N(N), .M(M)) MULT_(
		.A(A),
		.B(B),
		.O(product)
	);	
	
	ADD_ #(.N(L), .M(M+N-1)) ADD_(
		.A(Y_reg),
		.B(product),
		.O(Y_1)
	); 
	
	assign Y = Y_1[L-1:0];

endmodule