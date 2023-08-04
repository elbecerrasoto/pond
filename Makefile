GENOME=GCF_001991475.1

FAA=1-genomes/$(GENOME).faa
XML=2-pfams/$(GENOME).pfam.xml
TSV=2-pfams/$(GENOME).pfam.tsv
FILTERED=3-filtered/$(GENOME).filtered.faa

CLEAN=$(FAA) $(TSV) $(XML) $(FILTERED)


.PHONY: test
test:
	snakemake --cores 1     $(FILTERED)
	md5sum -c test.md5


.PHONY: dry
dry:
	snakemake --cores 1 -np $(FILTERED)


.PHONY: clean
clean:
	rm -rf $(CLEAN)
