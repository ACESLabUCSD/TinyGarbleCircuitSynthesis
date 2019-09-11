echo "Use -d to compile with Synopsys Design Compiler"

mkdir -p syn

if [ $1 ] && [ $1 = "-d" ]; then
	design_vision -no_gui -f sum.dcsh
	rm *.pvl *.syn *.mr *.log *.svf
else
	yosys -c sum.tcl
fi

for verilogfile in syn/*.v
do
  empfile=${verilogfile%.*}.emp
  ../../Verilog2EMP/bin/V2EMP_Main -i $verilogfile -o $empfile --log2std 
done 
