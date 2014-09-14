#!/bin/bash
ghdl -m fir_matlab
echo run fir_matlab
ghdl -r fir_matlab --stop-time=5ms --wave=fir.ghw
gtkwave fir.ghw