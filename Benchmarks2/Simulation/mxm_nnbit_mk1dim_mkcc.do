vlog -reportprogress 300 -work work ../vdp/*.sv
vsim -gui work.tb_mxm_nnbit_mk1dim_mkcc -L TG_SynLib

add wave  \
sim:/tb_mxm_nnbit_mk1dim_mkcc/clk \
sim:/tb_mxm_nnbit_mk1dim_mkcc/rst \
sim:/tb_mxm_nnbit_mk1dim_mkcc/m \
sim:/tb_mxm_nnbit_mk1dim_mkcc/l \
sim:/tb_mxm_nnbit_mk1dim_mkcc/g_input \
sim:/tb_mxm_nnbit_mk1dim_mkcc/e_input \
sim:/tb_mxm_nnbit_mk1dim_mkcc/o \
sim:/tb_mxm_nnbit_mk1dim_mkcc/O_ref \

run -all

