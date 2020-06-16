mkdir -p syn
design_vision -no_gui -f mac.dcsh
rm *.pvl *.syn *.mr *.log *.svf

for verilogfile in syn/*.v
do
  scdfile=${verilogfile%.*}.scd
  ../../../../TinyGarble-ES/bin/scd/V2SCD_Main -i $verilogfile -o $scdfile --log2std 
done 
