.PHONY: help
help:
	bat Makefile

.PHONY: test
test:
	snakemake --cores 1 1-genomes/GCF_001991475.1/GCF_001991475.1.faa
	rm 1-genomes/GCF_001991475.1/GCF_001991475.1.faa

.PHONY: test_heavy
test_heavy:
	echo "Nothing to do!"
