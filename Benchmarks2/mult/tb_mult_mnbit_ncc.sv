`timescale 1ns / 1ps

module tb_mult_mnbit_ncc;

parameter N = 1024, M = N; 

logic				clk, rst;
logic	[0:0] 		g_input;
logic	[N-1:0] 	G;
logic	[M-1:0] 	e_init;
logic	[0:0] 		o;
logic	[N+M-1:0]	O, O_ref;
logic	[N+M-1:0]	err;

  
mult_mnbit_ncc #(.M(M)) uut( 
	.clk(clk),
	.rst(rst),
	.g_input(g_input),
	.e_init(e_init),
	.o(o)
);

always #50 clk = ~clk;

integer k;

initial begin
	clk = 1'b0;
	rst = 1'b1;
	G = {N{1'b1}};
	e_init = {(N/2){2'b10}};
	O_ref = G*e_init;
	#75;
	rst = 1'b0;
	for (k = 0; k < N; k = k+1) begin
		g_input <= G[k];
		@(posedge clk);
		O[k-1] = o;
	end
	for (k = 0; k < M; k = k+1) begin
		g_input <= 1'b0;
		@(posedge clk);
		O[k+N-1] = o;
	end
	@(posedge clk);
	O[k+N-1] = o;
	@(posedge clk);
	O[k+N] = o;
	@(posedge clk);
	$display("G = %d, e_init = %d, O = %d, O_ref = %d\n", G, e_init, O, O_ref);
	$display("error = %d\n", O-O_ref);
	$stop();
end

	


endmodule