`ifndef _COMMON_H_
`define _COMMON_H_

function automatic integer log2;
	input [31:0] value;
	logic [31:0] temp;
	begin
		temp = value - 1;
		for (log2 = 0; temp > 0; log2 = log2 + 1)
			temp = temp >> 1;
	end
endfunction

function automatic [127:0] changeEndian;
	input [127:0] text;
	begin
		changeEndian = {
			text[7:0],
			text[15:8],
			text[23:16],
			text[31:24],
			text[39:32],
			text[47:40],
			text[55:48],
			text[63:56],
			text[71:64],
			text[79:72],
			text[87:80],
			text[95:88],
			text[103:96],
			text[111:104],
			text[119:112],
			text[127:120]
		};
	end
endfunction
`endif 