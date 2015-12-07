/*eslint no-bitwise: 0*/

const fs = require('fs');

fs.readFile('day07.input', 'utf8', (err, contents) => {
  contents = contents.trim();

  const wires = {};
  contents.split("\n").forEach(inst => {
    inst = inst.trim();

    const [lhs, rhs] = inst.split("->").map(i => i.trim());
    if (!rhs) { return; }

    wires[rhs] = lhs;
  });

  function uint16(x) {
    return (new Uint16Array([parseInt(x)]))[0];
  }

  function wireVal(id) {
    if (cached[id]) { return cached[id]; }

    const inst = wires[id] || id;

    let match;
    if (match = /^[a-z]+$/.exec(inst)) {
      cached[id] = wireVal(match[0]);
    } else if (match = /^\d+$/.exec(inst)) {
      return uint16(match[0]);
    } else if (match = /^([a-z0-9]+) AND ([a-z0-9]+)$/.exec(inst)) {
      cached[id] = uint16(wireVal(match[1]) & wireVal(match[2]));
    } else if (match = /^([a-z0-9]+) OR ([a-z0-9]+)$/.exec(inst)) {
      cached[id] = uint16(wireVal(match[1]) | wireVal(match[2]));
    } else if (match = /^([a-z0-9]+) LSHIFT ([a-z0-9]+)$/.exec(inst)) {
      cached[id] = uint16(wireVal(match[1]) << wireVal(match[2]));
    } else if (match = /^([a-z0-9]+) RSHIFT ([a-z0-9]+)$/.exec(inst)) {
      cached[id] = uint16(wireVal(match[1]) >> wireVal(match[2]));
    } else if (match = /^NOT ([a-z0-9]+)$/.exec(inst)) {
      cached[id] = uint16(~wireVal(match[1]));
    } else {
      throw `unknown ${id}`;
    }
    return cached[id];
  }

  let cached = {};
  const a0 = wireVal('a');
  console.log(a0);

  cached = {b: a0};
  const a1 = wireVal('a');
  console.log(a1);
});
