from inspect import cleandoc
from itertools import combinations

import os
import math

test_data = cleandoc("""
abcde fghij
abcde xyz ecdab
a ab abc abd abf abj
iiii oiii ooii oooi oooo
oiii ioii iioi iiio
""")

base = os.path.splitext(os.path.basename(__file__))[0]
test_data = open(base + ".input").read()

def valid_p1(row):
    seen = set()
    for w in row:
        if w in seen:
            return 0
        seen.add(w)
    return 1

def valid_p2(row):
    seen = set()
    for w in row:
        key = ''.join(sorted(w))
        if key in seen:
            return 0
        seen.add(key)
    return 1

total_p1 = 0
total_p2 = 0
for row in test_data.splitlines():
    tokens = row.split()
    total_p1 += valid_p1(tokens)
    total_p2 += valid_p2(tokens)
print(total_p1)
print(total_p2)
