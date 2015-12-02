const fs = require('fs');

fs.readFile('day01.input', 'utf8', (err, contents) => {
  let floor = 0;
  const asChars = contents.trim().split('');

  for (let i=0; i<contents.length; i++) {
    const c = contents.charAt(i);

    if (c === '(') {
      floor++;
    } else if (c === ')') {
      floor--;
    }

    if (floor === -1) {
      console.log(`hit -1 at ${i+1}`);
    }
  }
  console.log(`final floor ${floor}`);
});
