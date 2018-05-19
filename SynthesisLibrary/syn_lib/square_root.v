`timescale 1ns / 1ps

 module square_root_comb #(parameter N = 8, M = N/2)(
	input 	[N-1:0]		A,
	output	[N/2-1:0]	O
	);
	
	wire	[N/2:0]	Y[0:M];
	
	assign O = Y[M][N/2-1:0];
	
	genvar gv;
	generate
	for (gv = 0; gv < M; gv = gv + 1)
	begin: sqr_rt
		squar_root_comb_unit #(.N(N), .K(gv)) squar_root_comb_unit(
			.x(A),
			.y_in(Y[gv][N/2:N/2-gv]), 
			.y_out(Y[gv+1][N/2:N/2-gv-1])
		);
	end
	endgenerate	
	
endmodule	
	
module squar_root_comb_unit #(parameter N = 8, K = 0)(
	input	[N-1:0]	x,
	input	[K:0]	y_in,
	output	[K+1:0]	y_out
);

	wire 				t, b;
	wire	[2*K+1:0]	y_sqr;	
	wire	[K+1:0]		y;
		
	assign y = {y_in, 1'b1};		
	MULT #(.N(K+1), .M(K+1)) MULT1 (.A(y[K:0]), .B(y[K:0]), .O(y_sqr));	
	COMP #(.N(2*K+2)) COMP1 (.A(x[N-1:N-2*K-2]), .B(y_sqr), .O(t));
	MUX #(.N(1)) MUX1 (.A(1'b0), .B(1'b1), .S(t), .O(b));		
	assign y_out = {y_in, b};

endmodule


module square_root_seq #(parameter N = 8, M = N/2)(
	input 				clk,
	input 				rst,
	input 				start,
	input 	[N-1:0]		A,
	output	[N/2-1:0]	O,
	output	reg			ready
	);
	
	function integer log2;
	input integer value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
	value = value>>1;
	end
	endfunction
	
	localparam L = log2(M);
	
	reg		[N-1:0]	x;
	reg		[N/2-1:0]	y_in, y0_in;
	wire	[N/2-1:0]	y_out, y0_out;	
	reg		[L-1:0]	count;
	
	assign O = y_out;

	squar_root_seq_unit #(.N(N)) squar_root_seq_unit(
		.x(x),
		.y_in(y_in), 
		.y0_in(y0_in), 
		.y_out(y_out),
		.y0_out(y0_out)
	);		
	
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			x		<= 0;
			y_in	<= 0;
			y0_in	<= 0;
			count	<= 0;
			ready <= 0;
		end
		else begin
			if(start) begin
				x		<= A;
				y_in	<= 0;
				y0_in <= {1'b1,{(N/2-1){1'b0}}};
				count <= 0;	
				ready <= 0;
			end		
			else begin
				y_in	<= y_out;
				y0_in	<= y0_out;
				count	<= count + 1;
				if (count == M-2) begin
					ready <= 1;
				end
			end	
		end		
	end	
	
endmodule


module squar_root_seq_unit #(parameter N = 8)(
	input	[N-1:0]		x,
	input	[N/2-1:0]	y_in, y0_in,
	output	[N/2-1:0]	y_out, y0_out
);

	wire				t, b;
	wire	[N/2-1:0]	y;
	wire	[N-1:0]		y_sqr;
	
	assign y = y_in|y0_in;
	MULT #(.N(N/2), .M(N/2)) MULT1 (.A(y), .B(y), .O(y_sqr));
	COMP #(.N(N)) COMP1 (.A(x), .B(y_sqr), .O(t));
	MUX #(.N(1)) MUX1 (.A(1'b0), .B(1'b1), .S(t), .O(b));	
	assign y_out = y_in|(y0_in&{(N/2){b}});
	assign y0_out = y0_in >> 1;
	
endmodule 
