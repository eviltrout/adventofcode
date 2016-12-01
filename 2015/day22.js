const spells = [
  { name: 'missile', cost: 53 },
  { name: 'drain', cost: 73 },
  { name: 'shield', cost: 113, turns: 6 },
  { name: 'poison', cost: 173, turns: 6 },
  { name: 'recharge', cost: 229, turns: 5 }
];

const cln = (obj) => Object.assign({}, obj);
let minSpent = 1000000;

function applyBuffs(state) {
  const active = state.active.map(cln);
  active.forEach(buff => {
    buff.turns--;
    if (buff.name === 'shield') {
      state.youArmor = 7;
    } else if (buff.name === 'poison') {
      state.bossHp -= 3;
    } else if (buff.name === 'recharge') {
      state.youMana += 101;
    }
  });
  return active;
}

function bossDead(state) {
  if (state.bossHp <= 0) {
    if (state.spent < minSpent) {
      minSpent = state.spent;
      console.log('you won', minSpent);
    }
    return true;
  }
  return false;
}

function bossTurn(prevState) {
  prevState.youArmor = 0;
  const active = applyBuffs(prevState);
  if (bossDead(prevState)) { return; }

  const state = cln(prevState);
  state.active = active.filter(b => b.turns > 0);
  let damage = 8 - state.youArmor;
  if (damage < 1) { damage = 1; }

  state.youHp -= damage;
  if (state.youHp > 0) {
    turn(state);
  }
}

function turn(prevState) {
  if (prevState.spent > minSpent) { return; }

  const active = applyBuffs(prevState);
  if (bossDead(prevState)) { return; }

  // part two
  prevState.youHp--;
  if (prevState.youHp <= 0) { return; }

  spells.forEach(spell => {
    if (spell.cost > prevState.youMana) { return; }

    const state = cln(prevState);
    state.active = active.filter(b => b.turns > 0);
    state.spent += spell.cost;
    state.youMana -= spell.cost;

    if (spell.name === 'missile') {
      state.bossHp -= 4;
    } else if (spell.name === 'drain') {
      state.bossHp -= 2;
      state.youHp += 2;
    } else if (!state.active.some(b => b.name === spell.name)) {
      state.active.push({ name: spell.name, turns: spell.turns });
    } else {
      return;
    }

    if (!bossDead(state)) { bossTurn(state); }
  });
}

turn({ youHp: 50, youMana: 500, spent: 0, active: [], bossHp: 55 });
