IN_GENOMES = "input_genomes.txt"
IN_PFAMS = "input_pfams.txt"

GENOMES_DIR = "1-genomes"

with open(IN_GENOMES , "r") as file:
    GENOMES = []
    for line in file:
        GENOMES.append(line.strip())

rule all:
    input:
        [f"{GENOMES_DIR}/{genome}/{genome}.zip" for genome in GENOMES]


rule download_genomes:
    input:
        "input_genomes.txt"
    output:
        ozip = GENOMES_DIR + "/{genome}/{genome}.zip"
    shell:
        "mkdir -p {GENOMES_DIR}/{wildcards.genome} && "
        "datasets download genome accession {wildcards.genome} --filename {output.ozip} --include protein,genome,gff3"
