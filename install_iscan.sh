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

