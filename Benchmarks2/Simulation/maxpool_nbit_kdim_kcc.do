vlog -reportprogress 300 -work work ../maxpool/*.sv
vsim -gui work.tb_maxpool_nbit_kdim_kcc -L TG_SynLib

add wave  \
sim:/tb_maxpool_nbit_kdim_kcc/clk \
sim:/tb_maxpool_nbit_kdim_kcc/rst \
sim:/tb_maxpool_nbit_kdim_kcc/s_input \
sim:/tb_maxpool_nbit_kdim_kcc/o \
sim:/tb_maxpool_nbit_kdim_kcc/O_ref \

run -all