## Vector Dot Product (VDP)

In this demo, we will show how to compute the dot product of two `N` element vectors `A` from Alice and `B` from Bob through the TinyGarble framework.
The VDP `Y` of `A` and `B` is computed through a sequence of Multiply-Accumulate (MAC) operations as shown by the following equation

![Y = \sum_{i=0}^{N-1}A_iB_i](https://render.githubusercontent.com/render/math?math=Y%20%3D%20%5Csum_%7Bi%3D0%7D%5E%7BN-1%7DA_iB_i)

We will follow the steps presented in the [start page](/README.md) to compute this equation. 

#### Before continuing to the remaining parts of the demo, please make sure you have set up the [TinyGarble](https://github.com/esonghori/TinyGarble) repo as well as [Verilog2SCD](/Verilog2SCD) in this repo by following the directions provided in the respective repos. 

First we write the Verilog code for the MAC operation using the modules for arithmetic and logical operations presented in the [Synthesis Library](/SynthesisLibrary/syn_lib). The Verilog code is given in [mac.sv](/demo
/vdp/mac.sv), Let us have a llok at different parts of the code. 

```SystemVerilog
module mac #(parameter N = 8, M = N, L = 64)( 
	input			clk, rst,
	input	signed	[N-1:0] A,
	input	signed	[M-1:0] B,
	output	signed	[L-1:0]	Y   
);

	logic	signed	[M+N-2:0] product; 
	logic	signed	[L-1:0]	  Y_reg;
	logic	signed	[L:0]	  Y_1;
	
	always@(posedge clk or posedge rst) begin
		if(rst) Y_reg <= {L{1'b0}};
		else Y_reg <= Y;
	end

	MULT_ #(.N(N), .M(M)) MULT_(
		.A(A),
		.B(B),
		.O(product)
	);	
	
	ADD_ #(.N(L), .M(M+N-1)) ADD_(
		.A(Y_reg),
		.B(product),
		.O(Y_1)
	); 
	
	assign Y = Y_1[L-1:0];

endmodule
```

To compute the MAC we use the `MULT_` and `ADD_` modules from the synthesis libraray. 
Each arithmetic operation has two modules in the libraray - one for unsigned and one for signed opereations. 
The module names for signed operations has the suffix `_`. 
In this demo we compute VDP of signed numbers. This is why all the variables are also declared as `signed`.

The products or `A` and `B` are accumulated in the register `Y_reg`. 
Please ovserve how the register is updated. 
TinyGarble requires all the registers to be updated in this fashion. 
To be specific, we need to ensure two properties of the registers: (i) they are updated asynchronously (`always@(posedge clk or posedge rst)`) and (ii) their input both at reset and in regular clock cycles must be provided. 
In the case of MAC, the register is reset to 0 
(it is also possible to reset the register to user defined values provided in `g_init` or `e_init`, we do not need them is this demo).

TinyGarble expects the interface to the Verilog module in a specific format as described [here](/Verilog2SCD/README.md#circuit-format).
To ensure that format, we add the following wrapper to the MAC module. 

```SystemVerilog
module mac_TG #(parameter N = 8, M = N, L = 64)( 
	input			clk, rst,
	input	signed	[N-1:0] g_input,
	input	signed	[M-1:0] e_input,
	output	signed	[L-1:0]	o   
);

	mac #(.N(N), .M(M), .L(L)) mac (
		.clk(clk), .rst(rst),
		.A(g_input),
		.B(e_input),
		.Y(o) 	
	);

endmodule
```
