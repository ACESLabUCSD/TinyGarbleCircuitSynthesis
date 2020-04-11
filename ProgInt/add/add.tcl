yosys -import

foreach N [list 13 14 15 16 17 20 24 27 28 30] {
	read_verilog -defer ../../SynthesisLibrary/syn_lib/*.v 
	read_verilog -defer -sv  add.sv
	hierarchy -check -top add -chparam N $N 
	procs; opt; flatten; opt; 
	techmap; opt;
	dfflibmap -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib
	abc -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib -script ../../SynthesisLibrary/lib_EMP/script.abc; 
	opt; clean; opt;
	opt_clean -purge
	stat -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys_area.lib
	write_verilog -noattr -noexpr -nohex syn/add_${N}bit.v
}
