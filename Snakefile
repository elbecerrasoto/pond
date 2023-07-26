IN_GENOMES = "input_genomes.txt"
IN_PFAMS = "input_pfams.txt"

SCRIPTS_DIR = "scripts"

GENOMES_DIR = "1-genomes"
PFAMS_DIR = "2-pfams"
ANNOTATIONS_DIR = "3-annotations"


with open(IN_GENOMES , "r") as file:
    GENOMES = []
    for line in file:
        GENOMES.append(line.strip())


rule all:
    input:
        PFAMS_DIR + "/GCF_001991475.1.pfam.tsv"


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
        PFAMS_DIR + "/{genome}.pfam.xml",
    shell:
        """
        mkdir -p {PFAMS_DIR}
        interproscan.sh --applications Pfam \
                        --formats XML \
                        --input {input} \
                        --outfile {output} \
                        --cpu 12 \
                        --disable-precalc
        """



rule annotate_pfams_tsv:
    input:
        rules.annotate_pfams.output,
    output:
        Path(rules.annotate_pfams.output[0]).with_suffix(".tsv"),
    shell:
        """
        interproscan.sh --mode convert \
                        --formats TSV \
                        --input {input} \
                        --outfile {output} \
        """
