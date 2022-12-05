from inspect import cleandoc
from itertools import combinations

import copy
import re
import os
import math
import string

data = cleandoc("""
    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
""")

base = os.path.splitext(os.path.basename(__file__))[0]
data = open(base + ".input").read()

crates_in, instructions = data.split("\n\n")
crates_in = crates_in.splitlines()
rows = len(crates_in) - 1
cols = max(map(int, crates_in[rows].split()))

crates = []
for x in range(cols):
    col = []
    for y in range(rows):
        c = crates_in[y][(x*4)+1]
        if c != ' ':
            col.append(c)
    crates.append(col)

p0 = copy.deepcopy(crates)
p1 = copy.deepcopy(crates)
for i in instructions.splitlines():
    count, src, dst = (map(int, re.sub('[^0-9 ]', '', i).split('  ')))
    for j in range(count):
        p0[dst-1].insert(0, p0[src-1].pop(0))
    p1[dst-1] = p1[src-1][:count] + p1[dst-1]
    p1[src-1] = p1[src-1][count:]

print(''.join([c[0] for c in p0]))
print(''.join([c[0] for c in p1]))
