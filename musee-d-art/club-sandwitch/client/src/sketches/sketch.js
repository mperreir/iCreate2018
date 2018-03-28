import "p5/lib/addons/p5.sound";
import p5 from "p5";

let loop;
let mic;
let diameter;

let colors = [
  "rgb(203, 212, 194)",
  "rgb(219, 235, 192)",
  "rgb(195, 178, 153)",
  "rgb(129, 83, 85)",
  "rgb(82, 50, 73)"
];

export default function sketch(p) {
  p.setup = function() {
    p.createCanvas(window.innerWidth, window.innerHeight);
    p.background(10);
    mic = new p5.AudioIn();
    mic.start();
    loop = true;
  };

  p.removeMic = function() {
    mic.stop();
    mic.dispose();
  };

  p.keyPressed = function() {
    if (loop === true) {
      p.noLoop();
      loop = false;
    } else {
      p.loop();
      loop = true;
    }
  };

  p.circles = function() {
    let level = mic.getLevel();
    diameter = p.map(level, 0, 1, 5, 2000);

    let x = p.mouseX + (Math.random() - 0.5) * (Math.random() * 100);
    let y = p.mouseY + (Math.random() - 0.5) * (Math.random() * 100);
    for (let i = 0; i < 3; i++) {
      p.noStroke();
      p.fill(colors[Math.floor(Math.random() * colors.length)]);
      p.ellipse(x, y, diameter, diameter);
    }
  };

  p.draw = function() {
    p.circles();
  };
}
