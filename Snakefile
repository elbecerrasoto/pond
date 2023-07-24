IN_GENOMES = "input_genomes.txt"
IN_PFAMS = "input_pfams.txt"

SCRIPTS_DIR = "scripts"

GENOMES_DIR = "1-genomes"
PFAMS_DIR = "2-pfams"
ANNOTATIONS_DIR = "3-annotations"


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


with open(IN_GENOMES , "r") as file:
    GENOMES = []
    for line in file:
        GENOMES.append(line.strip())


rule all:
    input:
        [f"{GENOMES_DIR}/{genome}/{genome}.zip" for genome in GENOMES],


rule download_iscan_test:
    output:
        gz = GZ,
        md5 = MD5,
    shell:
        """
        mkdir -p {ISCAN_INSTALLATION_DIR}
        wget -O {output.md5} {ISCAN_FTP_MD5}
        touch {output.gz}
        """

rule download_genomes:
    input:
        "input_genomes.txt",
    output:
        GENOMES_DIR + "/{genome}/{genome}.zip",
    shell:
        """
        mkdir -p {GENOMES_DIR}/{wildcards.genome}

        datasets download genome accession {wildcards.genome} --filename {output} --include protein,genome,gff3
        """


rule unzip_genomes:
    input:
        rules.download_genomes.output,
    output:
        faa = GENOMES_DIR + "/{genome}/{genome}.faa",
        fna = GENOMES_DIR + "/{genome}/{genome}.fna",
        gff = GENOMES_DIR + "/{genome}/{genome}.gff",
    shell:
        """
        unzip -o {input} -d {GENOMES_DIR}/{wildcards.genome}

        # Flatten ncbi dir structure
        mv {GENOMES_DIR}/{wildcards.genome}/ncbi_dataset/data/{wildcards.genome}/* \
           {GENOMES_DIR}/{wildcards.genome}

        # Rename faa, fna, gff
        mv {GENOMES_DIR}/{wildcards.genome}/*.faa {output.faa}
        mv {GENOMES_DIR}/{wildcards.genome}/*.fna {output.fna}
        mv {GENOMES_DIR}/{wildcards.genome}/*.gff {output.gff}

        # Remove crust
        rm -r {GENOMES_DIR}/{wildcards.genome}/ncbi_dataset/ \
              {GENOMES_DIR}/{wildcards.genome}/README.md
        """


rule annotate_pfams:
    input:
        rules.unzip_genomes.output.faa,
    output:
        PFAMS_DIR + "/{genome}.faa.xml",
    shell:
        """
        mkdir -p {PFAMS_DIR}
        interproscan.sh --applications Pfam \
                        --formats TSV, XML \
                        --input {input} \
                        --output-dir {PFAMS_DIR} \
                        --cpu 12 \
                        --disable-precalc
        """
