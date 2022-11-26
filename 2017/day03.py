from collections import  defaultdict

RIGHT = 0
UP = 1
LEFT = 2
DOWN = 3

def spiral(n):
    direction = 0
    val = 1
    pos = (0, 0)
    mins = (0, 0)
    maxs = (0, 0)

    filling_in = True
    grid = defaultdict(lambda: defaultdict(lambda: 0))

    def fill_in_x(start, stop):
        if filling_in:
            d = 1 if stop > start else - 1
            for x in range(start, stop+d, d):
                if filling_in:
                    fill_in(x, pos[1])

    def fill_in_y(start, stop):
        if filling_in:
            d = 1 if stop > start else - 1
            for y in range(start, stop+d, d):
                if filling_in:
                    fill_in(pos[0], y)

    def fill_in(x, y):
        nonlocal filling_in
        if grid[y][x] == 0:
            val = grid[y-1][x-1] + grid[y-1][x] + grid[y-1][x+1] + grid[y][x-1] + grid[y][x+1] + grid[y+1][x-1] + grid[y+1][x] + grid[y+1][x+1]
            grid[y][x] = val

            if val >= n:
                print("-->", val)
                filling_in = False

    grid[0][0] = 1

    while True:
        new_x, new_y = pos
        if direction == RIGHT:
            new_x = maxs[0] + 1
            fill_in_x(pos[0], new_x)
        elif direction == UP:
            new_y = mins[1] - 1
            fill_in_y(pos[1], new_y)
        elif direction == LEFT:
            new_x = mins[0] - 1
            fill_in_x(pos[0], new_x)
        elif direction == DOWN:
            new_y = maxs[1] + 1
            fill_in_y(pos[1], new_y)

        delta = max(abs(new_x - pos[0]), abs(new_y - pos[1]))

        steps = n - val
        if val + delta >= n:
            diff = n - val
            if direction == RIGHT:
                return (pos[0] + diff, pos[1])
            elif direction == UP:
                return (pos[0], pos[1] - diff)
            elif direction == LEFT:
                return (pos[0] - diff, pos[1])
            elif direction == DOWN:
                return (pos[0], pos[1] + diff)

        direction = (direction + 1) % 4
        pos = (new_x, new_y)

        val += delta
        maxs = (max(maxs[0], pos[0]), max(maxs[1], pos[1]))
        mins = (min(mins[0], pos[0]), min(mins[1], pos[1]))

def manhattan(n):
    res = spiral(n)
    return abs(res[0]) + abs(res[1])

print(manhattan(325489))


