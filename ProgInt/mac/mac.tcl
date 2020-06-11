yosys -import

for {set N 2} {$N < 65} {incr N} {
	for {set M 2} {$M < 65} {incr M} {
		read_verilog -overwrite -defer ../../SynthesisLibrary/syn_lib/*.v 
		read_verilog -overwrite -defer -sv  mac.sv 
		hierarchy -check -top mac -chparam N $N -chparam M $M
		procs; opt; flatten; opt; 
		techmap; opt;
		dfflibmap -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib
		abc -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib -script ../../SynthesisLibrary/lib_EMP/script.abc; 
		opt; clean; opt;
		opt_clean -purge
		stat -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys_area.lib
		write_verilog -noattr -noexpr -nohex syn/mac_${N}_${M}_64bit.v
	}
}