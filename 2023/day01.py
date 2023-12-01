from inspect import cleandoc
from itertools import combinations

import copy
import re
import os
import math
import string

english = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
base = os.path.splitext(os.path.basename(__file__))[0]
data = open(base + ".input").read()

totals = [0, 0]
for l in data.splitlines():
	nums = re.sub("[^\\d]", '', l)
	if len(nums):
		totals[0] += int(nums[0] + nums[-1])

	found = []
	i = 0
	while i < len(l):
		asc = ord(l[i])
		matched = False
		if 48 < asc <= 57:
			found.append(asc - 48)
			matched = True
			i += 1
		for num, word in enumerate(english):
			if l[i:i+len(word)] == word:
				found.append(num+1)
				i += len(word) - 1
				matched = True
		if not(matched):
			i += 1
	if len(found):
		totals[1] += (found[0] * 10) + found[-1]

print(totals)
