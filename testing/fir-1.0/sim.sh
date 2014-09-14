#!/bin/bash
ghdl -a src/fir.vhd
ghdl -a inc/fir_coeff.vhd
ghdl -a sim/fir_simpletest.vhd
ghdl -e fir_simpletest
echo run fir_simpletest
ghdl -r fir_simpletest --stop-time=5ms --wave=sim/fir.ghw
gtkwave sim/fir.ghw
ghdl --clean
rm sim/fir.ghw work-obj93.cf