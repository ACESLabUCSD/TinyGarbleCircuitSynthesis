mkdir -p syn
yosys -c mac.tcl

for verilogfile in syn/*.v
do
  scdfile=${verilogfile%.*}.scd
  ../../../../TinyGarble-ES/bin/scd/V2SCD_Main -i $verilogfile -o $scdfile --log2std 
done 
