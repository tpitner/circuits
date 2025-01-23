#!/bin/bash
ENTITY=$1
ENTITY_tb=$1_tb
gomplate -f tb.vhd.tmpl -c.=$ENTITY.yaml > $ENTITY_tb.vhd
ghdl -a --std=08 $ENTITY.vhd
ghdl -a --std=08 $ENTITY_tb.vhd
ghdl -r --std=08 $ENTITY_tb | highlight_errors
