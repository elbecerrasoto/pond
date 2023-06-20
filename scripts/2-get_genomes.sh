#!/usr/bin/env zsh

pointers="$1"
# 0 run as much as possible, 1 job per CPU
# NCBI fails if trying too many, 4 should be fine
batch=8


if [[ "$#" != 1 ]]
then
    printf 'Provide NCBI accession file\n' >&2
    printf 'As first argument\n' >&2
    exit 1
fi

datasets='datasets download genome accession {} --no-progressbar --include protein --filename data/{}/{}.zip'

parallel -j"$batch" "mkdir -p data/{} && $datasets && unzip -nq data/{}/{}.zip -d data/{}" :::: "$pointers"


rm_zip_readme="/bin/rm data/{}/{}.zip data/{}/README.md"
rename_protein="mv data/{}/ncbi_dataset/data/{}/protein.faa data/{}/{}.faa"
rm_ncbi="/bin/rm -r data/{}/ncbi_dataset"

parallel "$rm_zip_readme && $rename_protein && $rm_ncbi" :::: "$pointers"
