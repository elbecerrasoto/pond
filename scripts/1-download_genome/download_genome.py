#!/usr/bin/env python3

# Depends on ncbi-datasets-cli
# Install with
# mamba install -y -c conda-forge ncbi-datasets-cli

import argparse
import subprocess as sp
from pathlib import Path
from icecream import ic
from shlex import split, join
import shutil

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
parser.add_argument("-o", "--out-dir", default="./")
parser.add_argument("-n", "--dry-run", action="store_true")
parser.add_argument("-d", "--debug", action="store_true")
args = parser.parse_args()


GENOME = args.genome
OUT_DIR = Path(args.out_dir)

DRY = args.dry_run
DEBUG = args.debug

INCLUDE = "genome,protein,gff3"

# Specify the data files to include (comma-separated). string(,string)
# * genome:     genomic sequence
# * rna:        transcript
# * protein:    amnio acid sequences
# * cds:        nucleotide coding sequences
# * gff3:       general feature file
# * gtf:        gene transfer format
# * gbff:       GenBank flat file
# * seq-report: sequence report file


# Dir structure after unzip
# ├── GCF_024145975.1
# │   ├── GCF_024145975.1.zip
# │   ├── ncbi_dataset
# │   │   └── data
# │   │       ├── assembly_data_report.jsonl
# │   │       ├── dataset_catalog.json
# │   │       └── GCF_024145975.1
# │   │           ├── cds_from_genomic.fna
# │   │           ├── GCF_024145975.1_ASM2414597v1_genomic.fna
# │   │           ├── genomic.gbff
# │   │           ├── genomic.gff
# │   │           ├── genomic.gtf
# │   │           ├── protein.faa
# │   │           └── sequence_report.jsonl
# │   └── README.md


if DEBUG:
    ic(args)

if __name__ == "__main__":
    GENOME_DIR = OUT_DIR / Path(GENOME)
    ZIP = GENOME_DIR / f"{GENOME}.zip"

    DATASETS = split(
        f"datasets download genome accession {GENOME} --filename {ZIP} --include {INCLUDE}"
    )

    # -o overwrite -q quiet
    UNZIP = split(f"unzip -qo {ZIP} -d {GENOME_DIR}")

    NESTED_DATA_DIR = GENOME_DIR / "ncbi_dataset" / "data" / GENOME

    TO_RM = (ZIP, GENOME_DIR / "README.md", GENOME_DIR / "ncbi_dataset")

    RENAMES = (
        (GENOME_DIR / "genomic.gff", GENOME_DIR / f"{GENOME}.gff"),
        (GENOME_DIR / "protein.faa", GENOME_DIR / f"{GENOME}.faa"),
    )

    if DEBUG:
        ic(INCLUDE, GENOME_DIR, ZIP, DATASETS, UNZIP, NESTED_DATA_DIR, TO_RM, RENAMES)

    if not DRY:
        GENOME_DIR.mkdir(exist_ok=True)

        sp.run(DATASETS, check=True)

        sp.run(UNZIP, check=True)

        for data_file in NESTED_DATA_DIR.iterdir():
            shutil.copy(data_file, GENOME_DIR)

        for rm_target in TO_RM:
            try:
                rm_target.unlink()
            except IsADirectoryError:
                shutil.rmtree(rm_target)

        for irename in RENAMES:
            shutil.move(irename[0], irename[1])

    else:
        print("DRY RUN\nActions that would've run:\n")

        print(f"mkdir -p {GENOME_DIR}")

        print(join(DATASETS))

        print(join(UNZIP))

        for data_file in NESTED_DATA_DIR.iterdir():
            print(f"mv {data_file} {GENOME_DIR}")

        for rm_target in TO_RM:
            print(f"rm -r {rm_target}")

        for irename in RENAMES:
            print(f"mv {irename[0]} {irename[1]}")
