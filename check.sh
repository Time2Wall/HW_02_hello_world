#!/bin/bash

set -e

MODULE=hello

sudo insmod ${MODULE}.ko

declare -a chars=(
    [0]="H"
    [1]="e"
    [2]="l"
    [3]="l"
    [4]="o"
    [5]=","
    [6]=" "
    [7]="W"
    [8]="o"
    [9]="r"
    [10]="l"
    [11]="d"
    [12]="!"
)

for i in "${!chars[@]}"; do
    echo $i | sudo tee /sys/module/${MODULE}/parameters/idx > /dev/null
    echo -n "${chars[$i]}" | sudo tee /sys/module/${MODULE}/parameters/ch_val > /dev/null
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
