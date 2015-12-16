const fs = require('fs');

fs.readFile('day15.input', 'utf8', (err, contents) => {
  contents = contents.trim();

  const ingredients = [];
  contents.split("\n").forEach(l => {
    const m = /([a-zA-Z]+): capacity (\-?\d+), durability (\-?\d+), flavor (\-?\d+), texture (\-?\d+), calories (\-?\d+)/.exec(l);

    if (m) {
      ingredients.push({ name: m[1],
                         capacity: parseInt(m[2]),
                         durability: parseInt(m[3]),
                         flavor: parseInt(m[4]),
                         texture: parseInt(m[5]),
                         calories: parseInt(m[6]) });
    }
  });

  let max = 0;
  let maxCals = 0;
  for (let i=0; i<100; i++) {
    for (let j=0; j<100-i; j++) {
      for (let k=0; k<100-j; k++) {
        for (let l=0; l<100-l; l++) {
          if (i + j + k + l === 100) {
            const amounts = [i, j, k, l];

            let capacity = 0;
            let durability = 0;
            let flavor = 0;
            let texture = 0;
            let calories = 0;
            for (let x=0; x<ingredients.length; x++) {
              const ing = ingredients[x];
              capacity += amounts[x] * ing.capacity;
              durability += amounts[x] * ing.durability;
              flavor += amounts[x] * ing.flavor;
              texture += amounts[x] * ing.texture;
              calories += amounts[x] * ing.calories;
            }

            if (capacity < 0) { capacity = 0; }
            if (durability < 0) { durability = 0; }
            if (flavor < 0) { flavor = 0; }
            if (texture < 0) { texture = 0; }

            const sum = (capacity * durability * flavor * texture);
            if (sum > max) { max = sum; }
            if (calories === 500 && sum > maxCals) { maxCals = sum; }
          }
        }
      }
    }
  }
  console.log('max is', max);
  console.log('max (=500 calories) is', maxCals);
});
