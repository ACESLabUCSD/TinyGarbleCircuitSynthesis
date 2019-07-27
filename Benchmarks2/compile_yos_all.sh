#!/bin/bash
mkdir -p syn_all
echo "./compile_yos_all.sh. use -s to skip synthesis" 
if [ "$1" == "-s" ]
then 
	echo "skipping synthesis"
else 
	for d in *
	do
		( cd "$d" && ./compile_yos.sh  && cd ".." && cp ${d%/*}/syn/*_yos.v syn_all)	
	done
fi
for verilogfile in syn_all/*.v
do
  empfile=${verilogfile%.*}.emp
  ../Verilog2EMP/bin/V2EMP_Main -i $verilogfile -o $empfile --log2std 
done
wait