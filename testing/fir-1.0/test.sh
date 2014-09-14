#!/bin/bash
ghdl -a src/fir.vhd
ghdl -a inc/fir_coeff.vhd
ghdl -a test/fir_matlab.vhd
ghdl -e fir_matlab
cp fir_matlab test/
ghdl --clean
rm work-obj93.cf