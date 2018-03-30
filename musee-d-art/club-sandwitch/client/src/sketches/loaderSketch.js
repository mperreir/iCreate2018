import "p5/lib/addons/p5.sound";
import p5 from "p5";


let marge = 5
let wTab = 768;
let hTab = 1024;
let hRect = 100; //Hauteur de la barre de chargement
let wRect = 0;

let play = false;
let time;

export default function sketch(p) {
  p.setup = function() {
    p.createCanvas(wTab, hRect);
    p.noFill();
    p.rect(0, 0, wTab - 1, hRect - 1);
    p.fill(0);
    p.rect(marge, marge, wRect, hRect - marge * 2);
    time = p.millis();
  };

  p.draw = function() {
    //console.log(time);
    if ((p.millis() - time > 50) && play) {
      time = p.millis();
      wRect++;
      console.log(wRect);
      p.rect(marge, marge, wRect, hRect - marge * 2);

    }
  };

  p.myCustomRedrawAccordingToNewPropsHandler = function(props) {
    switch (props.nomFct) {
      case "play":
        play = true;
        break;
      case "pause":
        play = false;
        break;
      case "stop":
        wRect = 0;
        play = false;
        break;
      default:
    };
  }
}