from inspect import cleandoc
from itertools import combinations

import os
import math

test_data = cleandoc("""
5 1 9 5
7 5 3
2 4 6 8
""")

test_data = cleandoc("""
5 9 2 8
9 4 7 3
3 8 6 5
""")

base = os.path.splitext(os.path.basename(__file__))[0]
test_data = open(base + ".input").read()

total = 0
total_div = 0
for row in test_data.splitlines():
    ints = list(map(int, row.split()))
    total += (max(ints) - min(ints))
    total_div += sum((y // x) for x, y in list(combinations(sorted(ints), 2)) if y % x == 0)

print(total)
print(total_div)
