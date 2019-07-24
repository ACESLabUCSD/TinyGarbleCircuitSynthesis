`timescale 1ns / 1ps

module tb_aes_1cc;

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

	reg [127:0] g_input;
	reg [127:0] e_input;
	wire [127:0] o;
	reg [127:0] o_ref;

	aes_1cc uut (
		.g_input(g_input),
		.e_input(e_input),
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