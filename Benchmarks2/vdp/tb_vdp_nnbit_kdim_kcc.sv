`timescale 1ns / 1ps

module tb_vdp_nnbit_kdim_kcc;

	parameter N = 8, K = 3; 

	logic						clk, rst;
	logic	signed	[N-1:0] 	g_input;
	logic	signed	[N-1:0] 	e_input;
	logic	signed	[2*N+K-2:0]	o;

	mac_nnbit_1cc #(.N(N), .K(K)) uut( //N: input bit-width, K: vector dimension
		.clk(clk), .rst(rst),
		.g_input(g_input),
		.e_input(e_input),
		.o(o)
	);

	logic	signed	[N-1:0]	G	[0:K-1];
	logic	signed	[N-1:0]	E	[0:K-1];
	logic	signed	[2*N+K-2:0]	O_ref[0:K];
	integer k, l;

	always #50 clk = ~clk;

	initial begin
		G = '{'d29, 'd74, -'d39};
		E = '{-'d38, -'d91, 'd47};
		O_ref[0] = 'd0;
		for(k = 0; k < K; k = k + 1)
			O_ref[k+1] = O_ref[k] + G[k]*E[k];
		
		clk = 1;
		rst = 1;
		@(negedge clk);
		rst = 0;
	end

	always @(posedge clk) begin
		if(rst) begin			
			g_input <= 'd0;
			e_input <= 'd0;
			l = 0;
		end
		else begin				
			g_input <= G[l];
			e_input <= E[l];
			l <= l + 1;
			$display("g_input = %H, e_input = %H, o = %H, o_ref = %H", g_input, e_input, o, O_ref[l]);
			
			if (l == K) $stop();
		end
	end

endmodule 