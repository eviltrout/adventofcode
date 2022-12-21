from inspect import cleandoc
from itertools import combinations

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
# data = open(base + ".input").read()

cmds = {}
for l in data.splitlines():
    id, cmd = l.split(": ")

    m = re.match("([a-z]{4}) ([+-/*]) ([a-z]{4})", cmd)
    if m is None:
        cmds[id] = { 'type': 'scalar', 'value': int(cmd) }
    else:
        cmds[id] = { 'type': 'op', "l": m.group(1), "op": m.group(2), "r": m.group(3) }

def solve(cmds, id):
    n = cmds[id]
    if n['type'] == 'scalar':
        return n['value']

    l = solve(cmds, n['l'])
    r = solve(cmds, n['r'])
    
    if n['op'] == '+':
        return l + r
    elif n['op'] == '-':
        return l - r
    elif n['op'] == '/':
        return l // r
    elif n['op'] == '*':
        return l * r

def formula(cmds, id):
    if id == 'humn':
        return 'x'

    n = cmds[id]
    if n['type'] == 'scalar':
        return str(n['value'])

    l = formula(cmds, n['l'])
    r = formula(cmds, n['r'])
    return "(" + l + " " + n['op'] + " " + r + ")"

print(solve(cmds, "root"))
print(formula(cmds, cmds["root"]['l']))
print(formula(cmds, cmds["root"]['r']))

