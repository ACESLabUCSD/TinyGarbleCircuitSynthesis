vlog -reportprogress 300 -work work ../hamming/*.sv
vsim -gui work.tb_hamming_nbit_ncc -L TG_SynLib

add wave  \
sim:/tb_hamming_nbit_ncc/G \
sim:/tb_hamming_nbit_ncc/E \
sim:/tb_hamming_nbit_ncc/O \
sim:/tb_hamming_nbit_ncc/O_ref

run -all