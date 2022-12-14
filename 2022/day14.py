from inspect import cleandoc
from itertools import combinations

import copy
import os

base = os.path.splitext(os.path.basename(__file__))[0]
data = open(base + ".input").read()

p0_solid = set()
lowest = 0
for l in data.splitlines():
	coords = [tuple(map(int, y.split(","))) for y in l.split(" -> ")]

	prev = coords[0]
	for c in coords[1:]:
		for x in range(min(c[0], prev[0]), max(c[0], prev[0])+1):
			for y in range(min(c[1], prev[1]), max(c[1], prev[1])+1):
				p0_solid.add((x, y))
				lowest = max(lowest, y)
		prev = c
lowest += 1

def pour(solid, floor):
	pos = (500, 0)
	if pos in solid:
		return False
	while True:
		if pos[1] == lowest:
			if floor:
				solid.add(pos)
				return True
			return False
		below = (pos[0], pos[1] + 1) in solid
		bl =  (pos[0] - 1, pos[1] + 1) in solid
		br = (pos[0] + 1, pos[1] + 1) in solid

		if below and bl and br:
			solid.add(pos)
			return True
		elif below and not(bl):
			pos = (pos[0] - 1, pos[1] + 1)
		elif below and not(br):
			pos = (pos[0] + 1, pos[1] + 1)
		else:
			pos = (pos[0], pos[1] + 1)


p0 = p1 = 0
p1_solid = copy.copy(p0_solid)
while pour(p0_solid, False):
	p0 += 1
while pour(p1_solid, True):
	p1 += 1

print(p0)
print(p1)
