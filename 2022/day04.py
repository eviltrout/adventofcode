from inspect import cleandoc
from itertools import combinations

import os
import math
import string

data = cleandoc("""
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
""")

base = os.path.splitext(os.path.basename(__file__))[0]
data = open(base + ".input").read()

def build_set(str):
    ints = list(map(int, str.split("-")))
    return(set(range(ints[0], ints[1] + 1)))

p0 = p1 = 0
for l in data.splitlines():
    r0, r1 = map(build_set, l.split(","))
    p0 += (1 if r0.issubset(r1) or r1.issubset(r0) else 0)
    p1 += (1 if len(r0.intersection(r1)) > 0 else 0)
print(p0, p1)
