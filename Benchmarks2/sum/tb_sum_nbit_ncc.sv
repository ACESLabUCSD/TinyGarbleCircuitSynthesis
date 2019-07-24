`timescale 1ns / 1ps

module tb_sum_nbit_ncc;

	logic clk, rst;
	logic g_input;
	logic e_input;
	logic o;

	sum_nbit_ncc uut( 
		.clk(clk), .rst(rst),
		.g_input(g_input),
		.e_input(e_input),
		.o(o)
	);	
	
	parameter N = 8;
	
	logic	[N-1:0]	G;
	logic	[N-1:0]	E;
	logic 	[N-1:0]	O, O_ref;
	
	assign O_ref = G + E;
	
	always #50 clk = ~clk;
	
	integer k;
	
	initial begin
		clk = 'b0;
				
		G = 'hA9;
		E = 'h7B;
		rst = 'b1;
		@(posedge clk)
		rst = 'b0;
		for (k = 0; k < N; k = k + 1) begin
			g_input = G[k];
			e_input = E[k];
			@(posedge clk);
			O[k] = o;			
		end
		$display("G = %H, E = %H, O = %H, O_ref= %H", G, E, O, O_ref);
		
		G = 'h18;
		E = 'h27;
		rst = 'b1;
		@(posedge clk)
		rst = 'b0;
		for (k = 0; k < N; k = k + 1) begin
			g_input = G[k];
			e_input = E[k];
			@(posedge clk);
			O[k] = o;			
		end
		$display("G = %H, E = %H, O = %H, O_ref= %H", G, E, O, O_ref);
		
		G = 'h57;
		E = 'h63;
		rst = 'b1;
		@(posedge clk)
		rst = 'b0;
		for (k = 0; k < N; k = k + 1) begin
			g_input = G[k];
			e_input = E[k];
			@(posedge clk);
			O[k] = o;			
		end
		$display("G = %H, E = %H, O = %H, O_ref= %H", G, E, O, O_ref);
		
		$stop();
	end

endmodule