#!/bin/bash
ghdl -m $1
ghdl -r $1 --wave=$1".ghw"  --stop-time=100us
echo "view" $1".ghw"
gtkwave $1".ghw"
ghdl --clean
rm *.ghw