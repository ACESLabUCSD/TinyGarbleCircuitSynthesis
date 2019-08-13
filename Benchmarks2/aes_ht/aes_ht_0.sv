`timescale 1ns / 1ps

module aes_ht_0 #(parameter COUNTER = 0)(
	input	[127:0]	g_input, // key
	input	[127:0]	e_input, // message
	output	[255:0]	o
);

	wire	[127:0]	key, msg;
	wire	[127:0]	nextKey, add_round_key_input, add_round_key_out, sub_byte_out, shift_row_out, mix_col_out;
	
	assign key = g_input;
	assign msg = e_input;
	assign o = {nextKey, add_round_key_out};

	KeyExpansion_ht #(.COUNTER(COUNTER)) e( .key(key), .nextKey(nextKey));

	parameter addr_sel = (COUNTER==0)? 'b00 : (COUNTER<10)? 'b01 : 'b11;

	assign add_round_key_input = (addr_sel == 2'b0) ? msg : (addr_sel == 2'b1) ? mix_col_out: shift_row_out;

	SubBytes b(.x(msg), .z(sub_byte_out));

	ShiftRows c(.x(sub_byte_out), .z(shift_row_out));

	MixColumns d(.x(shift_row_out), .z(mix_col_out));

	AddRoundKey a(.x(add_round_key_input), .y(key), .z(add_round_key_out));

endmodule