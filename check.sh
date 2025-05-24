#!/bin/bash

set -e

MODULE=hello

sudo insmod ${MODULE}.ko

declare -a chars=(
    [0]=72  # H
    [1]=101 # e
    [2]=108 # l
    [3]=108 # l
    [4]=111 # o
    [5]=44  # ,
    [6]=32  #
    [7]=87  # W
    [8]=111 # o
    [9]=114 # r
    [10]=108 # l
    [11]=100 # d
    [12]=33  # !
)

for i in "${!chars[@]}"; do
    echo $i | sudo tee /sys/module/${MODULE}/parameters/idx
    echo ${chars[$i]} | sudo tee /sys/module/${MODULE}/parameters/ch_val
done


result=$(cat /sys/module/${MODULE}/parameters/my_str)
echo "Outcome: $result"

if [ "$result" == "Hello, World!" ]; then
    echo "Test has passed."
else
    echo "Test has not been passed."
    exit 1
fi

sudo rmmod ${MODULE}
