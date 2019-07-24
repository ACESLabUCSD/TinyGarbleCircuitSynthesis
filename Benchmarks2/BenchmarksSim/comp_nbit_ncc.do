vlog -reportprogress 300 -work work ../compare/*comp_nbit_ncc.sv
vsim -gui work.tb_comp_nbit_ncc -L TG_SynLib

add wave  \
sim:/tb_comp_nbit_ncc/G \
sim:/tb_comp_nbit_ncc/E \
sim:/tb_comp_nbit_ncc/O \
sim:/tb_comp_nbit_ncc/O_ref

run -all