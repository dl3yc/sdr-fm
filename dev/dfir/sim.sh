#!/bin/bash
ghdl -m dfir_matlab
echo run dfir_matlab
ghdl -r dfir_matlab --stop-time=5ms --wave=dfir.ghw
gtkwave dfir.ghw