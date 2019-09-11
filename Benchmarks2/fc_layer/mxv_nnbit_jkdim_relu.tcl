yosys -import

foreach N [list 4 8 16] {
	foreach K [list 3 5 7 9] {
		read_verilog -overwrite -defer ../../SynthesisLibrary/syn_lib/*.v 
		read_verilog -overwrite -defer -sv  mxv_nnbit_jkdim_relu.sv mxv_nnbit_jkdim.sv mac_comb.sv 
		hierarchy -check -top mxv_nnbit_jkdim_relu -chparam N $N -chparam J $K -chparam K $K
		procs; opt; flatten; opt; 
		techmap; opt;
		dfflibmap -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib
		abc -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib -script ../../SynthesisLibrary/lib_EMP/script.abc; 
		opt; clean; opt;
		opt_clean -purge
		stat -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys_area.lib
		write_verilog -noattr -noexpr -nohex syn/mxv_${N}_${N}_bit_${K}_${K}_dim_relu.v
	}
}