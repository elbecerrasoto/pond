.PHONY: test
test:
	snakemake --core all


GENOME=GCF_001991475.1
FAA=1-genomes/$(GENOME)/$(GENOME).faa
.PHONY: test_download
test_download:
	snakemake --cores all $(FAA)


.PHONY: dry
dry:
	snakemake -np --cores all


.PHONY: clean
clean:
	rm -rf 1-genomes/$(GENOME) temp 3-filtered 4-cdhit
