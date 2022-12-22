from inspect import cleandoc
from itertools import combinations

import sys
import copy
import re
import os
import math
import string

base = os.path.splitext(os.path.basename(__file__))[0]
data = open(base + ".input").read()
sys.setrecursionlimit(3000)

cmds = {}
for l in data.splitlines():
    id, cmd = l.split(": ")

    m = re.match("([a-z]{4}) ([+-\/*]) ([a-z]{4})", cmd)
    if m is None:
        cmds[id] = { 'type': 'scalar', 'value': float(cmd) }
    else:
        cmds[id] = { 'type': 'op', "l": m.group(1), "op": m.group(2), "r": m.group(3) }

def build_tree(cmds, id):
    node = cmds[id]
    node['id'] = id

    if node['type'] == 'scalar':
        return node

    node['l'] = build_tree(cmds, node['l'])
    node['r'] = build_tree(cmds, node['r'])
    return node

def solve(n, h = None):
    if h is not None and n['id'] == 'humn':
        return h
    if n['type'] == 'scalar':
        return n['value']
    l = solve(n['l'], h)
    r = solve(n['r'], h)
    if n['op'] == '+':
        return l + r
    elif n['op'] == '-':
        return l - r
    elif n['op'] == '/':
        return l / r
    elif n['op'] == '*':
        return l * r

def binary_search(tree, low, high, x):
    if high >= low:
        mid = (high + low) // 2
        val = solve(tree, mid)
        if val == x:
            return mid
        elif val < x:
            return binary_search(tree, low, mid - 1, x)
        else:
            return binary_search(tree, mid + 1, high, x)
    else:
        return -1

tree = build_tree(cmds, 'root')
print(round(solve(tree, 2313)))

r = solve(tree['r'])
print(binary_search(tree['l'], 0, 100000000000000, r))
