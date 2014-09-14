#!/bin/bash
ghdl -a src/dfir.vhd
ghdl -a inc/dfir_coeff.vhd
ghdl -a test/dfir_matlab.vhd
ghdl -e dfir_matlab
cp dfir_matlab test/
ghdl --clean
rm work-obj93.cf