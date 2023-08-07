#!/usr/bin/env zsh


# get taxon
taxon='burkholderia' # genus
taxon_metadata="${taxon}.tsv"


# filter taxon
filter='cenocepacia' # species
pointers="${filter}.txt"


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
