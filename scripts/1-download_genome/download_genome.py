#!/usr/bin/env python3

# What's the structure that I want?
#
# download_genome --out-dir my_dir ref

import argparse
import subprocess as sp
from pathlib import Path
from icecream import ic

parser = argparse.ArgumentParser()
parser.add_argument("genome", help="Some help")
parser.add_argument("-o", "--out-dir", help="Some help", default="./")
parser.add_argument("-n", "--dry-run", action="store_false")
args = parser.parse_args()

GENOME = args.genome
OUT_DIR = Path(args.out_dir)
ZIP = OUT_DIR / (GENOME + ".zip")
ic(args)

CMD = f"datasets download genome accession {GENOME} --filename {ZIP}"

ic(ZIP)
ic(CMD)

if __name__ == "__main__":
    OUT_DIR.mkdir(parents=True, exist_ok=True)
