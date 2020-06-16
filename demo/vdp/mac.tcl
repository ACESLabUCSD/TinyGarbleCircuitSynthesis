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