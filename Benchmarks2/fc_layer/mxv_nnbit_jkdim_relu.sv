`timescale 1ns / 1ps

module mxv_nnbit_jkdim_relu #(parameter N = 8, J = 3, K = 3, L = 2*(N-1)+K)( //N: input bit-width, (JxK)(Kx1) = (Jx1)
	input			signed	[J*K*N-1:0] 	g_input,
	input			signed	[K*N-1:0] 		e_input,
	output	logic 	signed	[J*(L-1)-1:0]	o
);

	logic	signed	[J*L-1:0]	o_;
	logic	signed	[L-1:0] WX[J-1:0];
	logic	signed	[L-2:0] R_WX[J-1:0];
	
	genvar r;
	
	generate
		for (r = 0; r < J; r = r+1) begin: relu
			assign WX[r] = o_[(r+1)*L-1 -: L];
			assign R_WX[r] = WX[r][L-2:0]&{(L-1){~WX[r][L-1]}};
			assign o[(r+1)*(L-1)-1 -: (L-1)] = R_WX[r];
		end
	endgenerate
	
	
	mxv_nnbit_jkdim #(.N(N), .J(J), .K(K)) mxv_nnbit_jkdim( //N: input bit-width, (JxK)(Kx1) = (Jx1)
		.g_input(g_input),
		.e_input(e_input),
		.o(o_)
	);

endmodule
