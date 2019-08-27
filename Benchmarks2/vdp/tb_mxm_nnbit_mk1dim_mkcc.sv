`timescale 1ns / 1ps

module tb_mxm_nnbit_mk1dim_mkcc;

	parameter N = 8, K = 3, M = 3; 

	logic						clk, rst;
	logic	signed	[N-1:0] 	g_input;
	logic	signed	[N-1:0] 	e_input;
	logic	signed	[2*N+K-2:0]	o;

	mac_nnbit_kcc #(.N(N), .K(K)) uut( //N: input bit-width, K: vector dimension
		.clk(clk), .rst(rst),
		.g_input(g_input),
		.e_input(e_input),
		.o(o)
	);

	logic	signed	[N-1:0]	G	[0:M-1][0:K-1];
	logic	signed	[N-1:0]	E	[0:K-1];
	logic	signed	[2*N+K-2:0]	O_ref[0:M-1][0:K];
	integer k, l, m;

	always #50 clk = ~clk;

	initial begin
		G = '{'{'d29, 'd74, -'d39}, '{'d67, -'d71, 'd56}, '{'d75, -'d45, 'd34}};
		E = {-'d38, -'d91, 'd47};
		
		for (m = 0; m < M; m = m + 1) begin
			O_ref[m][0] = 'd0;
			for(k = 0; k < K; k = k + 1)
				O_ref[m][k+1] = O_ref[m][k] + G[m][k]*E[k];
		end
		
		l = 0;
		m = 0;
		
		clk = 'b1;		
		rst = 'b1;
		@(negedge clk);
		rst = 'b0;
	end
	
	always @(negedge clk) 
		rst <= 'b0;

	always @(posedge clk or posedge rst) begin
		if(rst) begin			
			g_input <= 'd0;
			e_input <= 'd0;
		end
		else begin				
			g_input <= G[m][l];
			e_input <= E[l];			
			$display("g_input = %H, e_input = %H, o = %H, o_ref = %H", g_input, e_input, o, O_ref[m][l]);	
			l <= l + 1;
			if (l == K) begin
				l <= 0;
				m <= m + 1;
				rst <= 'b1;
			end
			if (m == M) $stop();		
		end
	end

endmodule 