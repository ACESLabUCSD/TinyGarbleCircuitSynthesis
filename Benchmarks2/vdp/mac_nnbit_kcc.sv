`timescale 1ns / 1ps

module mac_nnbit_kcc #(parameter N = 8, K = 3)( //N: input bit-width, K: vector dimension
	input						clk, rst,
	input	signed	[N-1:0] 	g_input,
	input	signed	[N-1:0] 	e_input,
	output	signed	[2*N+K-2:0]	o
);

	logic	signed	[2*N-1:0]	product;
	logic	signed	[2*N+K-2:0]	o_reg;
	logic	signed	[2*N+K-1:0]	o_1;
	
	always@(posedge clk or posedge rst) begin
		if(rst) o_reg <= {(2*N+K-1){1'b0}};
		else o_reg <= o;
	end

	MULT_ #(.N(N), .M(N)) MULT_(
		.A(g_input),
		.B(e_input),
		.O(product)
	);	
	
	ADD_ #(.N(2*N+K-1), .M(2*N)) ADD_(
		.A(o_reg),
		.B(product),
		.O(o_1)
	); 
	
	assign o = o_1[2*N+K-2:0];

endmodule
