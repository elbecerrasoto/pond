#!/usr/bin/env Rscript

suppressMessages(library(seqinr))
suppressMessages(library(tidyverse))
library(argparse)


parser <- ArgumentParser(description="Print cmd to extract proteins from a FASTA\n
                                      the filteriing is done\n
                                      using IntreproScan 5 TSV and a TXT of Interpro IDs")

parser$add_argument("tsv", type="character", nargs=1,
                    help="File containing the annotation from InterProScan 5 on TSV")


parser$add_argument("ids", type="character", nargs=1,
                    help="File of the interpro IDs to filter,\n
                    one interpro ID per line, use '#' to comment\n ")

parser$add_argument("faa", type="character", nargs=1,
                    help="FASTA aminoacid to filter")

# ARGS <- parser$parse_args()


# TSV <- ARGS$tsv
# IDS <- ARGS$ids
# FAA <- ARGS$faa


TSV <- "../2-pfams/GCF_001991475.1.pfam.tsv"
IDS <-  "../input_pfams.txt"
FAA <- "../1-genomes/GCF_001991475.1/GCF_001991475.1.faa"


HEADER <- c("protein",
            "md5",
            "lenght",
            "analysis",
            "memberDB",
            "memberDB_txt",
            "start",
            "end",
            "score",
            "status",
            "date",
            "interpro",
            "interpro_txt",
            "GOs",
            "pathways")


parse_ids <- function (path2ids)
{
  read_tsv(IDS, comment = "#", col_names = "interpro", col_types = "c")[[1]]
}

# problems(annotation) some rows with 13 rows, expected 15
annotation <- suppressWarnings(read_tsv(TSV, col_names=HEADER, show_col_types = FALSE))
ids <- parse_ids(IDS)


hits <-
annotation %>%
  filter(interpro %in% ids) %>%
  distinct(protein)

hits <- hits[[1]]

faa <- read.fasta(FAA, seqtype="AA", forceDNAtolower = FALSE, strip.desc = TRUE)
faa_hits <- faa[hits]

faa_hits_headers <- map(faa_hits, attr, which = "Annot") %>%
  str_c(paste0(" ", "source=", basename(FAA)))

# nbchar = 80 to make it equal to ncbi source
write.fasta(faa_hits, names = faa_hits_headers, nbchar = 80, file.out = "test.faa")
