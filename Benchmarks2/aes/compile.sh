#!/bin/bash
mkdir -p syn

design_vision -no_gui -f aes.dcsh
rm *.pvl *.syn *.mr *.log *.svf

../../Verilog2EMP/bin/V2EMP_Main -i syn/sum_nbit_1cc_syn.v -o syn/sum_nbit_1cc_syn.emp --log2std
../../Verilog2EMP/bin/V2EMP_Main -i syn/sum_nbit_ncc_syn.v -o syn/sum_nbit_ncc_syn.emp --log2std