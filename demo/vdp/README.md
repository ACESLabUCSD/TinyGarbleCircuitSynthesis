## Vector Dot Product (VDP)

In this demo, we will show how to compute the dot product of two `K` element vectors `A` from Alice and `B` from Bob through the TinyGarble framework.
The VDP `Y` of `A` and `B` is computed through a sequence of Multiply-Accumulate (MAC) operations as shown by the following equation

![Y = \sum_{i=0}^{K-1}A_iB_i](https://render.githubusercontent.com/render/math?math=Y%20%3D%20%5Csum_%7Bi%3D0%7D%5E%7BK-1%7DA_iB_i)

We will follow the steps presented in the [start page](/README.md) to compute this equation. 

#### Before continuing to the remaining parts of the demo, please make sure you have set up [TinyGarble](https://github.com/esonghori/TinyGarble), [Verilog2SCD](/Verilog2SCD) and either of [Synopsys Design Compiler](https://www.synopsys.com/implementation-and-signoff/rtl-synthesis-test/design-compiler-graphical.html) or [Yosys Open SYnthesis Suite](http://www.clifford.at/yosys/). 

### Step 1: Write a Verilog module

First, we write the Verilog code for the MAC operation using the modules for arithmetic and logical operations presented in the [Synthesis Library](/SynthesisLibrary/syn_lib). The Verilog code is given in [mac.sv](/demo/vdp/mac.sv). Let us have a look at different parts of the code. 

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


### Step 2: Write a wrapper according to the template expected by Verilog2SCD

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

### Step 3: Synthesize the Verilog module

The next step is to compile this module with a circuit synthesis tool using the synthesis library of TinyGarble.
Currently the synthesis library sypports Synopsys DC and Yosys. 

#### Synthesis with Synopsys DC

The commands to synthesize the module with Synopsys DC is provided in [mac.dcsh](/demo/vdp/mac.dcsh). Let us have a look at the command. 

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

#### Synthesis with Yosys

The commands to synthesize the module with Synopsys DC is provided in [mac.tcl](/demo/vdp/mac.tcl).  

```tcl
yosys -import

foreach N [list 4 8 16]  {
	foreach L [list 32]  {
		read_verilog -overwrite -defer ../../SynthesisLibrary/syn_lib/*.v 
		read_verilog -overwrite -defer -sv  mac.sv 
		hierarchy -check -top mac_TG -chparam N $N -chparam L $L
		procs; opt; flatten; opt; 
		techmap; opt;
		dfflibmap -liberty ../../SynthesisLibrary/lib/asic_cell_yosys.lib
		abc -liberty ../../SynthesisLibrary/lib/asic_cell_yosys.lib -script ../../SynthesisLibrary/lib/script.abc; 
		opt; clean; opt;
		opt_clean -purge
		write_verilog -noattr -noexpr -nohex syn/mac_${N}_${N}_${L}bit.v
	}
}
```

Similart to Synopsys, make sure the the relative path (in this case `../../SynthesisLibrary`) of the [SynthesisLibrary](/SynthesisLibrary) is correct.
In Yosys, the input Verilog module is read with the `read_verilog` command (in this demo, `read_verilog -overwrite -defer -sv  mac.sv`, it also has the format specifier since the input module is in SyetemVerilog while the default is Verilog).
We can synthesize the same module for different bit widths by passing the parameters during execution of the `hierarchy` command. 
In this demo, the module has three parameters and we set their values with `-chparam N $N -chparam L $L` (`M` is set to `N` by default in the Verilog module).

To execute mac.tcl through Yosys, run
```bash
mkdir -p syn
yosys -c mac.tcl
```

The synthesis outputs are written in the `syn` directory. 
You can count the number of gates in the generated netlist with the [count.sh](/SynthesisLibrary/script/count.sh) script.
For example,
```bash
../../SynthesisLibrary/script/count.sh syn/mac_8_8_32bit.v
```
If you have both Synopsys DC and Yosys, you can synthesize the same Verilog module with both tools and compare their performances. 

### Step 4: Translate the netlist file to SCD format

Before executing TinyGarble, the generated netlist needs to be converted to the [SCD](/Verilog2SCD) format using `V2SCD_Main`.
For example to convert `syn/mac_8_8_32bit.v` to SCD, run

```bash
../../Verilog2SCD/bin/V2SCD_Main -i syn/mac_8_8_32bit.v  -o syn/mac_8_8_32bit.scd --log2std
```
Again, please make sure the relative location of the `V2SCD_Main` binary is correct. 
All the bash commands are written in [compile.sh](/demo/vdp/compile.sh) and [compile_y.sh](/demo/vdp/compile_y.sh).
You can simply run `./compile.sh` for Synopysy or `./compile_y.sh` for Yosys to perform these operations all at once. 

### Step 4: Execute TinyGarble

We are now ready to compute VDP through GC. 
Please change the directory to where the TinyGarble repo is located. 
First, please have a look at the usage of the [`TinyGarble`](https://github.com/esonghori/TinyGarble#main-binary) binary. 
Let us compute the dot product of 3-element vectors `A = {1, 2, 3}` and `B = {-1, -2, -3}` where each element is represented by 8-bit signed numbers and the accumulator is 32 bits.
For this we have to use the netlist `syn/mac_8_8_32bit.scd` and execute TinyGarble for 3 cycles. 

On Alice's terminal, run
```bash
./bin/garbled_circuit/TinyGarble -a -i ../../TinyGarbleCircuitSynthesis/demo/vdp/syn/mac_8_8_32bit.scd --input 010203 -c 3 --output_mode 2 --log2std 
```
On Bob's terminal, run
```bash
./bin/garbled_circuit/TinyGarble -b -i ../../TinyGarbleCircuitSynthesis/demo/vdp/syn/mac_8_8_32bit.scd --input FFFEFD -c 3 --output_mode 2 --log2std
```
Please note that both the inputs and outputs are in hex format. 
Also make sure that the location of the input SCD file (specified with `-i`) is correct.










