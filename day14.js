const fs = require('fs');

fs.readFile('day14.input', 'utf8', (err, contents) => {
  contents = contents.trim();

  const reindeer = [];

  function fly() {
    this.distance += this.speed;
    this.checkNext(this.restTime, rest);
  }

  function rest() {
    this.checkNext(this.speedTime, fly);
  }

  function Reindeer(name, speed, speedTime, restTime) {
    this.name = name;
    this.speed = parseInt(speed);
    this.speedTime = parseInt(speedTime);
    this.restTime = parseInt(restTime);
    this.distance = 0;
    this.ticksLeft = speedTime;
    this.tick = fly;
    this.points = 0;
  }

  Reindeer.prototype.checkNext = function(nextTime, nextState) {
    this.ticksLeft--;
    if (this.ticksLeft === 0) {
      this.ticksLeft = nextTime;
      this.tick = nextState;
    }
  };

  contents.split("\n").forEach(input => {
    const m = /([a-zA-Z]+) can fly (\d+) km\/s for (\d+) seconds?, but then must rest for (\d+) seconds\./.exec(input);
    if (m) {
      reindeer.push(new Reindeer(m[1], m[2], m[3], m[4]));
    }
  });

  let maxDistance = 0;
  let maxPoints = 0;
  for (let i=0; i<2503; i++) {
    reindeer.forEach(r => {
      r.tick();
      if (r.distance > maxDistance) { maxDistance = r.distance; }
    });

    reindeer.forEach(r=> {
      if (r.distance === maxDistance) { r.points++; }
      if (r.points > maxPoints) { maxPoints = r.points; };
    });
  }

  console.log(`max distance: ${maxDistance}`);
  console.log(`max points: ${maxPoints}`);
});
