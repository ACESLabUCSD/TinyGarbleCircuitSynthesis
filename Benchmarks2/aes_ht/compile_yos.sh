mkdir -p syn

yosys -s aes_1cc.yos 
#yosys -s aes_11cc.yos

../../Verilog2EMP/bin/V2EMP_Main -i syn/aes_1cc_syn_yos.v -o syn/aes_1cc_syn_yos.emp --log2std
#../../Verilog2EMP/bin/V2EMP_Main -i syn/aes_11cc_syn_yos.v -o syn/aes_11cc_syn_yos.emp --log2std