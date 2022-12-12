from inspect import cleandoc
from itertools import combinations

import copy
import re
import os
import math
import string
import sys

sys.setrecursionlimit(1500)

base = os.path.splitext(os.path.basename(__file__))[0]
data = open(base + ".input").read()

lowest = []

pos = (0, 0)
start = (0, 0)
elev = []
for j, l in enumerate(data.splitlines()):
    row = []
    for k, c in enumerate(list(l)):
        if c == 'S':
            start = (k, j)
            c = 'a'
        if c == 'a':
            lowest.append((k, j))
        if c == 'E':
            pos = (k, j)
            row.append(26)
        else:
            row.append(ord(c) - 97)
    elev.append(row)

height = len(elev)
width = len(elev[0])

def travel(grid, prev, steps, x, y):
    if x < 0 or y < 0 or x >= width or y >= height:
        return

    if steps >= grid[y][x]:
        return

    current = elev[y][x]
    if current >= prev - 1:
        grid[y][x] = steps

        travel(grid, current, steps + 1, x - 1, y)
        travel(grid, current, steps + 1, x + 1, y)
        travel(grid, current, steps + 1, x, y - 1)
        travel(grid, current, steps + 1, x, y + 1)

grid = [ [height*width for x in range(width)] for y in range(height) ]

travel(grid, 26, 0, pos[0], pos[1])
min_steps = grid[start[1]][start[0]]
print(min_steps)
print(min([grid[s[1]][s[0]] for s in lowest]))
