`timescale 1ns / 1ps

module tb_mult_mnbit_1cc;

	parameter N = 8, M = N; 

	reg  [N-1:0] g_input, e_input;
	wire  [N+M-1:0] o;
	reg  [N+M-1:0] o_ref;
	reg  [N+M-1:0] err;

	  
	mult_mnbit_1cc #(.N(N)) uut( 
		.g_input(g_input),
		.e_input(e_input),
		.o(o)
	);

	always @(*) begin
		o_ref = g_input*e_input;
		err = o_ref - o;
	end

	always @(o) begin
		#10;
		$display("g_input = %H, e_input = %H, o = %H, o_ref = %H, error = %H\n", g_input, e_input, o, o_ref, err);
	end


	initial begin
		g_input =		{N{1'b1}};
		e_input =		{N{1'b1}};
		#100;
		g_input =		{N{1'b1}};
		e_input =		8'h47;
		#100;
		g_input =		{1'b0, g_input[N-1:1]};
		e_input =		8'h47;
		#100;
		g_input =		8'h42;
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
		g_input =		8'h64;
		#100;
		g_input =		{1'b0, g_input[N-1:1]};
		e_input =		8'h13;
		#100;
		$stop();
	end


endmodule