yosys -import

foreach LOGIC [list 0 1 2] {
	if { $LOGIC == 0 } { set name "and" }
	if { $LOGIC == 1 } { set name "or" }
	if { $LOGIC == 2 } { set name "xor" }
	for {set N 1} {$N < 65} {incr N} {
		read_verilog -defer ../../SynthesisLibrary/syn_lib/*.v 
		read_verilog -defer -sv  logic2.sv
		hierarchy -check -top logic2 -chparam N $N -chparam LOGIC $LOGIC 
		procs; opt; flatten; opt; 
		techmap; opt;
		dfflibmap -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib
		abc -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib -script ../../SynthesisLibrary/lib_EMP/script.abc; 
		opt; clean; opt;
		opt_clean -purge
		stat -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys_area.lib
		write_verilog -noattr -noexpr -nohex syn/${name}_${N}bit.v
	}
}