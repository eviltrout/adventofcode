from inspect import cleandoc
from itertools import combinations

import copy
import re
import os
import math
import string

base = os.path.splitext(os.path.basename(__file__))[0]
data = open(base + ".input").read()

lines = data.splitlines()
times = [int(x) for x in lines[0][5:].split()]
distances = [int(x) for x in lines[1][9:].split()]

max_time = max(times)

def calc(race_time, d):
	result = 0
	for i in range(1, race_time):
		delta = race_time - i
		if delta * i > d:
			result += 1
	return result

result = 1
for n in range(len(times)):
	result *= calc(times[n], distances[n])

print(result)

race_time = int(lines[0][5:].replace(' ', ''))
d = int(lines[1][9:].replace(' ', ''))
print(calc(race_time, d))
