#!/usr/bin/env Rscript

# Redirect stderr to /dev/null
SUPRESS_STDERR = T
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

ARGS <- parser$parse_args()

if (SUPRESS_STDERR)
{
  null <- file(nullfile(), open="w")
  sink(null, type="message")
  
}

TSV <- ARGS$tsv
IDS <- read_tsv(ARGS$ids, comment = "#", col_names = FALSE)[[1]]
FAA <- ARGS$faa

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
            "interpro_txt")


annotation <- read_tsv(TSV, col_names=HEADER)

tmp <- paste0(TSV, ".hits")

# ANY hit
annotation %>%
  filter(interpro %in% IDS) %>%
  distinct(protein) %>%
  write_tsv(file = tmp, col_names = FALSE)

out <-  paste0(FAA, ".tox.faa")
cmd <- paste0("fasta_grep --tab=",
              tmp, " ", FAA, " >| ", out)
# just print the command to avoid complexities
# of running it from this R script
cat(cmd)

if (SUPRESS_STDERR)
{
  sink()
}