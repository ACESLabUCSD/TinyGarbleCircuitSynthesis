`timescale 1ns / 1ps

module mult_mnbit_ncc #(parameter M = 128)( 
	input clk,
	input rst,
	input [0:0] g_input,
	input [M-1:0] e_init,
	output [0:0] o
);

	MULT_seq #(.M(M)) _MULT_seq(
		.clk(clk), .rst(rst),
		.a(g_input),
		.X(e_init),
		.aX(o)
	);

endmodule

module MULT_seq #(M = 8)( 
	input	clk, rst,
	input	[0:0] a,
	input	[M-1:0] X,
	output	[0:0] aX
);

	function automatic integer log2;
		input [31:0] value;
		reg [31:0] temp;
		begin
			temp = value - 1;
			for (log2 = 0; temp > 0; log2 = log2 + 1)
				temp = temp >> 1;
		end
	endfunction

	logic [M-1:0] A, X0;
	
	integer i;
	
	always@(posedge clk or posedge rst) begin
		if(rst) begin 
			A <= {M{1'b0}};
			X0 <= X;
		end
		else begin
			A[0] <= a;
			for(i = 0; i < M-1; i = i+1)
				A[i+1] <= A[i];
			X0 <= X0;
		end
	end	
	
	logic [M-1:0]S[log2(M):0];
	logic [M/2-1:0]CI[log2(M/2):0];
	logic [M/2-1:0]CO[log2(M/2):0];
	
	assign S[0] = A&X0;
		
	always@(posedge clk or posedge rst) begin
		if(rst) begin
			for(i = 0; i <= log2(M/2); i = i+1)
				CI[i] <= {(M/2){1'b0}};
		end
		else begin
			for(i = 0; i <= log2(M/2); i = i+1)
				CI[i] <= CO[i];
		end
	end	
	
	genvar j, k;
	
	generate
	for (j = 0; j < log2(M); j = j + 1)
	begin: col
		for(k = 0; k < M/(2**(j+1)); k = k + 1)
		begin: row
			ADD #(.N(1)) _ADD(
				.A(S[j][2*k]),
				.B(S[j][2*k+1]), 
				.CI(CI[j][k]), 
				.S(S[j+1][k]), 
				.CO(CO[j][k])
			);
		end	
	end
	endgenerate
	
	assign aX = S[log2(M)][0];
	
endmodule


