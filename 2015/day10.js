function ls(input) {
  let last = null;
  let count = 1;

  let result = '';
  input.split('').forEach(c => {
    if (last) {
      if (last === c) {
        count++;
      } else {
        result += `${count}${last}`;
        count = 1;
      }
    }
    last = c;
  });
  result += `${count}${last}`;

  return result;
}


let contents = `1113122113`;

for (let i=0; i<50; i++) {
  contents = ls(contents);
}

console.log(contents.length);
