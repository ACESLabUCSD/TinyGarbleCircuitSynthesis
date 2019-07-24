vlog -reportprogress 300 -work work ../sum/*sum_nbit_ncc.sv
vsim -gui work.tb_sum_nbit_ncc -L TG_SynLib

add wave  \
sim:/tb_sum_nbit_ncc/clk \
sim:/tb_sum_nbit_ncc/rst \
sim:/tb_sum_nbit_ncc/g_input \
sim:/tb_sum_nbit_ncc/e_input \
sim:/tb_sum_nbit_ncc/o \

run -all