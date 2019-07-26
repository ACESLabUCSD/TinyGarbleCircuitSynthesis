vlib TG_SynLib
vmap TG_SynLib TG_SynLib
vlog -reportprogress 300 -work TG_SynLib ../../SynthesisLibrary/syn_lib/*.v

vlib work
vmap work work