#!/bin/bash
ghdl -a inc/vcordic.vhd
ghdl -a src/euler.vhd
ghdl -a sim/euler_tb.vhd
ghdl -e euler_tb
echo run euler_tb
ghdl -r euler_tb --stop-time=1us --wave=sim/euler.ghw
gtkwave sim/euler.ghw
ghdl --clean
rm sim/euler.ghw work-obj93.cf