.PHONY: help
help:
	bat Makefile

PULL="1-genomes/GCF_001991475.1/README.md"

.PHONY: test
test:
	snakemake --cores 1 $(PULL)
	rm -r $(PULL)

.PHONY: test_heavy
test_heavy:
	echo "Nothing to do!"
