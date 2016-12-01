const fs = require('fs');

fs.readFile('day05.input', 'utf8', (err, contents) => {
  contents = contents.trim();

  // contents = `ugknbfddgicrmopn\naaa\njchzalrnumimnmhp\nhaegwjzuvuyypxyu\ndvszwmarrgswjxmb`;

  let niceCount = 0;
  contents.split(/[ \n]/).forEach(str => {
    let vowelCount = 0;
    let repetitions = 0;
    let lastChar;
    let naughty = false;

    str.split('').some(c => {
      naughty = (lastChar === 'a' && c === 'b') ||
                (lastChar === 'c' && c === 'd') ||
                (lastChar === 'p' && c === 'q') ||
                (lastChar === 'x' && c === 'y');

      if (naughty) {
        return true;
      }

      if (c === 'a' || c === 'e' || c === 'i' || c === 'o' || c === 'u') {
        vowelCount++;
      }

      if (lastChar === c) {
        repetitions++;
      }

      lastChar = c;
      return false;
    });

    if (!naughty && vowelCount >= 3 && repetitions > 0) {
      niceCount++;
      console.log(`${str} is nice`);
    } else {
      console.log(`${str} is naughty`);
    }
  });

  console.log(`nice strings: ${niceCount}`);
});
