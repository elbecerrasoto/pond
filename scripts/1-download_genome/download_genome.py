#!/usr/bin/env python3

# Depends on ncbi-datasets-cli
# Install with
# mamba install -y -c conda-forge ncbi-datasets-cli

import argparse
import subprocess as sp
from pathlib import Path
from icecream import ic
from shlex import split, join

parser = argparse.ArgumentParser()
parser.add_argument("genome", help="Some help")
parser.add_argument("-o", "--out-dir", default="./")
parser.add_argument("-n", "--dry-run", action="store_true")
parser.add_argument("--debug", action="store_true")
args = parser.parse_args()

GENOME = args.genome
OUT_DIR = Path(args.out_dir)
ZIP = OUT_DIR / (GENOME + ".zip")

DRY = args.dry_run
DEBUG = args.debug

CMD = split(f"datasets download genome accession {GENOME} --filename {ZIP}")

if __name__ == "__main__":
    if DEBUG:
        ic(args)
        ic(ZIP)
        ic(CMD)

    if not DRY:
        OUT_DIR.mkdir(parents=True, exist_ok=True)
        sp.run(CMD, check=True)
        # unzip
        # remames
        # removes
    else:
        print("DRY RUN\nActions that would've run:\n")
        print(f"mkdir -p {OUT_DIR}")
        print(join(CMD))
