`timescale 1ns / 1ps

module tb_comp_nbit_ncc;

	logic clk, rst;
	logic g_input;
	logic e_input;
	logic o;

	comp_nbit_ncc uut( 
		.clk(clk), .rst(rst),
		.g_input(g_input),
		.e_input(e_input),
		.o(o)
	);	
	
	parameter N = 8;
	
	logic	[N-1:0]	G;
	logic	[N-1:0]	E;
	logic 	[2:0]	O, O_ref; 
	
	always #50 clk = ~clk;
	
	integer k;
	
	initial begin
		clk = 'b0;
		
		G = 'hA9;
		E = 'h7B;
		$display("G = %H, E = %H", G, E);	
		O_ref[0] = (G < E)? 1'b0:1'b1;
		rst = 'b1;
		@(posedge clk)
		rst = 'b0;
		for (k = 0; k < N; k = k + 1) begin
			g_input = G[k];
			e_input = E[k];
			@(posedge clk);			
		end
		O[0] = o;
		
		G = 'h74;
		E = 'hFD;
		$display("G = %H, E = %H", G, E);
		O_ref[1] = (G < E)? 1'b0:1'b1;
		rst = 'b1;
		@(posedge clk)
		rst = 'b0;
		for (k = 0; k < N; k = k + 1) begin
			g_input = G[k];
			e_input = E[k];
			@(posedge clk);			
		end
		O[1] = o;
		
		G = 'hAA;
		E = 'hAA;
		$display("G = %H, E = %H", G, E);
		O_ref[2] = (G < E)? 1'b0:1'b1;
		rst = 'b1;
		@(posedge clk)
		rst = 'b0;
		for (k = 0; k < N; k = k + 1) begin
			g_input = G[k];
			e_input = E[k];
			@(posedge clk);			
		end
		O[2] = o;
		
		$display("O = %H, O_ref= %H", O, O_ref);		
		$stop();
	end

endmodule