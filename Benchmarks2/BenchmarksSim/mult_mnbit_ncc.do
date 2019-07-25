vlog -reportprogress 300 -work work ../mult/*mult_mnbit_ncc.sv
vsim -gui work.tb_mult_mnbit_ncc -L TG_SynLib

add wave  \
sim:/tb_mult_mnbit_ncc/G \
sim:/tb_mult_mnbit_ncc/g_input \
sim:/tb_mult_mnbit_ncc/e_init \
sim:/tb_mult_mnbit_ncc/o \
sim:/tb_mult_mnbit_ncc/O \
sim:/tb_mult_mnbit_ncc/O_ref

run -all