vlog -reportprogress 300 -work work ../div/*div_nm_2_n.sv
vsim -gui work.tb_div_nm_2_n -L TG_SynLib

add wave  \
sim:/tb_div_nm_2_n/g_input \
sim:/tb_div_nm_2_n/e_input \
sim:/tb_div_nm_2_n/o \
sim:/tb_div_nm_2_n/o_ref

run -all