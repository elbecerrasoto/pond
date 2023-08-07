GENOME=GCF_001991475.1

FAA=1-genomes/$(GENOME).faa
XML=2-pfams/$(GENOME).pfam.xml
TSV=2-pfams/$(GENOME).pfam.tsv
FILTERED=3-filtered/$(GENOME).filtered.faa

CLEAN=$(FAA) $(TSV) $(XML) $(FILTERED)


.PHONY: test_fake
test_fake:
	snakemake --core `nproc --all` 3-filtered/test1.filtered.faa 3-filtered/test2.filtered.faa

.PHONY: test_real
test_real:
	snakemake --cores 1     $(FILTERED) # use 12 threads on iscan rule
	md5sum -c test.md5


.PHONY: dry
dry:
	snakemake --cores 1 -np $(FILTERED)


.PHONY: clean
clean:
	rm -rf $(CLEAN)
