from inspect import cleandoc
from itertools import combinations

import os
import math

test_data = cleandoc("""
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
""")

base = os.path.splitext(os.path.basename(__file__))[0]
test_data = open(base + ".input").read()

cals = sorted([sum(map(int, x.split())) for x in test_data.split("\n\n")])
print(cals[-1])
print(sum(cals[-3:]))

