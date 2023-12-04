from inspect import cleandoc
from itertools import combinations

import copy
import re
import os
import math
import string

data = cleandoc("""
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
""")

base = os.path.splitext(os.path.basename(__file__))[0]
data = open(base + ".input").read()

def maxes(turns):
    result = [0, 0, 0]
    for t in turns:
        red_m = re.search("(\d+) red", t)
        green_m = re.search("(\d+) green", t)
        blue_m = re.search("(\d+) blue", t)

        result[0] = max(result[0], int(red_m.group(1)) if red_m else 0)
        result[1] = max(result[1], int(green_m.group(1)) if green_m else 0)
        result[2] = max(result[2], int(blue_m.group(1)) if blue_m else 0)
    return result

totals = [0, 0]
for l in data.splitlines():
    start = l.split(':')
    game_id = int(start[0][5:])

    turns = start[1].split(";")

    vals = maxes(start[1].split(";"))
    totals[1] += vals[0] * vals[1] * vals[2]
    if vals[0] <= 12 and vals[1] <= 13 and vals[2] <= 14:
        totals[0] += game_id

print(totals)
