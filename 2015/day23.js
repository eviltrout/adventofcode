const fs = require('fs');

fs.readFile('day23.input', 'utf8', (err, contents) => {
  contents = contents.trim();

  const program = [];

  contents.split("\n").forEach(l => {
    program.push({ op: l.slice(0, 3), args: l.slice(4).split(', ') });
  });

  const state = { ip: 0, a: 0, b: 0 };

  function operate() {
    const inst = program[state.ip];

    switch (inst.op) {
      case 'jio':
        const jioVal = state[inst.args[0]];
        if (jioVal === 1) {
          state.ip += parseInt(inst.args[1]);
        } else {
          state.ip++;
        }
        break;
      case 'inc':
        state[inst.args[0]]++;
        state.ip++;
        break;
      case 'tpl':
        state[inst.args[0]] = state[inst.args[0]] * 3;
        state.ip++;
        break;
      case 'jmp':
        state.ip += parseInt(inst.args[0]);
        break;
      case 'jie':
        const jieVal = state[inst.args[0]];
        if (jieVal % 2 === 0) {
          state.ip += parseInt(inst.args[1]);
        } else {
          state.ip++;
        }
        break;
      case 'hlf':
        state[inst.args[0]] = state[inst.args[0]] / 2;
        state.ip++;
        break;

      default:
        throw `unknown inst ${inst.op}`;
    }
  }

  while (state.ip < program.length) {
    operate();
  }

  console.log(state);

});


