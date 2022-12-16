from inspect import cleandoc
from itertools import combinations

import copy
import re
import os
import math
import string

data = cleandoc("""
Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II
""")

base = os.path.splitext(os.path.basename(__file__))[0]
# data = open(base + ".input").read()

valves = {}
for l in data.splitlines():
	id = l[6:8]
	flow = int(re.search("rate=(\d+);", l).group(1))
	exits = l[re.search('valves? ', l).end(0):].split(', ')
	valves[id] = { 'id': id, 'flow': flow, 'exits': exits }

class History:
	def __init__(self):
		self.current = 'AA'
		self.steps = 0
		self.total = 0
		self.flow = 0
		self.activated = set()

	def move_to(self, id):
		self.current = id
		self.steps += 1

	def activate(self, flow):
		self.activated.add(self.current)
		self.flow += flow
		self.steps += 1

	def clone(self):
		result = History()
		result.current = self.current
		result.steps = self.steps
		result.flow = self.flow
		result.total = self.total
		result.activated = copy.deepcopy(self.activated)
		return result

seen = {}
max_step = {}

def run(history):
	if history.steps == 30:
		return history

	# key = str(history.steps) + ":" + str(history.current) + ":" + str(history.total) + ":".join(sorted(list(history.activated)))
	# if key in seen:
	# 	return seen[key]

	history.total += history.flow
	if history.steps in max_step:
		tmp = max_step[history.steps]
		if tmp.total > history.total:
			return tmp
	max_step[history.steps] = history.clone()

	result = history

	valve = valves[history.current]
	if valve['flow'] > 0 and (valve['id'] not in history.activated):
		new_history = history.clone()
		new_history.activate(valve['flow'])
		tmp = run(new_history)
		if tmp.total > result.total:
			result = tmp

	for e in valve['exits']:
		new_history = history.clone()
		new_history.move_to(e)
		tmp = run(new_history)
		if tmp.total > result.total:
			result = tmp

	return result

winner = run(History())
print(winner.total)
