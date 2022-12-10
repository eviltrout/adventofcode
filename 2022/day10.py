from inspect import cleandoc
from itertools import combinations

import os

base = os.path.splitext(os.path.basename(__file__))[0]
data = open(base + ".input").read()

graph = [1]
for cmd in data.splitlines():
    graph.append(graph[-1])
    if cmd != "noop":
        graph.append(graph[-1])
        graph[-1] += int(cmd.split(' ')[1])

print(sum([graph[x-1] * x for x in range(20, 260, 40)]))

for c in range(0, 240):
	print('#' if c % 40 in range(graph[c]-1, graph[c]+2) else '.', end='')
	if (c + 1) % 40 == 0:
		print()
