#!/usr/bin/env python3

# dependencies
# aria2

from pathlib import Path

DRY = True

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


def run(cmd: str, dry: bool = False):
    import subprocess as sp
    from shlex import split

    print(f"Running \n{cmd}")

    if not dry:
        sp.run(split(cmd), check=True)


if __name__ == "__main__":
    # create download directory
    if not DRY:
        ISCAN_INSTALLATION_DIR.mkdir(parents=True, exist_ok=True)

    # download GZ
    for ftp_target in (ISCAN_FTP_MD5, ISCAN_FTP_GZ):
        cmd = (
            f"aria2c --dir {ISCAN_INSTALLATION_DIR}"
            "--continue=true --split 12 --max-connection-per-server=16 --min-split-size=1M "
            f" {ftp_target}"
        )

        run(cmd, dry=DRY)

    # check md5sum
    run(f"md5sum -c {MD5}", dry=DRY)
