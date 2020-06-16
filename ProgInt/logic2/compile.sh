mkdir -p syn
yosys -c logic2.tcl

for verilogfile in syn/*.v
do
	empfile=${verilogfile%.*}.emp
	../../Verilog2EMP/bin/V2EMP_Main -i $verilogfile -o $empfile --log2std
	../../../tinygarble2/bin/readCircuitFile -i  $empfile &
done
wait

cp syn/*.bin ../../../tinygarble2/tinygarble/netlists_pi/ 