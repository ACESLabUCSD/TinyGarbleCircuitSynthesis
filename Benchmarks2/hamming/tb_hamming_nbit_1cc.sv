`include "../Headers/Common_H.vh"
`timescale 1ns / 1ps

module tb_hamming_nbit_1cc;

	parameter N = 8, CC = 1, M = N/CC;

	logic					clk, rst;
	logic	[M-1:0] 		g_input;
	logic	[M-1:0] 		e_input;
	logic	[log2(N)-1:0] 	o;
	logic	[log2(N)-1:0] 	o_ref;

	hamming #(.N(N), .CC(CC)) uut(
		.clk(clk), .rst(rst),
		.g_input(g_input),
	    .e_input(e_input),
        .o(o)
	); 

	function automatic integer hamming_;
		input [M-1:0] A;
		input [M-1:0] B;
		logic [M-1:0] temp;
		integer k;
		begin
			temp = A^B;
			hamming_ = 0;
			for (k = 0; k < M; k = k + 1)
				if(temp[k]) hamming_ = hamming_ + 1;
		end
	endfunction	
	
	assign o_ref = hamming_(g_input, e_input);
	
	initial begin
		g_input = 'hA9;
		e_input = 'h7B;
		#100;
		$display("g_input = %H, e_input = %H, o = %H, o_ref = %H", g_input, e_input, o, o_ref);
		#100;
		g_input = 'h74;
		e_input = 'h9D;
		#100;
		$display("g_input = %H, e_input = %H, o = %H, o_ref = %H", g_input, e_input, o, o_ref);
		#100;
		g_input = 'hFF;
		e_input = 'hFF;
		#100;
		$display("g_input = %H, e_input = %H, o = %H, o_ref = %H", g_input, e_input, o, o_ref);
		$stop();
	end
	
endmodule 