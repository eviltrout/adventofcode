const Combinatorics = require('js-combinatorics');

const items = [
  { type: 'weapon', name: 'Dagger', cost: 8, damage: 4, armor: 0},
  { type: 'weapon', name: 'Shortsword', cost: 10, damage: 5, armor: 0},
  { type: 'weapon', name: 'Warhammer', cost: 25 , damage: 6, armor: 0},
  { type: 'weapon', name: 'Longsword', cost: 40, damage: 7, armor: 0},
  { type: 'weapon', name: 'Greataxe', cost: 74, damage: 8, armor: 0},
  { type: 'armor', name: 'Leather', cost: 13, damage: 0, armor: 1 },
  { type: 'armor', name: 'Chainmail', cost: 31, damage: 0, armor: 2},
  { type: 'armor', name: 'Splintmail', cost: 53, damage: 0, armor: 3},
  { type: 'armor', name: 'Bandedmail', cost: 75 , damage: 0, armor: 4},
  { type: 'armor', name: 'Platemail', cost: 102, damage: 0, armor: 5},
  { type: 'ring', name: 'Damage +1', cost: 25, damage: 1, armor: 0 },
  { type: 'ring', name: 'Damage +2', cost: 50, damage: 2, armor: 0 },
  { type: 'ring', name: 'Damage +3', cost: 100, damage: 3, armor: 0 },
  { type: 'ring', name: 'Defense +1', cost: 20, damage: 0, armor: 1 },
  { type: 'ring', name: 'Defense +2', cost: 40, damage: 0, armor: 2 },
  { type: 'ring', name: 'Defense +3', cost: 80, damage: 0, armor: 3 },
];

function youWin(you, boss) {
  let damage = you.damage - boss.armor;
  if (damage < 1) { damage = 1; }

  boss.hp -= damage;
  if (boss.hp <= 0) { return true; }

  damage = boss.damage - you.armor;
  if (damage < 1) { damage = 1; }

  you.hp -= damage;
  if (you.hp <= 0) { return false; }

  return youWin(you, boss);
}

const dup = obj => Object.assign({}, obj);
const boss = { hp: 104, damage: 8, armor: 1 };

function forCost(amount, minCost) {
  const below = items.filter(i => i.cost <= amount);

  const result = [];
  below.forEach(i => {
    result.push([i]);
    const left = forCost(amount - i.cost, minCost);

    left.forEach(l => {
      if (l.indexOf(i) === -1 && l.length < 6) {
        result.push([i].concat(l));
      }
    });
  });
  return result;
}

function removeInvalid(sets) {
  return sets.filter(set => {
    const counts = {weapon: 0, armor: 0, ring: 0};
    set.forEach(i => counts[i.type]++);
    return counts.weapon === 1 && counts.armor <= 1 && counts.ring <= 2;
  });
}

function setWins(set) {
  const you = {hp: 100, damage: 0, armor: 0};
  set.forEach(i => {
    you.damage = you.damage + i.damage;
    you.armor = you.armor + i.armor;
  });

  return youWin(you, dup(boss));
}

// part 1
let spent = 8;
let won = false;
while (!won) {
  removeInvalid(forCost(spent)).some(set => {
    if (setWins(set)) {
      won = true;
      console.log(`you won spending ${spent}`);
    }
    return won;
  });

  spent++;
}

// part 2
const weapons = items.filter(i => i.type === 'weapon');
const armors = items.filter(i => i.type === 'armor');
const rings = items.filter(i => i.type === 'ring');
const ringCombos = Combinatorics.power(rings);

const all = [];
weapons.forEach(w => {
  all.push([w]);
  armors.forEach(a => {
    all.push([w, a]);
    ringCombos.forEach(r => all.push([w, a].concat(r)));
  });
  ringCombos.forEach(r => all.push([w].concat(r)));
});

let maxLost = 0;
all.forEach(set => {
  if (!setWins(set)) {
    const cost = set.map(s => s.cost).reduce((x, y) => x + y);
    if (cost > maxLost) {
      maxLost = cost;
    }
  }
});
console.log(`max lost is ${maxLost}`);
