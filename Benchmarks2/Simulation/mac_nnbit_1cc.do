vlog -reportprogress 300 -work work ../vdp/*mac_nnbit_1cc.sv
vsim -gui work.tb_mac_nnbit_1cc -L TG_SynLib

add wave  \
sim:/tb_mac_nnbit_1cc/clk \
sim:/tb_mac_nnbit_1cc/rst \
sim:/tb_mac_nnbit_1cc/g_input \
sim:/tb_mac_nnbit_1cc/e_input \
sim:/tb_mac_nnbit_1cc/o \
sim:/tb_mac_nnbit_1cc/o_ref \

run -all