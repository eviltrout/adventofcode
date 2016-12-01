const fs = require('fs');

fs.readFile('day18.input', 'utf8', (err, contents) => {
  contents = contents.trim();

  let grid = [];
  contents.split("\n").forEach(input => grid.push(input.trim().split('')));

  const height = grid.length;
  const width = grid[0].length;

  function read(x, y) {
    if (x < 0 || x >= width || y < 0 || y >= height) { return 0; }

    // Comment out for part 1
    if (x === 0 && y === 0) { return 1; }
    if (x === width - 1 && y === 0) { return 1; }
    if (x === 0 && y === height - 1) { return 1; }
    if (x === width - 1 && y === height - 1) { return 1; }

    return grid[y][x] === '#' ? 1 : 0;
  }

  function iterate() {
    const newGrid = [];
    for (let y=0; y<height; y++) {
      const row = [];
      for (let x=0; x<width; x++) {
        const val = grid[y][x];
        const count = read(x-1, y-1) + read(x, y-1) + read(x+1, y-1) +
                      read(x-1, y  )                + read(x+1, y  ) +
                      read(x-1, y+1) + read(x, y+1) + read(x+1, y+1);

        row[x] = val;
        if (val === '#') {
          if (count !== 2 && count !== 3) { row[x] = '.'; }
        } else if (count === 3) {
          row[x] = '#';
        }
      }
      newGrid.push(row);
    }

    return newGrid;
  }

  for (let i=0; i<100; i++) {
    grid = iterate(grid);
  }

  let count = 0;
  for (let y=0; y<height; y++) {
    for (let x=0; x<width; x++) {
      count += read(x, y);
    }
  }
  console.log(count);
});
