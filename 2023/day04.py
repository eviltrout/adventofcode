from inspect import cleandoc
from itertools import combinations

import copy
import re
import os
import math
import string

data = cleandoc("""
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
""")

base = os.path.splitext(os.path.basename(__file__))[0]
data = open(base + ".input").read()


tickets = data.splitlines()
copies = [1] * len(tickets)
total = 0
total2 = 0
for idx, l in enumerate(tickets):
    toks = l.split(': ')[1].split(' | ')
    won = [int(x) for x in toks[0].split()]
    choices = [int(x) for x in toks[1].split()]

    wins = 0
    for c in choices:
        if c in won:
            wins += 1
    if wins > 0:
        total += (2 ** (wins - 1))

    for x in range(copies[idx]):
        for y in range(idx+1, idx+wins+1):
            copies[y] += 1
    total2 += copies[idx]

print(total)
print(total2)


