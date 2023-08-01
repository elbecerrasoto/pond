#!/usr/bin/env python3

# dependencies
# aria2

from pathlib import Path
from subprocess import run
from shlex import split, join

# iscan globals
ISCAN_VERSION = "5.63-95.0"
ISCAN_INSTALLATION_DIR = Path("/usr/share/interproscan")

# remotes
ISCAN_FTP = f"https://ftp.ebi.ac.uk/pub/databases/interpro/iprscan/5/{ISCAN_VERSION}"
ISCAN_FTP_GZ = f"{ISCAN_FTP}/interproscan-{ISCAN_VERSION}-64-bit.tar.gz"
ISCAN_FTP_MD5 = f"{ISCAN_FTP_GZ}.md5"

# local
MD5 = ISCAN_INSTALLATION_DIR / Path(ISCAN_FTP_MD5).name
GZ = ISCAN_INSTALLATION_DIR / Path(ISCAN_FTP_GZ).name
ISCAN_BIN = ISCAN_INSTALLATION_DIR / f"interproscan-{ISCAN_VERSION}/interproscan.sh"


if __name__ == "__main__":

    cmd_aria2 = split(
        f"aria2c --dir {ISCAN_INSTALLATION_DIR} --continue=true --split 12 --max-connection-per-server=16 --min-split-size=1M {ISCAN_FTP_MD5}"
    )

    print(f"Running \n{join(cmd_aria2)}")

    run(cmd_aria2, check=True)
