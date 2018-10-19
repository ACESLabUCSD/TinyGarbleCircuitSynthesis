Circuit Synthesis for Yao's Garbled Circuit by TinyGarble
=======
### This is the standalone circuit synthesis library of [TinyGarble](https://github.com/esonghori/TinyGarble) [1]. Besides the TinyGarble framework, currently, it supports the [EMP Toolkit](https://github.com/emp-toolkit) [2] and [Semi-Honest-BMR](https://github.com/cryptobiu/Semi-Honest-BMR) [3].

## Steps:

1. Write a Verilog file (`.v`) describing the function. 
You can utilize the free-XOR optimized implementations of common arithmetic and logical operations provided in the [syn_lib](/SynthesisLibrary/syn_lib/). 
2. Write a wrapper according to the template provided inside 
[Verilog2SCD](/Verilog2BMR), [Verilog2EMP](/Verilog2BMR) or [Verilog2BMR](/Verilog2BMR)
for executing with TinyGarble, EMP Toolkit, and Semi-Honest-BMR respectively. 
3. Synthesize the Verilog file using TinyGarble's [Synthesis Library](/SynthesisLibrary) to generate
a netlist Verilog file (`.v`). It supports synthesis with [Synopsys Design Compiler](https://www.synopsys.com/support/training/rtl-synthesis/design-compiler-rtl-synthesis.html) or [Yosys-ABC](http://www.clifford.at/yosys/).
4. Translate the netlist file (`.v`) to a circuit description file compatible with the respective framework
following the instructions inside [Verilog2SCD](/Verilog2BMR), [Verilog2EMP](/Verilog2BMR) or [Verilog2BMR](/Verilog2BMR)
for executing with TinyGarble, EMP Toolkit, and Semi-Honest-BMR respectively.
5. Execute the respective framework with the compiled circuit description file. 

Detailed instruction for each step is provided inside the respective directories. 

##

The [Benchmarks](/Benchmarks) directory contains implementations of benchmark functions for 2-party GC.
For multi-party benchmarks visit [here](https://github.com/sadeghriazi/mpc-circuits).

## References
[1] Ebrahim M. Songhori, Siam U. Hussain, Ahmad-Reza Sadeghi, Thomas Schneider
and Farinaz Koushanfar, ["TinyGarble: Highly Compressed and Scalable Sequential
Garbled Circuits."](http://esonghori.github.io/file/TinyGarble.pdf) <i>Security
and Privacy, 2015 IEEE Symposium on</i> May, 2015.

[2] Xiao Wang and Alex J. Malozemoff and Jonathan Katz.
"EMP-toolkit: Efficient MultiParty computation toolkit.", 2016.

[3] Ben-Efraim, Aner, Yehuda Lindell, and Eran Omri. 
"Optimizing semi-honest secure multiparty computation for the internet."
Proceedings of the 2016 ACM SIGSAC Conference on Computer and Communications Security. ACM, 2016.
