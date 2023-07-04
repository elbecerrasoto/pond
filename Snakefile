IN_GENOMES = "input_genomes.txt"
IN_PFAMS = "input_pfams.txt"

GENOMES_DIR = "1-genomes"


with open(IN_GENOMES , "r") as file:
    GENOMES = []
    for line in file:
        GENOMES.append(line.strip())


rule all:
    input:
        [f"{GENOMES_DIR}/{genome}/{genome}.zip" for genome in GENOMES],


rule download_genomes:
    input:
        "input_genomes.txt",
    output:
        "{GENOMES_DIR}/{genome}/{genome}.zip",
    shell:
        """
        mkdir -p {GENOMES_DIR}/{wildcards.genome}

        cp bak_1-genomes/{wildcards.genome}/{wildcards.genome}.zip \
           {GENOMES_DIR}/{wildcards.genome}/{wildcards.genome}.zip

        # datasets download genome accession {wildcards.genome} --filename {output} --include protein,genome,gff3
        """


rule unzip_genomes:
    input:
        "{GENOMES_DIR}/{genome}/{genome}.zip",
    output:
        "{GENOMES_DIR}/{genome}/protein.faa",
    shell:
        """
        unzip -o {input} -d {GENOMES_DIR}/{wildcards.genome}

        mv {GENOMES_DIR}/{wildcards.genome}/ncbi_dataset/data/{wildcards.genome}/* \
           {GENOMES_DIR}/{wildcards.genome}

        rm -r {GENOMES_DIR}/{wildcards.genome}/ncbi_dataset/ \
              {GENOMES_DIR}/{wildcards.genome}/README.md
        """
