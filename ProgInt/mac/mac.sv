`timescale 1ns / 1ps



module mac #(parameter N = 8, M = N, L = 64)( 
	input					clk, rst,
	input	signed	[N-1:0] g_input,
	input	signed	[M-1:0] e_input,
	output	signed	[L-1:0]	o   
);

	logic	signed	[M+N-2:0]	product; 
	logic	signed	[L-1:0]	o_reg;
	logic	signed	[L:0]	o_1;
	
	always@(posedge clk or posedge rst) begin
		if(rst) o_reg <= {L{1'b0}};
		else o_reg <= o;
	end

	MULT_ #(.N(N), .M(M)) MULT_(
		.A(g_input),
		.B(e_input),
		.O(product)
	);	
	
	ADD_ #(.N(L), .M(M+N-1)) ADD_(
		.A(o_reg),
		.B(product),
		.O(o_1)
	); 
	
	assign o = o_1[L-1:0];

endmodule
