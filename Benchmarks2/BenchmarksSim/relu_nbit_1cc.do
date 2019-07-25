vlog -reportprogress 300 -work work ../relu/*relu_nbit_1cc.sv
vsim -gui work.tb_relu_nbit_1cc -L TG_SynLib

add wave  \
sim:/tb_relu_nbit_1cc/s_input \
sim:/tb_relu_nbit_1cc/o \
sim:/tb_relu_nbit_1cc/o_ref

run -all