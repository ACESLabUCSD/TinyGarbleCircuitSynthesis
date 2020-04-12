yosys -import

foreach N [list 15] {
	foreach M [list 17] {
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

foreach N [list 14] {
	foreach M [list 20] {
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

foreach N [list 24] {
	foreach M [list 15] {
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

foreach N [list 28] {
	foreach M [list 14] {
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