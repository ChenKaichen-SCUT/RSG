"""Independent integer model; no imports from CondTerm."""
import z3

p, x, pp, xp = z3.Ints('p x p_next x_next')
G = z3.Or(z3.And(p == 0, 0 <= x, x <= 2), z3.And(p == 1, 3 <= x, x <= 4))
T = z3.And(pp == 1-p, xp == 4-x)
R0 = z3.Or(z3.And(p == 0, x == 0), z3.And(p == 1, x == 4))
Rstar = z3.Or(z3.And(p == 0, 0 <= x, x <= 1), z3.And(p == 1, 3 <= x, x <= 4))

def prime(r):
    return z3.substitute(r, (p, pp), (x, xp))

def successor(r):
    return z3.substitute(r, (p, 1-p), (x, 4-x))

def candidate(s1, s2):
    assert isinstance(s1, bool) and isinstance(s2, bool)
    return z3.Or(z3.And(p == 0, 0 <= x, x <= int(s1)),
                 z3.And(p == 1, 4-int(s2) <= x, x <= 4))

def display_states(r):
    return [[a,b] for a in (0,1) for b in range(5)
            if z3.is_true(z3.simplify(z3.substitute(r,(p,z3.IntVal(a)),(x,z3.IntVal(b)))))]
