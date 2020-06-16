## Vector Dot Product (VDP)

In this demo, we will show how to compute the dot product of two `N` element vectors `A` from Alice and `B` from Bob through the TinyGarble framework.
The VDP `Y` of `A` and `B` is computed through a sequence of Multiply-Accumulate (MAC) operations as shown by the following equation

![Y = \sum_{i=0}^{N-1}A_iB_i](https://render.githubusercontent.com/render/math?math=Y%20%3D%20%5Csum_%7Bi%3D0%7D%5E%7BN-1%7DA_iB_i)

We will follow the steps presented in the [start page](/README.md) to compute this equation. 

#### Before continuing to the remaining parts of the demo, please make sure you have set up the [TinyGarble](https://github.com/esonghori/TinyGarble) repo as well as [Verilog2SCD](/Verilog2SCD) in this repo by following the directions provided in the respective repos. 

First we write the Verilog code for the MAC operation using the modules for arithmetic and logical operations presented in the [Synthesis Library](/SynthesisLibrary/syn_lib). The Verilog code is given in [mac.sv](/demo
/vdp/mac.sv). Let us have a look at different parts of the code. 

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

The next step is to compile this module with a circuit synthesis tool using the synthesis library of TinyGarble.
Currently the synthesis library sypports Synopsys Design Compiler (DC) and Yosys. The commands to synthesize the module with Synopsys DC is provided in [mac.dcsh](/demo
/vdp/mac.dcsh). Let us have a look at the command. 

```bash
set search_path [list . ../../SynthesisLibrary/lib/dff_full/]
set target_library ../../SynthesisLibrary/lib/dff_full/dff_full.db
set link_library ../../SynthesisLibrary/lib/dff_full/dff_full.db
set symbol_library [concat ../../SynthesisLibrary/lib/generic.sdb]
set hdlin_while_loop_iterations 1024

analyze -format verilog {../../SynthesisLibrary/syn_lib/ADD.v ../../SynthesisLibrary/syn_lib/ADD_.v ../../SynthesisLibrary/syn_lib/COMP.v ../../SynthesisLibrary/syn_lib/COUNT.v ../../SynthesisLibrary/syn_lib/DIV.v ../../SynthesisLibrary/syn_lib/DIV_.v ../../SynthesisLibrary/syn_lib/FA.v ../../SynthesisLibrary/syn_lib/MULT.v ../../SynthesisLibrary/syn_lib/MULT_.v ../../SynthesisLibrary/syn_lib/MUX.v ../../SynthesisLibrary/syn_lib/SHIFT_LEFT.v ../../SynthesisLibrary/syn_lib/SHIFT_RIGHT.v ../../SynthesisLibrary/syn_lib/SUB.v ../../SynthesisLibrary/syn_lib/SUB_.v ../../SynthesisLibrary/syn_lib/TwosComplement.v ../../SynthesisLibrary/syn_lib/square_root.v }

analyze -format sverilog mac.sv

foreach L {32} {
foreach N {4 8 16} {
elaborate mac_TG -architecture verilog -library DEFAULT -update -parameters $N,$N,$L
set_max_area -ignore_tns 0 
set_flatten false -design *
set_structure false -design *
set_resource_allocation area_only
report_compile_options
compile -ungroup_all  -map_effort high -area_effort high -no_design_rule
write -hierarchy -format verilog -output syn/mac_${N}_${N}_${L}bit.v
}
}

exit
```

Fisrt, make sure the the relative path (in this case `../../SynthesisLibrary`) of the [SynthesisLibrary](/SynthesisLibrary) is correct.
Then read the input Verilog module with the `analyze` command (in this demo, `analyze -format sverilog mac.sv`, it has the format specifier since the input module is in SyetemVerilog while the default is Verilog).
We can synthesize the same module for different bit widths by passing the parameters during execution of the `elaborate` command. 
In this demo, the module has three parameters and we set their values with `-parameters $N,$N,$L`.

To execute mac.dcsh through Synopsys DC, run
```bash
mkdir -p syn # synthesis outputs are written here. see 'write' command at the end of the dcsh file
design_vision -no_gui -f mac.dcsh
rm *.pvl *.syn *.mr *.log *.svf # remove intermediate files
```

The synthesis outputs are written in the `syn` directory. 
You can count the number of gates in the generated netlist with the [count.sh](/SynthesisLibrary/script/count.sh) script.
For example,
```
../../SynthesisLibrary/script/count.sh syn/mac_8_8_32bit.v
```




