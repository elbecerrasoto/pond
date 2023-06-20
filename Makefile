T := proteins
ALL := g0.faa g1.faa g2.faa g3.faa CONFIG.py

# $^ prerequisites
# $@ rule

.PHONY: help
help:
	bat Makefile

.PHONY: all
all: $(ALL)

CONFIG.py:
	printf 'ISCAN_BIN = None\n' > $(@) 

g0.faa: $(T)/b1.faa $(T)/b2.faa $(T)/b3.faa
	cat $(^) > $(@)

g1.faa: $(T)/b1.faa $(T)/b2.faa $(T)/i1.faa
	cat $(^) > $(@)

g2.faa: $(T)/b1.faa $(T)/i1.faa $(T)/i2.faa
	cat $(^) > $(@)

g3.faa: $(T)/i1.faa $(T)/i2.faa $(T)/i3.faa
	cat $(^) > $(@)

.PHONY: clean
clean:
	rm $(ALL)
