module sbox(
	output [7:0] SubByte,
	input [7:0] num
	);
	
	wire[0:7] s, x;

	assign x = num;
	assign SubByte = s;
	
	wire [21:0] y;
	wire [67:0] t;
	wire [17:0] z;
	
	assign y[14] = x[3] ^ x[5];
	assign y[13] = x[0] ^ x[6];
	assign y[9] = x[0] ^ x[3];
	assign y[8] = x[0] ^ x[5];
	assign t[0] = x[1] ^ x[2];
	assign y[1] = t[0] ^ x[7];
	assign y[4] = y[1] ^ x[3];
	assign y[12] = y[13] ^ y[14];
	assign y[2] = y[1] ^ x[0];
	assign y[5] = y[1] ^ x[6];
	assign y[3] = y[5] ^ y[8];
	assign t[1] = x[4] ^ y[12];
	assign y[15] = t[1] ^ x[5];
	assign y[20] = t[1] ^ x[1];
	assign y[6] = y[15] ^ x[7];
	assign y[10] = y[15] ^ t[0];
	assign y[11] = y[20] ^ y[9];
	assign y[7] = x[7] ^ y[11];
	assign y[17] = y[10] ^ y[11];
	assign y[19] = y[10] ^ y[8];
	assign y[16] = t[0] ^ y[11];
	assign y[21] = y[13] ^ y[16];
	assign y[18] = x[0] ^ y[16];
	
	assign t[2] = y[12] & y[15];
	assign t[3] = y[3] & y[6];
	assign t[4] = t[3] ^ t[2];
	assign t[5] = y[4] & x[7];
	assign t[6] = t[5] ^ t[2]; 
	assign t[7] = y[13] & y[16];
	assign t[8] = y[5] & y[1];
	assign t[9] = t[8] ^ t[7];
	assign t[10] = y[2] & y[7];
	assign t[11] = t[10] ^ t[7];
	assign t[12] = y[9] & y[11];
	assign t[13] = y[14] & y[17];
	assign t[14] = t[13] ^ t[12];
	assign t[15] = y[8] & y[10];
	assign t[16] = t[15] ^ t[12];
	assign t[17] = t[4] ^ t[14];
	assign t[18] = t[6] ^ t[16];
	assign t[19] = t[9] ^ t[14];
	assign t[20] = t[11] ^ t[16];
	assign t[21] = t[17] ^ y[20];
	assign t[22] = t[18] ^ y[19];
	assign t[23] = t[19] ^ y[21];
	assign t[24] = t[20] ^ y[18];
	
	assign t[25] = t[21] ^ t[22];
	assign t[26] = t[21] & t[23];
	assign t[27] = t[24] ^ t[26];
	assign t[28] = t[25] & t[27]; 
	assign t[29] = t[28] ^ t[22];
	assign t[30] = t[23] ^ t[24];
	assign t[31] = t[22] ^ t[26];
	assign t[32] = t[31] & t[30];
	assign t[33] = t[32] ^ t[24];
	assign t[34] = t[23] ^ t[33];
	assign t[35] = t[27] ^ t[33];
	assign t[36] = t[24] & t[35]; 
	assign t[37] = t[36] ^ t[34];
	assign t[38] = t[27] ^ t[36];
	assign t[39] = t[29] & t[38];
	assign t[40] = t[25] ^ t[39];
	
	assign t[41] = t[40] ^ t[37];
	assign t[42] = t[29] ^ t[33];
	assign t[43] =  t[29] ^ t[40];
	assign t[44] =  t[33] ^ t[37];
	assign t[45] = t[42] ^ t[41];
	assign z[0] = t[44] & y[15];
	assign z[1] = t[37] & y[6];
	assign z[2] = t[33] & x[7];
	assign z[3] = t[43] & y[16];
	assign z[4] = t[40] & y[1];
	assign z[5] = t[29] & y[7];
	assign z[6] = t[42] & y[11];
	assign z[7] = t[45] & y[17];
	assign z[8] = t[41] & y[10];
	assign z[9] = t[44] & y[12];
	assign z[10] = t[37] & y[3];
	assign z[11] = t[33] & y[4];
	assign z[12] = t[43] & y[13];
	assign z[13] = t[40] & y[5];
	assign z[14] = t[29] & y[2];
	assign z[15] = t[42] & y[9];
	assign z[16] = t[45] & y[14];
	assign z[17] = t[41] & y[8];
	
	assign t[46] = z[15] ^ z[16];
	assign t[47] = z[10] ^ z[11];
	assign t[48] = z[5] ^ z[13];
	assign t[49] = z[9] ^ z[10];
	assign t[50] = z[2] ^ z[12];
	assign t[51] = z[2] ^ z[5];
	assign t[52] = z[7] ^ z[8];
	assign t[53] = z[0] ^ z[3];
	assign t[54] = z[6] ^ z[7];
	assign t[55] = z[16] ^ z[17];
	assign t[56] = z[12] ^ t[48];
	assign t[57] = t[50] ^ t[53];
	assign t[58] = z[4] ^ t[46];
	assign t[59] = z[3] ^ t[54];
	assign t[60] = t[46] ^ t[57];
	assign t[61] = z[14] ^ t[57];
	assign t[62] = t[52] ^ t[58];
	assign t[63] = t[49] ^ t[58];
	assign t[64] = z[4] ^ t[59];
	assign t[65] = t[61] ^ t[62];
	assign t[66] = z[1] ^ t[63];
	assign s[0] = t[59] ^ t[63];
	assign s[6] = ~t[56 ] ^ t[62]; 
	assign s[7] = ~t[48 ] ^ t[60]; 
	assign t[67] = t[64] ^ t[65];
	assign s[3] = t[53] ^ t[66];
	assign s[4] = t[51] ^ t[66];
	assign s[5] = t[47] ^ t[65];
	assign s[1] = ~t[64 ] ^ s[3]; 
	assign s[2] = ~t[55 ] ^ t[67]; 
  
endmodule 

module SubBytes(
x,
z);

  input [127:0] x;
  output [127:0] z;

  generate
    genvar i;
    for (i = 0; i < 16; i = i + 1) begin:SBOX
	  sbox sbox(z[8*(i+1)-1:8*i], x[8*(i+1)-1:8*i]);
    end
  endgenerate


endmodule

