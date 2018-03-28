import "p5/lib/addons/p5.dom";

let mySound;
let src;

export default function sketch(p) {

  p.preload = function() {
    p.soundFormats('mp3');
    mySound = p.loadSound(src);
  }

  p.setup = function() {
    mySound.setVolume(0.1);
    //mySound.play();
  }

  p.myCustomRedrawAccordingToNewPropsHandler = function(props) {
    if (mySound) {
      if (mySound.isLoaded()) {
        switch (props.nomFct) {
          case "play":
            mySound.play();
            break;
          case "pause":
            mySound.pause();
            break;
          case "stop":
            mySound.stop();
            break;
          default:
          
        }
      }
    } else {
      src = props.arg;
    }
  }

}
