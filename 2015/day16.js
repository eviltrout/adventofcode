const fs = require('fs');

fs.readFile('day16.input', 'utf8', (err, contents) => {
  contents = contents.trim();

  const clues = {
    children: 3,
    cats: 7,
    samoyeds: 2,
    pomeranians: 3,
    akitas: 0,
    vizslas: 0,
    goldfish: 5,
    trees: 3,
    cars: 2,
    perfumes: 1
  };

  let idx = 1;
  contents.split("\n").forEach(c => {
    c = c.replace(/^Sue \d+: /, '');

    const sue = {};
    c.split(", ").forEach(attr => {
      const [name, val] = attr.split(": ");
      sue[name] = parseInt(val);
    });

    let hit = true;
    Object.keys(clues).forEach(clue => {

      const sueVal = sue[clue];
      const clueVal = clues[clue];
      hit = hit && ((typeof sueVal === "undefined") ||
                    ((clue === 'cats' || clue === 'trees') && (sueVal > clueVal)) ||
                    ((clue === 'pomeranians' || clue === 'goldfish') && (sueVal < clueVal)) ||
                    (clue !== 'cats' && clue !== 'trees' && clue !== 'pomeranians' && clue !== 'goldfish' && sueVal === clueVal));

    });

    if (hit) {
      console.log(idx, sue);
    }

    idx++;
  });
});
