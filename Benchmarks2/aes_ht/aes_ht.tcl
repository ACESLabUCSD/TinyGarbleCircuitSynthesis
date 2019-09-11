yosys -import

read_verilog -sv aes_ht_0.sv AddRoundKey.sv SubBytes.sv  ShiftRows.sv  MixColumns.sv  KeyExpansion_ht.sv
hierarchy -check -top aes_ht_0 
procs; opt; flatten; opt; 
techmap; opt;
dfflibmap -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib
abc -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib -script ../../SynthesisLibrary/lib_EMP/script.abc; 
opt; clean; opt;
opt_clean -purge
stat -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys_area.lib
write_verilog -noattr -noexpr -nohex syn/aes_ht_0_syn.v

foreach COUNTER [list 1 2 3 4 5 6 7 8 9] { 
	read_verilog -overwrite -defer -sv  aes_ht_1.sv AddRoundKey.sv SubBytes.sv  ShiftRows.sv  MixColumns.sv  KeyExpansion_ht.sv 
	hierarchy -check -top aes_ht_1 -chparam COUNTER ${COUNTER} 
	procs; opt; flatten; opt; 
	techmap; opt;
	dfflibmap -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib
	abc -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib -script ../../SynthesisLibrary/lib_EMP/script.abc; 
	opt; clean; opt;
	opt_clean -purge
	stat -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys_area.lib
	write_verilog -noattr -noexpr -nohex syn/aes_ht_${COUNTER}_syn.v
}

read_verilog -sv aes_ht_10.sv AddRoundKey.sv SubBytes.sv  ShiftRows.sv  MixColumns.sv  KeyExpansion_ht.sv
hierarchy -check -top aes_ht_10 
procs; opt; flatten; opt; 
techmap; opt;
dfflibmap -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib
abc -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib -script ../../SynthesisLibrary/lib_EMP/script.abc; 
opt; clean; opt;
opt_clean -purge
stat -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys_area.lib
write_verilog -noattr -noexpr -nohex syn/aes_ht_10_syn.v