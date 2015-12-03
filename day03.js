const fs = require('fs');

fs.readFile('day03.input', 'utf8', (err, contents) => {
  contents = contents.trim();

  let [x, y] = [0, 0];
  const log = {};

  function giveGift() {
    const hash = `${x},${y}`;
    log[hash] = (log[hash] || 0) + 1;
  }

  contents.split('').forEach(c => {
    giveGift();

    switch(c) {
      case '>': x++; break;
      case '<': x--; break;
      case '^': y--; break;
      case 'v': y++; break;
    }
  });
  giveGift();

  const houses = Object.values(log).length;
  console.log(`unique houses: ${houses}`);
});
