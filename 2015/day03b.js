const fs = require('fs');

fs.readFile('day03.input', 'utf8', (err, contents) => {
  contents = contents.trim();

  let santa = {x: 0, y: 0};
  let robo = {x: 0, y: 0};
  const log = {};

  function giveGift(who) {
    const hash = `${who.x},${who.y}`;
    log[hash] = (log[hash] || 0) + 1;
  }

  function move(who, c) {
    switch(c) {
      case '>': who.x++; break;
      case '<': who.x--; break;
      case '^': who.y--; break;
      case 'v': who.y++; break;
    }
  }

  giveGift(santa);

  let target = santa;
  contents.split('').forEach(c => {
    move(target, c);
    giveGift(target);
    target = (target === santa) ? robo : santa;
  });

  const houses = Object.values(log).length;
  console.log(`unique houses: ${houses}`);
});
