.PHONY: test
test:
	snakemake --cores 12 1-genomes/GCF_001991475.1/GCF_001991475.1.gff
	trash 1-genomes/GCF_001991475.1
