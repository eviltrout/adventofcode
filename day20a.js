function factors(num) {
  let sum = 0;
  for (let i=1; i<=Math.floor(Math.sqrt(num)); i++) {
    if (num % i === 0) {
      sum += (i * 10);
      if (num / i !== i) {
        sum += ((num / i) * 10);
      }
    }
  }

  return sum;
}

let i = 0;
let last = 0;
while (last < 29000000) {
  last = factors(++i);

  if (i % 10000 === 0) {
    console.log(`${i} => ${last}`);
  }
}

console.log(`House ${i} got ${last} presents.`);
