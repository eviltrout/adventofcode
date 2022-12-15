from inspect import cleandoc
from itertools import combinations

import copy
import re
import os
import math
import string

base = os.path.splitext(os.path.basename(__file__))[0]
data = open(base + ".input").read()

class Sensor:
    def __init__(self, pos, closest):
        self.pos = pos
        self.closest = closest
        self.dist = abs(pos[0] - closest[0]) + abs(pos[1] - closest[1])

    def range_at(self, y):
        y_off = abs(self.pos[1] - y)
        spread = self.dist - y_off

        l = self.pos[0] - spread
        r = self.pos[0] + spread
        if r < l:
            return None

        return (l, r)


sensors = []
max_x = -10000000000000
max_y = -10000000000000
min_x = 10000000000000
min_y = 10000000000000

for l in data.splitlines():
    res = list(map(int, re.findall("x=(-?\d+), y=(-?\d+).*x=(-?\d+), y=(-?\d+)", l)[0]))
    min_x = min(min(res[0], min_x), res[2])
    min_y = min(min(res[1], min_x), res[3])
    max_x = max(max(res[0], max_x), res[2])
    max_y = max(max(res[1], max_y), res[3])

    sensors.append(Sensor((res[0], res[1]), (res[2], res[3])))

sensor_positions = set([s.pos for s in sensors])
beacon_positions = set([s.closest for s in sensors])

def no_beacon(ranges, x):
    for r in ranges:
        if x >= r[0] and x <= r[1]:
            return [r[1], True]
    return [x, False]

count = 0
y = 2000000
ranges = [r for r in [s.range_at(y) for s in sensors] if r != None]
for x in range(min_x, max_x):
    if (x, y) not in beacon_positions:
        _x, result = no_beacon(ranges, x)
        if result:
            count += 1
print(count)

for y in range(0, 4000000):
    ranges = [r for r in [s.range_at(y) for s in sensors] if r != None]
    x = 0
    while x <= 4000000:
        x += 1
        pos = (x, y)
        x, result = no_beacon(ranges, x)
        if not result:
            print((x * 4000000) + y)
            exit()


