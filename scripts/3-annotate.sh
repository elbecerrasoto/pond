#!/usr/bin/env zsh

# for my machine this settings work
# 6 batch x 7 cpu
# doing 256

genome="$1"
out_dir="$2"
cpus="$3" # cpus per iscan
iscan_bin="/home/ebecerra/4-env/bin/source/interproscan-5.61-93.0/interproscan.sh"


if [[ "$#" !=  3 ]]
then
    printf 'Args missing\n' >&2
    printf 'This script takes two positional args\n' >&2
    printf 'genome.faa and out_dir\n' >&2
    exit 1
fi


if [[ ! -f "$iscan_bin" ]]
then
    printf 'NO interproscan binary\n' >&2
    exit 2
fi

annotation=`fd -d 1 -e xml . $out_dir`

# If there is NOT an annotation
if [[ -z "$annotation" ]]
then
    mkdir -p "$out_dir"
    # --disable-precalc good on a many analyses, bad on single
    "$iscan_bin" --cpu "$cpus" --input "$genome" --output-dir "$out_dir"
fi
