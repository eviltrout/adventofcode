const fs = require('fs');

fs.readFile('day09.input', 'utf8', (err, contents) => {
  contents = contents.trim();

  const locationsSet = {};
  const distances = {};

  const key = (l1, l2) => `${l1}-${l2}`;

  contents.split("\n").forEach(l => {
    const [all, l0, l1, distance] = /(.*) to (.*) = (\d+)/.exec(l);

    locationsSet[l0] = true;
    locationsSet[l1] = true;

    distances[key(l0, l1)] = parseInt(distance);
    distances[key(l1, l0)] = parseInt(distance);
  });

  const locations = Object.keys(locationsSet);
  const allPaths = [];

  function findPaths(visited) {
    if (visited.length === locations.length) {
      allPaths.push(visited);
      return;
    }

    locations.forEach(l => {
      if (visited.indexOf(l) === -1) {
        findPaths(visited.concat([l]));
      }
    });
  }

  findPaths([]);

  let shortest = Number.MAX_SAFE_INTEGER;
  let longest = 0;
  allPaths.forEach(p => {

    let last = p[0];
    let distance = 0;

    for (let i=1; i<p.length; i++) {
      const current = p[i];
      distance += distances[key(last, current)];
      last = current;
    }
    if (distance < shortest) { shortest = distance; }
    if (distance > longest) { longest = distance; }
  });

  console.log(`shortest distance is ${shortest}`);
  console.log(`longest distance is ${longest}`);

});
