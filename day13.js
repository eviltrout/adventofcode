const fs = require('fs');

fs.readFile('day13.input', 'utf8', (err, contents) => {
  contents = contents.trim();

  const people = {};
  const deltas = {};
  const key = (n0, n1) => `${n0}-${n1}`;

  contents.split("\n").forEach(l => {
    const m = /^([a-zA-Z]+) would (gain|lose) (\d+) happiness units by sitting next to ([a-zA-Z]+)\.$/.exec(l);
    deltas[key(m[1], m[4])] = (m[2] === "gain") ? parseInt(m[3]) : -parseInt(m[3]);
    people[m[1]] = true;
  });

  const deltaFor = (p0, p1) => (deltas[key(p0, p1)] || 0) + (deltas[key(p1, p0)] || 0);

  function perms(a) {
    if (a.length === 1) { return a; }

    const result = [];
    a.forEach(a0 => {
      perms(a.filter(x => x !== a0)).forEach(b => result.push([a0].concat(b)));
    });
    return result;
  }

  function findMax() {
    let max = 0;
    perms(Object.keys(people)).forEach(perm => {
      let sum = deltaFor(perm[perm.length-1], perm[0]);
      for (let i=1; i<perm.length; i++) {
        sum += deltaFor(perm[i], perm[i-1]);
      }
      if (sum > max) { max = sum; }
    });
    return max;
  }
  console.log(`max happiness is ${findMax()}`);

  people['Robin'] = true;
  console.log(`max happiness w/ Robin is ${findMax()}`);
});
