IN_GENOMES = "input_genomes.txt"
IN_PFAMS = "input_pfams.txt"

rule all:
    shell:
        "bat Snakefile && "
        "cat Snakefile"

# Read input genomes
with open(IN_GENOMES , "r") as file:
    GENOMES = []
    for line in file:
        GENOMES.append(line.strip())

rule download_genomes:
    input:
        "input_genomes.txt"
    output:
        "{genome}/{genome}.zip"
    shell:
        "mkdir -p {wildcards.genome} && "
        "datasets download genome accession {wildcards.genome} --filename {wildcards.genome}/{wildcards.genome}.zip --include protein"
