#!/usr/bin/env python3

# Depends on ncbi-datasets-cli
# Install with
# mamba install -y -c conda-forge ncbi-datasets-cli

import argparse
import subprocess as sp
from pathlib import Path
from icecream import ic
from shlex import split, join

DESCRIPTION = """Wrapper for ncbi-datasets-cli

    under the hood:
        datasets download genome accession --help

    install:
        mamba install -y -c conda-forge ncbi-datasets-cli
"""

parser = argparse.ArgumentParser(
    description=DESCRIPTION, formatter_class=argparse.RawDescriptionHelpFormatter
)
parser.add_argument("genome", help="NCBI accession")
parser.add_argument("-o", "--out-dir", help="Default: genome")
parser.add_argument("-n", "--dry-run", action="store_true")
parser.add_argument("-d", "--debug", action="store_true")
args = parser.parse_args()


GENOME = args.genome
OUT_DIR = Path(GENOME) if args.out_dir is None else Path(args.out_dir)

DRY = args.dry_run
DEBUG = args.debug

INCLUDE = "genome,protein,gff3"

# --include string(,string)   Specify the data files to include (comma-separated).
#                               * genome:     genomic sequence
#                               * rna:        transcript
#                               * protein:    amnio acid sequences
#                               * cds:        nucleotide coding sequences
#                               * gff3:       general feature file
#                               * gtf:        gene transfer format
#                               * gbff:       GenBank flat file
#                               * seq-report: sequence report file
#                               * none:       do not retrieve any sequence files
#                                (default [genome])


if DEBUG:
    ic(args)

if __name__ == "__main__":
    ZIP = OUT_DIR / (GENOME + ".zip")
    DATASETS = split(
        f"datasets download genome accession {GENOME} --filename {ZIP} --include {INCLUDE}"
    )
    UNZIP = split(f"unzip -nq {ZIP} -d {OUT_DIR}")

    if DEBUG:
        ic(ZIP)
        ic(INCLUDE)
        ic(DATASETS)
        ic(UNZIP)

    if not DRY:
        OUT_DIR.mkdir(parents=True, exist_ok=True)

        sp.run(DATASETS, check=True)

        sp.run(UNZIP, check=True)

        # remames
        # removes

    else:
        print("DRY RUN\nActions that would've run:\n")
        print(f"mkdir -p {OUT_DIR}")
        print(join(DATASETS))
        print(join(UNZIP))
