const fs = require('fs');
const BitArray = require('node-bitarray');

const size = 1000;

const grid = new BitArray().fill(size*size);

fs.readFile('day06.input', 'utf8', (err, contents) => {
  contents = contents.trim();

  contents.split("\n").forEach(str => {
    const result = /([a-z ]+) (\d+),(\d+) through (\d+),(\d+)/.exec(str);
    const inst = result[1];
    const [x0, y0, x1, y1] = result.slice(2).map(x => parseInt(x));

    for (let y=y0; y<=y1; y++) {
      for (let x=x0; x<=x1; x++) {
        let val = 1;
        const offset = (y * size) + x;
        if (inst === 'turn off') {
          val = 0;
        } else if (inst === 'toggle') {
          val = !grid.get(offset);
        }
        grid.set(offset, val);
      }
    }
  });

  console.log(`lights on ${grid.bitcount()}`);
});
