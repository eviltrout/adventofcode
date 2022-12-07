from inspect import cleandoc
from itertools import combinations

import copy
import re
import os
import math
import string

base = os.path.splitext(os.path.basename(__file__))[0]
data = open(base + ".input").read()

lines = [x.split() for x in data.splitlines()]
ip = 0
pwd = []
path = '/'
paths = set()
files = {}
while ip < len(lines):
    cmd = lines[ip]
    if cmd[1] == 'cd':
        if cmd[2] == '/':
            pwd = []
        elif cmd[2] == '..':
            pwd = pwd[:-1]
        else:
            pwd.append(cmd[2])
        path = "/"
        if len(pwd) > 0:
            path += "/".join(pwd) + "/"
        paths.add(path)
        ip += 1
    elif cmd[1] == 'ls':
        ip += 1
        while ip < len(lines) and lines[ip][0] != '$':
            if lines[ip][0] != 'dir':
                files[path + lines[ip][1]] = int(lines[ip][0])
            ip += 1

p0 = 0
for p in paths:
    sz = sum([files[f] for f in files if f.startswith(p)])
    if sz <= 100000:
        p0 += sz
print(p0)

p1 = 70000000
needed = 30000000 - (p1 - sum(files.values()))
for p in paths:
    sz = sum([files[f] for f in files if f.startswith(p)])
    if sz >= needed and sz <= p1:
        p1 = sz
print(p1)
