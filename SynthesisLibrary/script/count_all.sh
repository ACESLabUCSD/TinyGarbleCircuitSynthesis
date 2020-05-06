#!/bin/bash
for verilogfile in $1/*.v
do
	printf "$verilogfile: "
	grep -w -c 'AND\|ANDN\|NAND\|NANDN\|OR\|ORN\|NOR\|NORN\|MUX\|FA\|HA\|HADDER\|FADDER' $verilogfile 
done
wait