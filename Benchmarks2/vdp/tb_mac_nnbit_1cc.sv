`timescale 1ns / 1ps

module tb_mac_nnbit_1cc;

	parameter N = 8, K = 1; 

	logic						clk, rst;
	logic	signed	[N-1:0] 	g_input;
	logic	signed	[N-1:0] 	e_input;
	logic	signed	[2*N+K-2:0]	o, o_ref;

	mac_nnbit_kcc #(.N(N), .K(K)) uut( //N: input bit-width, K: vector dimension
		.clk(clk), .rst(rst),
		.g_input(g_input),
		.e_input(e_input),
		.o(o)
	);

	assign o_ref = g_input*e_input;

	always #50 clk = ~clk;

	initial begin
		clk <= 1;
		
		g_input = 'd23;
		e_input = 'd99;
		rst <= 1;
		@(negedge clk);
		rst <= 0;
		$display("g_input = %d, e_input = %d, o = %d, o_ref = %d", g_input, e_input, o, o_ref);	
		@(posedge clk);
		
		g_input = 'd23;
		e_input = -'d99;
		rst <= 1;
		@(negedge clk);
		rst <= 0;
		$display("g_input = %d, e_input = %d, o = %d, o_ref = %d", g_input, e_input, o, o_ref);	
		@(posedge clk);
		
		g_input = -'d23;
		e_input = 'd99;
		rst <= 1;
		@(negedge clk);
		rst <= 0;
		$display("g_input = %d, e_input = %d, o = %d, o_ref = %d", g_input, e_input, o, o_ref);	
		@(posedge clk);
		
		g_input = -'d23;
		e_input = -'d99;
		rst <= 1;
		@(negedge clk);
		rst <= 0;
		$display("g_input = %d, e_input = %d, o = %d, o_ref = %d", g_input, e_input, o, o_ref);	
		@(posedge clk);
		
		$stop();
	end

endmodule