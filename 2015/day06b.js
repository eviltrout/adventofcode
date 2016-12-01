const fs = require('fs');

const size = 1000;
const grid = new Buffer(size * size);
for (let y=0; y<size; y++) {
  for (let x=0; x<size; x++) {
    grid[(y * size) + x] = 0;
  }
}

fs.readFile('day06.input', 'utf8', (err, contents) => {
  contents = contents.trim();

  contents.split("\n").forEach(str => {
    const result = /([a-z ]+) (\d+),(\d+) through (\d+),(\d+)/.exec(str);
    const inst = result[1];
    const [x0, y0, x1, y1] = result.slice(2).map(x => parseInt(x));

    for (let y=y0; y<=y1; y++) {
      for (let x=x0; x<=x1; x++) {
        const offset = (y * size) + x;
        let val = grid[offset];
        if (inst === 'turn on') {
          val++;
        } else if (inst === 'turn off') {
          val--;
          if (val < 0) { val = 0; }
        } else if (inst === 'toggle') {
          val += 2;
        }
        grid[offset] = val;
      }
    }
  });

  let brightness = 0;
  for (let y=0; y<size; y++) {
    for (let x=0; x<size; x++) {
      brightness += grid[(y * size) + x];
    }
  }
  console.log(`total brightness is ${brightness}`);
});
