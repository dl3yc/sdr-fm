#!/bin/bash
ghdl -a src/dfir.vhd
ghdl -a inc/dfir_coeff.vhd
ghdl -a sim/dfir_simpletest.vhd
ghdl -e dfir_simpletest
echo run dfir_simpletest
ghdl -r dfir_simpletest --stop-time=5ms --wave=sim/dfir.ghw
gtkwave sim/dfir.ghw
ghdl --clean
rm sim/dfir.ghw work-obj93.cf