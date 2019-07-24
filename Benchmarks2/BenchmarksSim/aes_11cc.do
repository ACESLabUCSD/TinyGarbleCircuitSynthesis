vlog -reportprogress 300 -work work ../aes/*.v
vsim -gui work.tb_aes_1cc -L TG_SynLib

run -all