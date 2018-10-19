#!/bin/bash
echo "$1"


grep -w -c 'AND' $1
grep -w -c 'ANDN' $1
grep -w -c 'NAND' $1
grep -w -c 'NANDN' $1
grep -w -c 'OR' $1
grep -w -c 'ORN' $1
grep -w -c 'NOR' $1
grep -w -c 'NORN' $1
grep -w -c 'MUX' $1
grep -w -c 'FA' $1
grep -w -c 'HA' $1
grep -w -c 'HADDER' $1
grep -w -c 'XOR' $1
grep -w -c 'XNOR' $1
grep -w -c 'IV' $1
grep -w -c 'DFF' $1

echo -n "total non-XOR: "
grep -w -c 'AND\|ANDN\|NAND\|NANDN\|OR\|ORN\|NOR\|NORN\|MUX\|FA\|HA\|HADDER' $1
echo -n "total XOR: "
grep -w -c 'XOR\|XNOR\|IV\|DFF' $1