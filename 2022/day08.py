from inspect import cleandoc
from itertools import combinations

import copy
import re
import os
import math
import string
import numpy

data = cleandoc("""
30373
25512
65332
33549
35390
""")

base = os.path.splitext(os.path.basename(__file__))[0]
data = open(base + ".input").read()

grid = numpy.array([list(map(int, list(x))) for x in data.splitlines()])

sz = len(grid)

def score(arr, h):
	result = 0
	for a in arr:
		if a >= h:
			return result + 1
		result += 1
	return result

p0 = (sz * 4) - 4
p1 = 0
for y in range(1, sz-1):
	for x in range(1, sz-1):
		h = grid[y][x]
		above = grid[y-1::-1,x]
		below = grid[y+1:,x]
		left = grid[y,x-1::-1]
		right = grid[y,x+1:]

		p1 = max(score(above, h) * score(below, h) * score(left, h) * score(right, h), p1)
		if max(above) < h or max(below) < h or max(left) < h or max(right) < h:
			p0 += 1

print(p0)
print(p1)
