GENOME=GCF_001991475.1

FAA=1-genomes/$(GENOME).faa
TSV=2-pfams/$(GENOME).pfam.tsv
XML=2-pfams/$(GENOME).pfam.xml

CLEAN=$(FAA) $(TSV) $(XML)


.PHONY: test
test:
	snakemake --cores 1     $(TSV)


.PHONY: dry
dry:
	snakemake --cores 1 -np $(TSV)


.PHONY: clean
clean:
	rm -rf $(CLEAN)
