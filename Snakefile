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
        "{GENOME_DIR}/{genome}/{genome}.zip",
    shell:
        """
        mkdir -p {GENOMES_DIR}/{wildcards.genome}
        datasets download genome accession {wildcards.genome} --filename {output} --include protein,genome,gff3
        """


rule unzip_genomes:
    input:
        "{GENOME_DIR}/{genome}/{genome}.zip",
    output:
        directory("{GENOME_DIR}/{genome}/ncbi_dataset"),
        "{GENOME_DIR}/{genome}/README.md",
    shell:
        "unzip -o {input} -d {GENOMES_DIR}/{wildcards.genome}"
