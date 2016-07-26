#!/bin/bash

if [ $# -lt 1 ]; then
    echo 'no enough arguments';
    echo 'eg.: ./txt2seg.sh  dir'
    exit 1;
fi

    txt=$(find $1 -type f  -iname '*.txt')

for i in $txt
do
    echo $i
    awk '{print $1,$2}' $i > ${i%.txt}.seg
done
