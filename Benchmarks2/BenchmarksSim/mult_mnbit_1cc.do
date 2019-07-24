vlog -reportprogress 300 -work work ../mult/*mult_mnbit_1cc.sv
vsim -gui work.tb_mult_mnbit_1cc -L TG_SynLib

add wave  \
sim:/tb_mult_mnbit_1cc/g_input \
sim:/tb_mult_mnbit_1cc/e_input \
sim:/tb_mult_mnbit_1cc/o \
sim:/tb_mult_mnbit_1cc/o_ref

run -all