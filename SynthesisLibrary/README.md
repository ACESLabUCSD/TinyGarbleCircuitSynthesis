# Circuit Synthesis

## Dependencies
Netlist generation requires [Synopsys Design Compiler](https://www.synopsys.com/support/training/rtl-synthesis/design-compiler-rtl-synthesis.html) or [Yosys-ABC](http://www.clifford.at/yosys/) synthesis tools.

## Libraries
- **syn_lib**: Free-XOR optimized implementation of common arithmetic and logical operations.
- **lib**: Free-XOR optimized cell library for [TinyGarble](https://github.com/esonghori/TinyGarble). Includes all possible combinations of four entry truth tables. 
- **lib_EMP**: Free-XOR optimized cell library for [EMP-Toolkit](https://github.com/emp-toolkit). Includes three logic cells (AND, XOR, NOT) currently supported. 
- **lib_BMR**: Free-XOR optimized cell library for [Semi-Honest-BMR](https://github.com/cryptobiu/Semi-Honest-BMR). Includes five logic cells (AND, NOR, XOR, XNOR, NOT) currently supported. 

### Compile library (for Synopsys Design Compiler)
[This part is required only if the cell libraries for Synopsys DC needs to be updated. Otherwise please skip.]

Go to `lib[_EMP or _BMR]/dff_full` and compile the library:
```
	$ cd lib[_EMP or _BMR]/dff_full
	$ ./compile
```
_Advanced detailed_: Let's suppose that our\_lib.lib is located in
/path/to/our\_lib.

- Go inside /path/to/our\_lib and run:
```bash
	$ lc_shell
	lc_shell> set search_path [concat /path/to/our_lib/]
	lc_shell> read_lib our_lib.lib
	lc_shell> write_lib our_lib -format db
	lc_shell> exit
```
[Note: commands starting with "lc_shell>" should be called inside `lc_shell`.
Please ignore "lc_shell>" for them].

## Manual for Synopsys Design Compiler

```bash
	$ design_vision
	design_vision> set path <path-to-this-repo>/SynthesisLibrary
	design_vision> set lib_path $path/lib #change library for EMP or BMR
	design_vision> set syn_path $path/syn_lib
	design_vision> set search_path [list . $lib_path/dff_full/ $syn_path]
	design_vision> set target_library $lib_path/dff_full/dff_full.db
	design_vision> set link_library $lib_path/dff_full/dff_full.db
	design_vision> set symbol_library [concat $lib_path/generic.sdb]
	design_vision> set hdlin_while_loop_iterations 2049
	design_vision> analyze -format verilog {<list-of-functions-from-syn_lib-used-in-the-circuit>}
	design_vision> analyze -format verilog {<list-of-user-files>}
	design_vision> elaborate <top-module> -architecture verilog -library DEFAULT -update 
	design_vision> set_max_area -ignore_tns 0 
	design_vision> set_flatten false -design *
	design_vision> set_structure -design * false
	design_vision> set_resource_allocation area_only
	design_vision> report_compile_options
	design_vision> compile -ungroup_all  -map_effort low -area_effort low -no_design_rule
	design_vision> write -hierarchy -format verilog -output <top-module>_syn.v
	design_vision> exit
```
It creates `<top-module>_syn.v` in the current directory. [Note: commands
starting with "design\_vision>" should be called inside `design_vision`.
Please ignore "design\_vision>" for them.]

Alternatively, write the commands in a `.dcsh` file and run
```bash
	$ design_vision -no_gui -f <user-file>.dcsh
```
A [sample](script/sample.dcsh) `.dcsh` file is provided in the `script` directory.
	
## Manual for Yosys

```bash
	$ yosys
	yosys> read_verilog <path-to-this-repo>/SynthesisLibrary/syn_lib/*.v
	yosys> read_verilog <list-of-user-files>
	yosys> hierarchy -check -top <top-module>
	yosys> proc; opt; flatten; opt; 
	yosys> techmap ; opt;
	yosys> abc -liberty <path-to-this-repo>/SynthesisLibrary/lib/asic_cell_yosys.lib -script <path-to-this-repo>/SynthesisLibrary/lib/script.abc; #change library for EMP or BMR
	yosys> opt; clean; opt;
	yosys> opt_clean -purge
	yosys> stat -liberty ../git/TinyGarbleCircuitSynthesis/SynthesisLibrary/lib/asic_cell_yosys.lib
	yosys> write_verilog -noattr -noexpr <top-module>_syn_yos.v
	yosys> exit
```	
It creates `<top-module>_syn_yos.v` in the current directory. [Note: commands starting with "yosys>" should be called inside yosys.
Please ignore "yosys>" for them.]

Alternatively, write the commands in a `.yos` file and run
```bash
	$ yosys -s <user-file>.yos
```
A [sample](script/sample.yos) `.yos` file is provided in the `script` directory.

## Counting number of gates
You can use `script/count.sh` to count the number of gates in
the generated netlist file. For counting gates in
`/path/to/benchmark/benchmark_syn.v`, simply run:
```bash
	$ script/count.sh /path/to/benchmark/benchmark_syn.v
```
