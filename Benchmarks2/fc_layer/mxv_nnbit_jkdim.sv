`timescale 1ns / 1ps

module mxv_nnbit_jkdim #(parameter N = 8, J = 3, K = 3)( //N: input bit-width, (JxK)(Kx1) = (Jx1)
	input			signed	[J*K*N-1:0] 		g_input,
	input			signed	[K*N-1:0] 			e_input,
	output	logic 	signed	[J*(2*N+K-1)-1:0]	o
);

	logic	signed	[N-1:0] W[J-1:0][K-1:0];
	logic	signed	[N-1:0] X[K-1:0];
	logic	signed	[2*N+K-2:0] WX[J-1:0];
	logic	signed	[2*N+K-2:0] P[J-1:0][K:0];

	genvar r, c;
	
	generate
		for (r = 0; r < J; r = r+1) begin: row
			assign P[r][0] = 'd0;
			assign WX[r] = P[r][K];
			assign o[(r+1)*(2*N+K-1)-1 -: (2*N+K-1)] = WX[r];
			
			for (c = 0; c < K; c = c+1) begin: col
				assign W[r][c] = g_input[(r*K+c+1)*N-1 -: N];
				
				mac_comb #(.N(N), .K(K)) mac_comb( 	//N: input bit-width, K: vector dimension
					.A(W[r][c]),				//input	signed	[N-1:0] 	
					.B(X[c]),  					//input	signed	[N-1:0] 	
					.S0(P[r][c]), 				//input	signed	[2*N+K-2:0]	
					.S(P[r][c+1])   			//output	signed	[2*N+K-2:0]	
				);
			end
		end
			
		for (c = 0; c < K; c = c+1) begin: col_asn
			assign X[c] = e_input[(c+1)*N-1 -: N];
		end
	endgenerate

endmodule
