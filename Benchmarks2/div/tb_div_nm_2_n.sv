`timescale 1ns / 1ps

module tb_div_nm_2_n;

	parameter N = 32, M = 28; 

	logic signed [N-1:0] g_input;
	logic signed [M-1:0] e_input;
	logic signed [N-1:0] o, o_ref;
	logic signed [N:0] err;

	  
	div_nm_2_n #(.N(N), .M(M)) uut( 
		.g_input(g_input),
		.e_input(e_input),
		.o(o)
	);

	always @(*) begin
		o_ref = g_input/e_input;
		err = o_ref - o;
	end

	always @(o) begin
		#10;
		$display("g_input = %d, e_input = %d, o = %d, o_ref = %d, error = %d\n", g_input, e_input, o, o_ref, err);
	end


	initial begin
		g_input =		{N{1'b1}};
		e_input =		{M{1'b1}};
		#100;
		g_input =		{N{1'b1}};
		e_input =		8'h47;
		#100;
		g_input =		{1'b0, g_input[N-1:1]};
		e_input =		-8'h47;
		#100;
		g_input =		-8'h42;
		e_input =		8'h47;
		#100;
		g_input =		8'h47;
		e_input =		8'h47;
		#100;
		g_input =		{1'b0, g_input[N-1:1]};
		e_input =		8'h47;
		#100;
		e_input =		8'h47;
		#100;
		g_input =		-8'h64;
		#100;
		g_input =		{1'b0, g_input[N-1:1]};
		e_input =		8'h13;
		#100;
		$stop();
	end


endmodule