vlog -reportprogress 300 -work work ../vdp/*.sv
vsim -gui work.tb_vdp_nnbit_kdim_kcc -L TG_SynLib

add wave  \
sim:/tb_vdp_nnbit_kdim_kcc/clk \
sim:/tb_vdp_nnbit_kdim_kcc/rst \
sim:/tb_vdp_nnbit_kdim_kcc/g_input \
sim:/tb_vdp_nnbit_kdim_kcc/e_input \
sim:/tb_vdp_nnbit_kdim_kcc/o \
sim:/tb_vdp_nnbit_kdim_kcc/O_ref \

run -all