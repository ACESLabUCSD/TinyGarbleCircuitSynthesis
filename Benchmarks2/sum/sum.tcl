yosys -import

foreach N [list 8 16 32 128 256 1024] {
	read_verilog -overwrite -defer ../../SynthesisLibrary/syn_lib/*.v 
	read_verilog -overwrite -defer -sv  sum_nbit_1cc.sv
	hierarchy -check -top sum_nbit_1cc -chparam N $N 
	procs; opt; flatten; opt; 
	techmap; opt;
	dfflibmap -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib
	abc -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib -script ../../SynthesisLibrary/lib_EMP/script.abc; 
	opt; clean; opt;
	opt_clean -purge
	stat -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys_area.lib
	write_verilog -noattr -noexpr -nohex syn/sum_${N}bit\_1cc_syn.v
}


read_verilog -overwrite ../../SynthesisLibrary/syn_lib/*.v 
read_verilog -sv sum_nbit_ncc.sv
hierarchy -check -top sum_nbit_ncc 
procs; opt; flatten; opt; 
techmap; opt;
dfflibmap -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib
abc -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib -script ../../SynthesisLibrary/lib_EMP/script.abc; 
opt; clean; opt;
opt_clean -purge
stat -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys_area.lib
write_verilog -noattr -noexpr -nohex syn/sum_nbit\_ncc_syn.v