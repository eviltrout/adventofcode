let prev = 20151125;

let cols = 1;
let rows = 1;

let x = 1;
let y = 1;

let done = false;
while (!done) {
  const next = (prev * 252533) % 33554393;
  prev = next;

  x += 1;
  y -= 1;
  if (x > cols) {
    x = 1;
    cols++;
    rows++;
    y = rows;
  }

  if (x === 3019 && y === 3010) {
    console.log(`answer is ${prev}`);
    done = true;
  }
}
