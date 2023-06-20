#!/usr/bin/env python3

import string
from typing import Callable, Hashable, Iterable, Optional

import numpy as np
from icecream import ic


def get_proteins(
    n: int,
    alphabet: Iterable[str] = tuple(string.ascii_lowercase[:6]),
    max_len: int = 6,
    seed: Optional[int] = None,
) -> list[str]:
    np.random.seed(seed)

    p_len = (np.random.choice(range(1, max_len + 1)) for j in range(n))
    proteins = list()

    for i in range(n):
        arch = np.random.choice(alphabet, next(p_len))
        arch = "".join(list(arch))
        proteins.append(arch)

    return proteins


def cartesian_apply(x: Iterable, f: Callable) -> list:
    from itertools import product

    cartesian = product(x, x)
    return [f(*pair) for pair in cartesian]


def M_similarity_from_distance(X: np.array) -> np.array:
    return 1 / (X + 1)


def M_distance_from_similarity(X: np.array) -> np.array:
    X = 1 / (X + 1)
    np.fill_diagonal(X, 0)
    return X


def is_symmetric(X):
    return np.allclose(X.transpose(1, 0), X)


def similarity_jaccard(a: Iterable[Hashable], b: Iterable[Hashable]) -> int:
    a = frozenset(a)
    b = frozenset(b)
    return len(a & b) / len(a | b)


def M_lev(
    strings: Iterable[str], distance=True, fname: Optional[str] = None
) -> np.array:
    from Levenshtein import distance as lev

    n = len(strings)
    flat = cartesian_apply(strings, lev)
    M_distance = np.array(flat).reshape(n, n)

    if distance:
        M = M_distance
    else:
        M = M_similarity_from_distance(M_distance)

    if fname is not None:
        np.savetxt(fname, M, delimiter=",")

    return M


def M_jac(
    strings: Iterable[str], distance=True, fname: Optional[str] = None
) -> np.array:
    n = len(strings)
    flat = cartesian_apply(strings, similarity_jaccard)
    M_similarity = np.array(flat).reshape(n, n)

    if distance:
        M = M_distance_from_similarity(M_similarity)
    else:
        M = M_similarity

    if fname is not None:
        np.savetxt(fname, M, delimiter=",")

    return M
