`include "../Headers/Common_H.vh"
`timescale 1ns / 1ps

module tb_aes_ht;

	reg [127:0] g_input;
	reg [127:0] e_input;	
	wire [127:0] o;
	reg [127:0] o_ref;
	
	wire [255:0] s [0:9];	

	aes_ht_0 uut_0 (
		.g_input(g_input),
		.e_input(e_input),
		.o(s[0])
	);
	genvar i;

	generate 
	for(i = 1; i < 10; i = i + 1) begin:uut
		aes_ht_1 #(.COUNTER(i)) uut_ (
			.s_input(s[i-1]),
			.o(s[i])
		);
	end
	endgenerate	

	aes_ht_10 uut_10(
		.s_input(s[9]),
		.o(o)
	);

	initial begin	
		g_input = changeEndian(128'he4dc18adf3d05ec9e4dcc41acb990007); 
		e_input = changeEndian(128'h4072da1240f930f7d3c8cf8b9322042e);
		o_ref = changeEndian(128'hd225406f484809186cb5d86be4098445);
		#100;
		$display("%H\n%H", o, o_ref);
		$stop;
	end

endmodule