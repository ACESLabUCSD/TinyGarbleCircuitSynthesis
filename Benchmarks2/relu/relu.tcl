yosys -import

foreach N [list 9 17 19 21 23 33 35 37 39 65 67 69 71] {
	read_verilog -overwrite -defer ../../SynthesisLibrary/syn_lib/*.v 
	read_verilog -overwrite -defer -sv  relu_nbit_1cc.sv
	hierarchy -check -top relu_nbit_1cc -chparam N $N 
	procs; opt; flatten; opt; 
	techmap; opt;
	dfflibmap -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib
	abc -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib -script ../../SynthesisLibrary/lib_EMP/script.abc; 
	opt; clean; opt;
	opt_clean -purge
	stat -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys_area.lib
	write_verilog -noattr -noexpr -nohex syn/relu_${N}bit\_1cc_syn.v
}