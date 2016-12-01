const fs = require('fs');

fs.readFile('day05.input', 'utf8', (err, contents) => {
  contents = contents.trim();

  function containsPair(str) {
    const pairs = {};

    for (let i=1; i<str.length; i++) {
      const pair = str.charAt(i-1) + str.charAt(i);
      const last = pairs[pair];
      if (last) {
        if (last !== i - 1) {
          return true;
        }
      } else {
        pairs[pair] = i;
      }
    }
    return false;
  }

  function containsRepeat(str) {
    for (let i=2; i<str.length; i++) {
      if (str.charAt(i-2) === str.charAt(i)) {
        return true;
      }
    }
    return false;
  }

  let niceCount = 0;
  contents.split(/[ \n]/).forEach(str => {
    if (containsPair(str) && containsRepeat(str)) {
      niceCount++;
    }
  });

  console.log(`nice strings: ${niceCount}`);
});
