from inspect import cleandoc
from itertools import combinations

import os
import numpy


base = os.path.splitext(os.path.basename(__file__))[0]
data = [4, 1, 15, 12, 0, 9, 9, 5, 5, 8, 7, 3, 14, 5, 12, 3]

seen = set()
def iter():
    key = str(data)
    if key in seen:
        return False

    seen.add(key)
    i = numpy.argmax(data)
    v = data[i]
    data[i] = 0
    for j in range(v):
        data[(i + j + 1) % len(data)] += 1

    return True

i = 0
while iter():
    i += 1

print(i)

i = 0
seen = set()
while iter():
    i += 1
print(i)
