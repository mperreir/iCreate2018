import {p5, fill, noFill, background, millis} from "p5";

let marge = 5
let wTab = 768;
let hTab = 1024;
let hRect = 100; //Hauteur de la barre de chargement
let wRect = 0;

let play = true;
let time;

export default function sketch(p) {
  p.setup = function() {
    p.createCanvas(wTab, hRect);
    p.noFill();
    p.rect(0, 0, wTab-1, hRect-1);
    p.fill(0);
    p.rect(marge, marge, wRect, hRect - marge*2);
    time = p.millis();
  };

  p.draw = function() {
    //console.log(time);
    if (p.millis() - time > 50) {
      time = p.millis();
      //p.background(0);
      wRect++;
      console.log(wRect);
      p.rect(marge, marge, wRect, hRect - marge*2);

    }
  };

  p.myCustomRedrawAccordingToNewPropsHandler = function(props) {
    // this.play = props.isPlaying;
    //scareInt.w += 40;
  };
}
