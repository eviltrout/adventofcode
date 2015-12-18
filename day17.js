let sizes = [43, 3, 4, 10, 21, 44, 4, 6, 47, 41, 34, 17, 17, 44, 36, 31, 46, 9, 27, 38];
let goal = 150;

const matches = {};
const cached = {};

function perms(a, path) {
  path = path || [];

  const key = path.toString();
  if (cached[key]) { return []; }
  cached[key] = true;

  const sum = path.map(p => sizes[p]).reduce((c, p) => c + p, 0);
  if (sum === goal) {
    matches[key] = path.length;
    return path;
  } else if (sum > goal) {
    return [];
  }

  a.filter(a0 => path.indexOf(a0) === -1).forEach(a0 => {
    perms(a, path.concat(a0).sort());
  });
}

const indices = [];
for (let i=0; i<sizes.length; i++) { indices[i] = i; }

perms(indices);
console.log('perms', Object.keys(matches).length);

let min = sizes.length;
Object.values(matches).forEach(c => {
  if (c < min) { min = c; }
});

console.log('min', min);

let usingMin = 0;
Object.keys(matches).forEach(m => {
  if (matches[m] === min) { usingMin++; }
});
console.log('using min', usingMin);
