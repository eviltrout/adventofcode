from inspect import cleandoc
from itertools import combinations

import copy
import re
import os
import math
import string
import functools

base = os.path.splitext(os.path.basename(__file__))[0]
data = open(base + ".input").read()

def compare(l, r):
    if type(l) is int and type(r) is int:
        return l - r
    if type(l) is list and type(r) is list:
        for i in range(max(len(l), len(r))+1):
            if i == len(l) and i == len(r):
                return 0
            if i == len(l):
                return -1
            if i == len(r):
                return 1
            val = compare(l[i], r[i])
            if val != 0:
                return val
            i += 1
    return compare([l] if type(l) is int else l, [r] if type(r) is int else r)

pairs = data.split("\n\n")
total = 0
ordered = []
for i, pair in enumerate(pairs):
    l,r = map(eval, pair.splitlines())
    ordered.append(l)
    ordered.append(r)
    if compare(l, r) < 0:
        total += (i + 1)
print(total)

ordered = sorted(ordered, key=functools.cmp_to_key(compare))

total = next(i for i,v in enumerate(ordered) if compare(v, [[2]]) > 0) + 1
total *= next(i for i,v in enumerate(ordered) if compare(v, [[6]]) > 0) + 2
print(total)
