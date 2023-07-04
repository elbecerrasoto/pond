.PHONY: test
test:
	snakemake --cores 12 1-genomes/GCF_001991475.1/GCF_001991475.1.gff
	trash 1-genomes/GCF_001991475.1

.PHONY: test_heavy
test_heavy: test
	snakemake --cores 12  2-pfams/test_GCF_001993155.1.faa.xml
	trash 2-pfams
