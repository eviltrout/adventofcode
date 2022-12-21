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
data = open(base + ".input").read()

valves = {}
targets = set()
for l in data.splitlines():
    id = l[6:8]
    flow = int(re.search("rate=(\d+);", l).group(1))
    if flow > 0:
        targets.add(id)
    exits = l[re.search('valves? ', l).end(0):].split(', ')
    valves[id] = { 'id': id, 'flow': flow, 'exits': exits }

def map_targets(id):
    to_visit = [[id]]
    visited = set([id])
    depth = 0
    path = []
    sub_targets = {}
    while len(to_visit) > 0:
        depth += 1
        path = to_visit.pop(0)
        for e in valves[path[-1]]['exits']:
            if e not in visited:
                visited.add(e)
                new_path = copy.copy(path)
                new_path.append(e)
                to_visit.append(new_path)

                if e in targets:
                    sub_targets[e] = new_path

    valves[id]['sub_targets'] = sub_targets

for id in valves:
    map_targets(id)

class State:
    def __init__(self):
        self.current = 'AA'
        self.total = 0
        self.flow = 0
        self.min = 0
        self.valves_left = copy.copy(targets)

    def clone(self):
        result = State()
        result.total = self.total
        result.flow = self.flow
        result.min = self.min
        result.valves_left = copy.copy(self.valves_left)
        return result

    def wait(self, n):
        for i in range(n):
            self.min += 1
            self.total += self.flow

    def finish(self):
        while self.min < 30:
            self.total += self.flow
            self.min += 1
        return self


def find_best(state):
    valve = valves[state.current]
    if len(state.valves_left) == 0:
        return state.finish()
    else:
        best = state.clone()
        for dest in state.valves_left:
            new_state = state.clone()
            path = valve['sub_targets'][dest][1:]
            new_state.wait(len(path) + 1)
            new_state.current = dest
            new_state.flow += valves[dest]['flow']
            new_state.valves_left.remove(dest)
            if new_state.min <= 30:
                result = find_best(new_state)
                if result.total > best.total:
                    best = result
        return best

winner = find_best(State())
print(winner.total)
