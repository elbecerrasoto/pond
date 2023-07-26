# install on /usr/share
# link to /usr/bin
aria2c --continue=true --split 12  --max-connection-per-server=16 --min-split-size=1M https://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.63-95.0/interproscan-5.63-95.0-64-bit.tar.gz

# https://interproscan-docs.readthedocs.io/en/latest/HowToDownload.html
python3 setup.py -f interproscan.properties
./interproscan.sh -i test_all_appl.fasta -f tsv -dp
./interproscan.sh -i test_all_appl.fasta -f tsv


# Software requirements:

#     64-bit Linux
#     Perl 5 (default on most Linux distributions)
#     Python 3 (InterProScan 5.30-69.0 onwards)
#     Java JDK/JRE version 11 (InterProScan 5.37-76.0 onwards)
#     Environment variables set
#         $JAVA_HOME should point to the location of the JVM
#         $JAVA_HOME/bin should be added to the $PATH

# iscan globals
ISCAN_VERSION = "5.63-95.0"
ISCAN_INSTALLATION_DIR = Path(f"{SCRIPTS_DIR}/iscan")

# remotes
ISCAN_FTP = f"https://ftp.ebi.ac.uk/pub/databases/interpro/iprscan/5/{ISCAN_VERSION}"
ISCAN_FTP_GZ = f"{ISCAN_FTP}/interproscan-{ISCAN_VERSION}-64-bit.tar.gz"
ISCAN_FTP_MD5 = f"{ISCAN_FTP_GZ}.md5"

# local
MD5 = ISCAN_INSTALLATION_DIR / Path(ISCAN_FTP_MD5).name
GZ = ISCAN_INSTALLATION_DIR / Path(ISCAN_FTP_GZ).name
ISCAN_BIN = ISCAN_INSTALLATION_DIR / f"interproscan-{ISCAN_VERSION}/interproscan.sh"
