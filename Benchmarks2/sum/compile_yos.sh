mkdir -p syn

yosys -s sum_nbit_1cc.yos 
yosys -s sum_nbit_ncc.yos

../../Verilog2EMP/bin/V2EMP_Main -i syn/sum_nbit_1cc_syn_yos.v -o syn/sum_nbit_1cc_syn_yos.emp --log2std
../../Verilog2EMP/bin/V2EMP_Main -i syn/sum_nbit_ncc_syn_yos.v -o syn/sum_nbit_ncc_syn_yos.emp --log2std