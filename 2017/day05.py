from inspect import cleandoc
from itertools import combinations

import os
import math

test_data = cleandoc("""
0 3 0 1 -3
""")

base = os.path.splitext(os.path.basename(__file__))[0]
test_data = open(base + ".input").read()

data = [int(x) for x in test_data.split()]
data2 = data.copy()

i = p0 = 0
while 0 <= i < len(data):
    offset = data[i]
    data[i] += 1
    i += offset
    p0 += 1

i = p1 = 0
while 0 <= i < len(data2):
    offset = data2[i]
    data2[i] += (-1 if offset >= 3 else 1)
    i += offset
    p1 += 1

print("p0", p0)
print("p1", p1)
