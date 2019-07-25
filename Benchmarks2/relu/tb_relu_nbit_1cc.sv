`timescale 1ns / 1ps

module tb_relu_nbit_1cc;

	parameter N = 8;
 
	logic	signed	[N-1:0]	s_input;
	logic	signed	[N-1:0]	o, o_ref;

	sum_nbit_1cc #(.N(N)) uut( 
		.s_input(s_input),
		.o(o)
	);	

	assign o_ref = (s_input > 0)? s_input : {N{1'b0}};
	
	initial begin
		s_input = 'd99;
		#100;
		$display("s_input = %H, o = %H, o_ref = %H", s_input, o, o_ref);
		#100;
		s_input = 'd0;
		#100;
		$display("s_input = %H, o = %H, o_ref = %H", s_input, o, o_ref);
		#100;
		s_input = -'d67;
		#100;
		$display("s_input = %H, o = %H, o_ref = %H", s_input, o, o_ref);
		$stop();
	end

endmodule