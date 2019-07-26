`timescale 1ns / 1ps

module maxpool_nbit_kdim_kcc #(parameter N = 8)(
	input			clk, rst,
	input	[N-1:0]	s_input,
	output	[N-1:0]	o
);	

	logic	[N-1:0]	o_reg;
	logic			sel;
	
	always@(posedge clk or posedge rst) begin
		if(rst) o_reg <= {N{1'b0}};
		else o_reg <= o;
	end		
	 
	COMP #(.N(N)) COMP( //A >= B => O = 1;
		.A(s_input),
		.B(o_reg),
		.O(sel)
	);
	
	MUX #(.N(N)) MUX(
		.A(o_reg),
		.B(s_input),
		.S(sel),
		.O(o)
);

endmodule