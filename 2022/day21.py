from inspect import cleandoc
from itertools import combinations

import sys
import copy
import re
import os
import math
import string

data = cleandoc("""
root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32
""")

base = os.path.splitext(os.path.basename(__file__))[0]
data = open(base + ".input").read()
sys.setrecursionlimit(3000)

cmds = {}
for l in data.splitlines():
    id, cmd = l.split(": ")

    m = re.match("([a-z]{4}) ([+-/*]) ([a-z]{4})", cmd)
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

reverse = { '+': '-', '-': '+', '/': '*', '*': '/' }

def perform(l, r, op):
    if op == '+':
        return l + r
    elif op == '-':
        return l - r
    elif op == '/':
        return l / r
    elif op == '*':
        return l * r

def solve(n, h = None):
    if h is not None and n['id'] == 'humn':
        return h
    if n['type'] == 'scalar':
        return n['value']
    return perform(solve(n['l'], h), solve(n['r'], h), n['op'])

def formula(node):
    if id in node and node['id'] == 'humn':
        return 'x'

    if node['type'] == 'scalar':
        return str(node['value'])
    elif node['type'] == 'variable':
        return node['name']

    l = formula(node['l'])
    r = formula(node['r'])
    return "(" + l + " " + node['op'] + " " + r + ")"

def binary_search(tree, low, high, x):
    # Check base case
    if high >= low:
        mid = (high + low) // 2

        val = solve(tree, mid)
        print(mid, ' => ', val)

        # If element is present at the middle itself
        if val == x:
            return mid

        elif val > x:
            return binary_search(tree, low, mid - 1, x)
        else:
            return binary_search(tree, mid + 1, high, x)
    else:
        return -1

tree = build_tree(cmds, 'root')
print(solve(tree, 2313))

r = solve(tree['r'])
print(binary_search(tree['l'], 0, 1e16, r))

