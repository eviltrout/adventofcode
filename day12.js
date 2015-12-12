const fs = require('fs');

fs.readFile('day12.input', 'utf8', (err, contents) => {
  contents = contents.trim();

  function sum(json) {
    switch(typeof json) {
      case "number": return json;
      case "object": return Object.values(json).reduce((prev, cur) => prev + sum(cur), 0);
      default: return 0;
    }
  }

  function sumNoRed(json) {
    switch(typeof json) {
      case "number": return json;
      case "object":
        const values = Object.values(json);
        return (!Array.isArray(json) && values.indexOf('red') !== -1) ? 0 : values.reduce((prev, cur) => prev + sumNoRed(cur), 0);
      default: return 0;
    }
  }

  const json = JSON.parse(contents);
  console.log(`sum is ${sum(json)}`);
  console.log(`sum no red is ${sumNoRed(json)}`);
});
