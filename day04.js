const md5 = require('blueimp-md5').md5;

const input = 'bgvyzdsv';

let iterations = 1;

while (md5(`${input}${iterations}`).substring(0, 5) !== "00000") {
  iterations++;
}

console.log(iterations);

iterations = 1;

while (md5(`${input}${iterations}`).substring(0, 6) !== "000000") {
  iterations++;
}
console.log(iterations);
