from inspect import cleandoc
from itertools import combinations

import copy
import re
import os
import math
import string

data = cleandoc("""
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
""")

base = os.path.splitext(os.path.basename(__file__))[0]
data = open(base + ".input").read()

deltas = { 'U': (0, -1), 'D': (0, 1), 'L': (-1, 0), 'R': (1, 0) }
neighbors = [(x, y) for x in range(-1, 2) for y in range(-1, 2)]

def normalize(x):
    return (-1 if x < 0 else 1 if x > 0 else 0)

def find_visited(rope_size):
    rope = [(0, 0) for x in range(0, rope_size)]
    visited = set()
    visited.add(rope[-1])
    for l in data.splitlines():
        d, c = l.split(' ')

        for i in range(int(c)):
            rope[0] = (rope[0][0] + deltas[d][0], rope[0][1] + deltas[d][1])
            for i in range(1, rope_size):
                if len([n for n in neighbors if rope[i-1] == (rope[i][0] + n[0], rope[i][1] + n[1])]) <= 0:
                    diff = (normalize(rope[i-1][0] - rope[i][0]), normalize(rope[i-1][1] - rope[i][1]))
                    rope[i] = (rope[i][0] + diff[0], rope[i][1] + diff[1])
            visited.add(rope[-1])
    return visited

print(len(find_visited(2)))
print(len(find_visited(10)))
