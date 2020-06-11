yosys -import

for {set N 1} {$N < 65} {incr N} {
	read_verilog -defer ../../SynthesisLibrary/syn_lib/*.v 
	read_verilog -defer -sv  sub.sv
	hierarchy -check -top sub -chparam N $N 
	procs; opt; flatten; opt; 
	techmap; opt;
	dfflibmap -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib
	abc -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib -script ../../SynthesisLibrary/lib_EMP/script.abc; 
	opt; clean; opt;
	opt_clean -purge
	stat -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys_area.lib
	write_verilog -noattr -noexpr -nohex syn/sub_${N}bit.v
}
