`include "../Headers/Common_H.vh"
`timescale 1ns / 1ps

module tb_aes_11cc;

	localparam CC = 1;

	reg clk;
	reg rst;

	reg [127:0] g_init;
	reg [127:0] e_init;
	wire [127:0] o;
	reg [127:0] o_ref;

	aes_11cc uut(
		.clk(clk),
		.rst(rst),
		.g_init(g_init),
		.e_init(e_init),
		.o(o)
	);

	integer i;
	initial begin
		g_init = changeEndian(128'he4dc18adf3d05ec9e4dcc41acb990007); 
		e_init = changeEndian(128'h4072da1240f930f7d3c8cf8b9322042e);
		o_ref = changeEndian(128'hd225406f484809186cb5d86be4098445);
		clk =0;
		rst =1;
		@(posedge clk);
		rst =0;
		for(i=0;i<11;i=i+1) begin
			@(posedge clk);
		end
		$display("%H\n%H", o, o_ref);		
		$stop;
	end

	always #50 clk = ~clk;

endmodule