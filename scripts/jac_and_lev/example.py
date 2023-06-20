#!/usr/bin/env python3

from similarities import M_jac, M_lev, get_proteins

N = 2**8
SEED = 42
LEV_CSV = "distance_lev.csv"
JAC_CSV = "distance_jac.csv"

proteins = get_proteins(N, seed=SEED)
lev = M_lev(proteins, distance = True, fname = LEV_CSV)
jac = M_jac(proteins, distance = True, fname = JAC_CSV)

print(f"Done: {LEV_CSV}")
print(f"Done: {JAC_CSV}")
