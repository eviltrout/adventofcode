from inspect import cleandoc
from itertools import combinations

import os
import math
import copy

OP_ADD = 0
OP_MUL = 1
OP_SQ = 2

base = os.path.splitext(os.path.basename(__file__))[0]
data = open(base + ".input").read()

lines = data.splitlines()

def cycle(count, monkeys, reduce, lcm):
	monkeys = copy.deepcopy(monkeys)
	for j in range(count):
		for m in monkeys:
			while len(m['items']) > 0:
				i = m['items'].pop(0)
				m['inspections'] += 1
				if m['op'] == OP_SQ:
					i *= i
				elif m['op'] == OP_ADD:
					i += m['op_value']
				else:
					i *= m['op_value']

				if reduce:
					i = math.floor(i / 3)

				if i > lcm:
					rem = i % lcm
					i = lcm + rem

				if i % m['div'] == 0:
					monkeys[m['div_t']]['items'].append(i)
				else:
					monkeys[m['div_f']]['items'].append(i)
	vals = sorted([x['inspections'] for x in monkeys])
	return(vals[-1] * vals[-2])

monkeys = []
lcm = 1
for n in range((len(lines) + 1) // 7):
	ml = lines[(n * 7)+1:((n+1)*7)]
	op_tok = ml[1][23:].split(' ')
	op = None
	op_value = 0
	if op_tok[0] == '+':
		op = OP_ADD
		op_value = int(op_tok[1])
	elif op_tok[1] == 'old':
		op = OP_SQ
	else:
		op = OP_MUL
		op_value = int(op_tok[1])

	div = int(ml[2][21:])
	lcm *= div
	monkeys.append({
		'items': list(map(int, ml[0][18:].split(", ") )),
		'op': op,
		'op_value': op_value,
		'div': div,
		'div_t': int(ml[3][29:]),
		'div_f': int(ml[4][30:]),
		'inspections': 0
	})

print(cycle(20, monkeys, True, lcm))
print(cycle(10000, monkeys, False, lcm))
