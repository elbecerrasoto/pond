import numpy as np
import pytest

from similarities import M_jac, M_lev, get_proteins

N = 12


def is_symmetric(X):
    return np.allclose(X.transpose(1, 0), X)


def is_diag_0(X):
    return np.allclose(np.diag(X), 0)


def is_diag_equal_and_non_0(X):
    e = np.diag(X)[0]
    return np.allclose(np.diag(X), e) and e != 0


@pytest.fixture
def proteins():
    return get_proteins(N)


def test_proteins(proteins):
    lens = [len(p) for p in proteins]
    assert all([l != 0 for l in lens])


def test_matrices(proteins):
    M_levD = M_lev(proteins, distance=True)
    M_jacD = M_jac(proteins, distance=True)

    M_levS = M_lev(proteins, distance=False)
    M_jacS = M_jac(proteins, distance=False)

    assert is_symmetric(M_levD)
    assert is_symmetric(M_jacD)

    assert is_symmetric(M_levS)
    assert is_symmetric(M_levS)

    assert is_diag_0(M_levD)
    assert is_diag_0(M_jacD)

    assert is_diag_equal_and_non_0(M_levS)
    assert is_diag_equal_and_non_0(M_jacS)


def test_write_method(proteins, tmp_path):
    ftest = tmp_path / "test.csv"
    for f in (M_lev, M_jac):
        M = f(proteins, fname=ftest)
        assert ftest.exists()
