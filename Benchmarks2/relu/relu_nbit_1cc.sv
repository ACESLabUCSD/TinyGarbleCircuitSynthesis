`timescale 1ns / 1ps

module relu_nbit_1cc #(parameter N = 8)(
	input	signed	[N-1:0]	s_input,
	output	signed	[N-2:0] o
);	 

	assign o = s_input[N-2:0]&{(N-1){~s_input[N-1]}};

endmodule