`timescale 1ns / 1ps

module aes_ht_10 #(parameter COUNTER = 10)(
	input	[255:0]	s_input, // {key, message}
	output	[127:0]	o
);

	wire	[127:0]	key, msg;
	wire	[127:0]	nextKey, add_round_key_input, add_round_key_out, sub_byte_out, shift_row_out, mix_col_out;
	
	assign {key, msg} = s_input;
	assign o = add_round_key_out;

	KeyExpansion_ht #(.COUNTER(COUNTER)) e( .key(key), .nextKey(nextKey));

	parameter addr_sel = (COUNTER==0)? 'b00 : (COUNTER<10)? 'b01 : 'b11;

	assign add_round_key_input = (addr_sel == 2'b0) ? msg : (addr_sel == 2'b1) ? mix_col_out: shift_row_out;

	SubBytes b(.x(msg), .z(sub_byte_out));

	ShiftRows c(.x(sub_byte_out), .z(shift_row_out));

	MixColumns d(.x(shift_row_out), .z(mix_col_out));

	AddRoundKey a(.x(add_round_key_input), .y(key), .z(add_round_key_out));
	
endmodule