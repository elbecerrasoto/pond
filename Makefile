.PHONY: test
test:
	snakemake --cores 1 2-pfams/test.faa.tsv
	rm 2-pfams/test.faa.tsv


.PHONY: test_download
test_download:
	snakemake --cores 1 1-genomes/GCF_001991475.1/GCF_001991475.1.faa
	rm -r 1-genomes/GCF_001991475.1

.PHONY: test_heavy
test_heavy: test_heavy
	snakemake --cores 1  2-pfams/GCF_001991475.1.faa.tsv
	rm 2-pfams/GCF_001991475.1.faa.tsv
