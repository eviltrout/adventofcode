from inspect import cleandoc
from itertools import combinations

import copy
import re
import os
import math
import string

data = "bvwbjplbgvbhsrlpgdmjqwftvncz"

base = os.path.splitext(os.path.basename(__file__))[0]
data = open(base + ".input").read()

def find_first(line, sz):
    for x in range(sz, len(line)):
        if len(set(line[x-sz:x])) == sz:
            return(x)

print(find_first(data, 4))
print(find_first(data, 14))
