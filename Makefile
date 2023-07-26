GENOME=GCF_001991475.1

FAA=1-genomes/$(GENOME).faa
TSV=2-pfams/$(GENOME).faa.tsv
XML=2-pfams/$(GENOME).faa.xml

CLEAN=$(FAA) $(TSV) $(XML)


.PHONY: test
test: clean
	snakemake --cores 1     $(TSV)


.PHONY: keep
keep:
	snakemake --cores 1     $(TSV)


.PHONY: dry
dry:
	snakemake --cores 1 -np $(TSV)


.PHONY: clean
clean:
	rm -rf $(CLEAN)
