mkdir -p syn

if [ $1 ] && [ $1 = "-s" ]; then
	design_vision -no_gui -f mxv_nnbit_jkdim_relu.dcsh
	rm *.pvl *.syn *.mr *.log *.svf
else
	yosys -c mxv_nnbit_jkdim_relu.tcl
fi

for verilogfile in syn/*.v
do
  empfile=${verilogfile%.*}.emp
  ../../Verilog2EMP/bin/V2EMP_Main -i $verilogfile -o $empfile --log2std 
done 
