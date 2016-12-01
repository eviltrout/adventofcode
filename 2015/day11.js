
function valid(pw) {
  if (pw.indexOf('i') !== -1) { return false; }
  if (pw.indexOf('o') !== -1) { return false; }
  if (pw.indexOf('l') !== -1) { return false; }

  const pairs = {};
  const regexp = /([a-z])\1/g;

  let m;
  while (m = regexp.exec(pw)) {
    pairs[m[0]] = true;
  }
  if (Object.keys(pairs).length < 2) { return false; }


  for (let i=2; i<pw.length; i++) {
    const c0 = pw.charCodeAt(i-2);
    const c1 = pw.charCodeAt(i-1);
    const c2 = pw.charCodeAt(i);

    if (c2 === (c1 + 1) && (c1 === c0 + 1)) { return true; }
  }

  return false;
}

function increment(str) {
  let result = "" + str;
  for (let i=str.length-1; i >= 0; i--) {

    let c = str.charCodeAt(i) + 1;
    if (c > 122) { c = 97; }

    result = result.substr(0, i) + String.fromCharCode(c) + result.substr(i+1);
    if (c > 97) { return result; }
  }
  return result;
}

let input = 'hepxcrrq';

input = increment(input);
while (!valid(input)) {
  input = increment(input);
}
console.log(input);


input = increment(input);
while (!valid(input)) {
  input = increment(input);
}
console.log(input);
