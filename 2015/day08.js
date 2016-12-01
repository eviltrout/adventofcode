const fs = require('fs');

fs.readFile('day08.input', 'utf8', (err, contents) => {
  contents = contents.trim();

  let l1 = 0;
  let l0 = 0;
  contents.split("\n").forEach(token => {
    l0 += token.length;

    const fixed = eval(token);
    l1 += fixed.length;
  });

  console.log(`orig length ${l0}`);
  console.log(`parsed length ${l1}`);
  console.log(`sum length ${l0-l1}`);

  console.log("\n");

  l0 = 0;
  l1 = 0;
  contents.split("\n").forEach(token => {
    l0 += token.length;
    const fixed = JSON.stringify(token);
    l1 += fixed.length;
  });
  console.log(`orig length ${l0}`);
  console.log(`parsed length ${l1}`);
  console.log(`sum length ${l1-l0}`);
});
