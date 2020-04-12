yosys -import

foreach N [list 5 8 16 20 24 30 32 64] {
	read_verilog -overwrite -defer ../../SynthesisLibrary/syn_lib/*.v 
	read_verilog -overwrite -defer -sv  max.sv
	hierarchy -check -top max -chparam N $N 
	procs; opt; flatten; opt; 
	techmap; opt;
	dfflibmap -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib
	abc -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib -script ../../SynthesisLibrary/lib_EMP/script.abc; 
	opt; clean; opt;
	opt_clean -purge
	stat -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys_area.lib
	write_verilog -noattr -noexpr -nohex syn/max_${N}bit.v
}