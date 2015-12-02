const fs = require('fs');

fs.readFile('day02.input', 'utf8', (err, contents) => {
  let total = 0;
  let totalRibbon = 0;
  contents.split("\n").forEach(input => {
    if (input.length) {
      const [l, w, h] = input.split('x').map(x => parseInt(x));
      const areas = [l*w, w*h, h*l];

      totalRibbon += Math.min.call(null, 2*l + 2*w, 2*w + 2*h, 2*h + 2*l) + (l * w * h);
      total += areas.map(s => 2 * s).reduce((a, b) => a + b) + Math.min.apply(null, areas);
    }
  });
  console.log(`they need to order ${total} paper and ${totalRibbon} ribbon.`);
});
