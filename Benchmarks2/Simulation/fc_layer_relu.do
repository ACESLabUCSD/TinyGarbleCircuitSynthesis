vlog -reportprogress 300 -work work ../fc_layer/*.sv
vsim -gui work.tb_mxv_nnbit_jkdim_relu -L TG_SynLib

run -all