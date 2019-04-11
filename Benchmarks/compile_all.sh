#!/bin/bash
mkdir -p syn_all
for d in *
do
	( cd "$d" && ./compile.sh && rm *.pvl *.syn *.mr *.log *.svf && cd ".." && cp ${d%/*}/syn/*.v syn_all)	
done
rm *.log