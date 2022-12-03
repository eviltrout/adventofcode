from inspect import cleandoc
from itertools import combinations

import os
import math
import string

test_data = cleandoc("""
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
""")

base = os.path.splitext(os.path.basename(__file__))[0]
test_data = open(base + ".input").read()

pri = lambda x: ord(x) - 96 if x in string.ascii_lowercase else ord(x) - 38

lines = test_data.splitlines()
print(sum([pri(list(set(l[:len(l)//2]).intersection(set(l[len(l)//2:])))[0]) for l in lines]))
print(sum([pri(list(set(y[0]).intersection(set(y[1])).intersection(set(y[2])))[0]) for y in [lines[x:x+3] for x in range(0, len(lines), 3)]]))
