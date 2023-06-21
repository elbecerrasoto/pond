#!/usr/bin/env zsh

# Assumes that
# interproscan.sh is installed

genome="$1"
out_dir="$2"
cpus="$3"
pfam_only=${4:-TRUE}


if [[ "$#" !=  3 ]] && [[ "$#" != 4 ]]
then
    printf 'Wrong argument number: accepting only 3 or 4\n' >&2
    printf "$0 genome out_dir cpus [pfam_only: TRUE | FALSE]\n" >&2
    exit 1
fi


if [[ "$pfam_only" != "TRUE" ]] && [[ "$pfam_only" != "FALSE" ]]
then
    printf 'Wrong argument: pfam_only must be TRUE or FALSE\n' >&2 
    exit 1
fi


mkdir -p "$out_dir"
annotation="`fd -d 1 -e xml . $out_dir`"


# If there is NOT an annotation
if [[ -z "$annotation" ]]
then
    if [[ "$pfam_only" == "TRUE" ]]
    then

        interproscan.sh --cpu $cpus --input $genome --output-dir $out_dir ---disable-precalc --applications Pfam

    elif [[ "$pfam_only" == "FALSE" ]]
    then

        interproscan.sh --cpu $cpus --input $genome --output-dir $out_dir --disable-precalc

    fi
fi
