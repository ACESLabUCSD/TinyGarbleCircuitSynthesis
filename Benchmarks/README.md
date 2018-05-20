# Benchmarks
This directory contains implementations of benchmark functions 2-party GC.

For multi-party benchmarks visit [here](https://github.com/sadeghriazi/mpc-circuits).

## Compile a benchmark
Go inside `benchmark`, where benchmark is the name of the function
and compile the benchmark to generate the netlist:
```
	$ cd benchmark
	$ ./compile
```

By default, it creates `benchmark_syn.v` in the directory `benchmark/syn`. 

