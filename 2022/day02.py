from inspect import cleandoc
from itertools import combinations

import os
import math

test_data = cleandoc("""
A Y
B X
C Z
""")

scores_p1 = {
    "A X": 1 + 3,
    "A Y": 2 + 6,
    "A Z": 3 + 0,
    "B X": 1 + 0,
    "B Y": 2 + 3,
    "B Z": 3 + 6,
    "C X": 1 + 6,
    "C Y": 2 + 0,
    "C Z": 3 + 3
}

scores_p2 = {
    "A X": "A Z",
    "A Y": "A X",
    "A Z": "A Y",
    "B X": "B X",
    "B Y": "B Y",
    "B Z": "B Z",
    "C X": "C Y",
    "C Y": "C Z",
    "C Z": "C X"
}


base = os.path.splitext(os.path.basename(__file__))[0]
test_data = open(base + ".input").read()

print(sum([scores_p1[l] for l in test_data.splitlines()]))
print(sum([scores_p1[scores_p2[l]] for l in test_data.splitlines()]))

