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
        ozip = "{GENOME_DIR}/{genome}/{genome}.zip",
    shell:
        "mkdir -p {GENOMES_DIR}/{wildcards.genome} && "
        "datasets download genome accession {wildcards.genome} --filename {output.ozip} --include protein,genome,gff3"


rule unzip_genomes:
    input:
        ozip = "{GENOME_DIR}/{genome}/{genome}.zip",
    output:
        faa = "{GENOME_DIR}/{genome}/{genome}.faa",
        fna = "{GENOME_DIR}/{genome}/{genome}.fna",
        gff = "{GENOME_DIR}/{genome}/{genome}.gff",
    shell:
        "touch {output.faa} {output.fna} {output.gff}"
