yosys -import

foreach N [list 28] {
	read_verilog -overwrite -defer ../../SynthesisLibrary/syn_lib/*.v 
	read_verilog -overwrite -defer -sv  relu.sv
	hierarchy -check -top relu -chparam N $N 
	procs; opt; flatten; opt; 
	techmap; opt;
	dfflibmap -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib
	abc -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib -script ../../SynthesisLibrary/lib_EMP/script.abc; 
	opt; clean; opt;
	opt_clean -purge
	stat -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys_area.lib
	write_verilog -noattr -noexpr -nohex syn/relu_${N}bit.v
}