`timescale 1ns / 1ps

module tb_maxpool_nbit_kdim_kcc;

	parameter N = 8, K = 8; 

	logic			clk, rst;
	logic	[N-1:0] s_input;
	logic	[N-1:0]	o;

	maxpool_nbit_kdim_kcc #(.N(N)) uut( //N: input bit-width, K: vector dimension
		.clk(clk), .rst(rst),
		.s_input(s_input),
		.o(o)
	);

	logic	[N-1:0]	S		[0:K-1];
	logic	[N-1:0]	O_ref	[0:K];
	integer k, l;

	always #50 clk = ~clk;

	initial begin
		S = '{'d29, 'd34, 'd39, 'd23, 'd99, 'd78, 'd0, 'd87};
		O_ref[0] = 'd0;
		
		for(k = 0; k < K; k = k + 1)
			if(S[k] > O_ref[k])
				O_ref[k+1] = S[k];
			else	
				O_ref[k+1] = O_ref[k];
		
		clk = 1;
		rst = 1;
		@(negedge clk);
		rst = 0;
	end

	always @(posedge clk) begin
		if(rst) begin			
			s_input <= 'd0;
			l = 0;
		end
		else begin				
			s_input <= S[l];
			l <= l + 1;
			$display("s_input = %H, o = %H, o_ref = %H", s_input, o, O_ref[l]);
			
			if (l == K) $stop();
		end
	end

endmodule 