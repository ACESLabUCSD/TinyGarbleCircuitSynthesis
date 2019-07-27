#!/bin/bash
mkdir -p syn

design_vision -no_gui -f comp.dcsh
rm *.pvl *.syn *.mr *.log *.svf

../../Verilog2EMP/bin/V2EMP_Main -i syn/aes_11cc_syn.v -o syn/aes_11cc_syn.emp --log2std
../../Verilog2EMP/bin/V2EMP_Main -i syn/aes_11cc_syn.v -o syn/aes_11cc_syn.emp --log2std