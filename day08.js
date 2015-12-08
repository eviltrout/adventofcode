const fs = require('fs');

fs.readFile('day08.input', 'utf8', (err, contents) => {
  contents = contents.trim();

  contents = `""\n"abc"\n"aaa\\"aaa"\n"\\x27"`;

  let l1 = 0;
  let l0 = 0;
  contents.split("\n").forEach(token => {
    l0 += token.length;

    const fixed = token.replace(/^"/, "").replace(/"$/, "").replace(/\\\\/g, "x").replace(/\\"/g, "y").replace(/\\x[0-9a-f][0-9a-f]/g, "x");
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

    console.log(token, fixed, l0, l1);
  });
  console.log(`orig length ${l0}`);
  console.log(`parsed length ${l1}`);
  console.log(`sum length ${l1-l0}`);
});
