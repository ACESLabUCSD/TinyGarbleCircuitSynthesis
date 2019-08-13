vlog -reportprogress 300 -work work ../aes_ht/*.sv
vsim -gui work.tb_aes_ht -L TG_SynLib

run -all