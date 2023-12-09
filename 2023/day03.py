from inspect import cleandoc
from itertools import combinations

import copy
import re
import os
import math
import string

data = cleandoc("""
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
""")

base = os.path.splitext(os.path.basename(__file__))[0]
data = open(base + ".input").read()

NEAR = [ (-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1) ]

def is_symbol(grid, x, y):
    if x < 0 or y < 0 or y >= len(grid) or x >= len(grid[0]):
        return False
    return not(grid[y][x].isdigit() or grid[y][x] == '.')

def has_symbol(part, grid):
    y = part[1][1]
    for i in range(0, part[2]):
        x = part[1][0] + i
        for l in NEAR:
            if is_symbol(grid, x+l[0], y+l[1]):
                return True

    return False

grid = []
ids = []
parts = {}
part_id = 1
gears = []
for y, l in enumerate(data.splitlines()):
    id_row = []
    ids.append(id_row)
    row_parts = []
    cols = list(l)
    for n in re.finditer("(\d+)", l):
        row_parts.append([int(n.group(0)), (n.start(0), y), n.end(0)-n.start(0), part_id])
        part_id += 1

    for i in range(len(cols)):
        found = False
        if cols[i] >= '0' and cols[i] <= '9':
            for p in row_parts:
                if i >= p[1][0] and i < p[1][0] + p[2]:
                    found = True
                    id_row.append(p[3])
                    break
        elif cols[i] != '.':
            gears.append((i, y))
        if not(found):
            id_row.append(0)


    for rp in row_parts:
        parts[rp[3]] = rp
    grid.append(cols)

total = 0 
for p in parts.values():
    if has_symbol(p, grid):
        total += p[0]
print(total)

total = 0
for g in gears:
    near_parts = {}
    for l in NEAR:
        x = g[0] + l[0]
        y = g[1] + l[1]
        if ids[y][x] > 0:
            near_parts[ids[y][x]] = True
    part_set = list(near_parts.keys())
    if len(part_set) == 2:
        total += (parts[part_set[0]][0] * parts[part_set[1]][0])
print(total)

