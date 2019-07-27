`include "../Headers/Common_H.vh"
`timescale 1ns / 1ps

module tb_hamming_nbit_ncc;

	parameter N = 8, CC = N, M = N/CC;

	logic					clk, rst;
	logic	[M-1:0] 		g_input;
	logic	[M-1:0] 		e_input;
	logic	[log2(N)-1:0] 	o;

	hamming_nbit_ncc #(.N(N), .CC(CC)) uut(
		.clk(clk), .rst(rst),
		.g_input(g_input),
	    .e_input(e_input),
        .o(o)
	); 

	function automatic integer hamming_;
		input [N-1:0] A;
		input [N-1:0] B;
		logic [N-1:0] temp;
		integer k;
		begin
			temp = A^B;
			hamming_ = 0;
			for (k = 0; k < N; k = k + 1)
				if(temp[k]) hamming_ = hamming_ + 1;
		end
	endfunction	
	
	logic	[N-1:0]			G;
	logic	[N-1:0]			E;
	logic 	[log2(N)-1:0]	O, O_ref;
	
	assign O_ref = hamming_(G, E);
	
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
		end
		O = o;
		$display("G = %H, E = %H, O = %H, O_ref= %H", G, E, O, O_ref);
		
		G = 'h74;
		E = 'h9D;
		rst = 'b1;
		@(posedge clk)
		rst = 'b0;
		for (k = 0; k < N; k = k + 1) begin
			g_input = G[k];
			e_input = E[k];
			@(posedge clk);			
		end
		O = o;
		$display("G = %H, E = %H, O = %H, O_ref= %H", G, E, O, O_ref);
		
		G = 'hAA;
		E = 'hAA;
		rst = 'b1;
		@(posedge clk)
		rst = 'b0;
		for (k = 0; k < N; k = k + 1) begin
			g_input = G[k];
			e_input = E[k];
			@(posedge clk);			
		end
		O = o;		
		$display("G = %H, E = %H, O = %H, O_ref= %H", G, E, O, O_ref);
		
		$stop();
	end
	
endmodule 