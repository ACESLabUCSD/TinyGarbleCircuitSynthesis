`timescale 1ns / 1ps

module relu #(parameter N = 8)(
	input	[N-1:0]	s_input,
	output	[N-1:0] o
);	 
	assign o = s_input&{(N){~s_input[N-1]}};
	//assign o = (s_input < 0)? 'b0 : s_input;

endmodule