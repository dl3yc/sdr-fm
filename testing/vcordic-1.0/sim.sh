#!/bin/bash
ghdl -a src/vcordic.vhd
ghdl -a sim/vcordic_tb.vhd
ghdl -e vcordic_tb
echo run vcordic_tb
ghdl -r vcordic_tb --stop-time=1us --wave=sim/vcordic.ghw
gtkwave sim/vcordic.ghw
ghdl --clean
rm sim/vcordic.ghw work-obj93.cf