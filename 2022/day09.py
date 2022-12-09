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
# data = open(base + ".input").read()

deltas = { 'U': (0, -1), 'D': (0, 1), 'L': (-1, 0), 'R': (1, 0) }
neighbors = [(x, y) for x in range(-1, 2) for y in range(-1, 2)]

def tail_far(tail, head):
    for n in neighbors:
        if head == (tail[0] + n[0], tail[1] + n[1]):
            return False
    return True

prev_head = (0, 0)
head = (0, 0)
tail = (0, 0)
visited = set()
visited.add(tail)
for l in data.splitlines():
    d, c = l.split(' ')

    for i in range(int(c)):
        prev_head = (head[0], head[1])
        head = (head[0] + deltas[d][0], head[1] + deltas[d][1])

        if tail_far(tail, head):
            tail = (prev_head[0], prev_head[1])
            visited.add(tail)

print("map")
for y in range(-10, 10):
    for x in range(-10, 10):
        if (x, y) in visited:
            print("*", end="")
        else:
            print(".", end="")
    print()
print(len(visited))
