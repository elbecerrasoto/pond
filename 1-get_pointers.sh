#!/usr/bin/env zsh


# get taxon
taxon='burkholderia' # genus
taxon_metadata="${taxon}.tsv"

# filter taxon
filter='cenocepacia' # species
n_samples="$1"
pointers="${filter}.txt"

if [[ "$#" != 1 ]]
then
    printf 'Provide n_samples\n' >&2
    printf 'As first argument\n' >&2
    exit 1
fi


function get_taxon ()
{
    datasets summary genome taxon "${taxon}" --assembly-source refseq --as-json-lines | dataformat tsv genome --fields 'accession,organism-name,annotinfo-release-date' |> "${taxon_metadata}"
}

function filter_taxon()
{
    sed -n "/$filter/p" burkholderia.tsv | cut -f1 -d$'\t' >| $pointers 
}

get_taxon
filter_taxon
