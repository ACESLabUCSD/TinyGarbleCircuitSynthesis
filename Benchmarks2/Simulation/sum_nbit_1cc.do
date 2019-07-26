vlog -reportprogress 300 -work work ../sum/*sum_nbit_1cc.sv
vsim -gui work.tb_sum_nbit_1cc -L TG_SynLib

add wave  \
sim:/tb_sum_nbit_1cc/g_input \
sim:/tb_sum_nbit_1cc/e_input \
sim:/tb_sum_nbit_1cc/o \
sim:/tb_sum_nbit_1cc/o_ref

run -all