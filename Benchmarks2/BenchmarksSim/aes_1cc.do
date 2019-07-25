vlog -reportprogress 300 -work work ../aes/*.sv
vsim -gui work.tb_aes_11cc -L TG_SynLib

run -all