import "p5/lib/addons/p5.dom";

let button;
let vid;
let video_name;
let playing = false;


export default function sketch(p) {
  p.setup = function() {
    p.createCanvas(0, 0);
    //p.background(10);
    // specify multiple formats for different browsers
    vid = p.createVideo([video_name]);
    button = p.createButton('play');
    button.mousePressed(p.toggleVid); // attach button listener
  };

  p.toggleVid = function() {
    if (playing) {
      vid.pause();
      button.html('play');
    } else {
      vid.loop();
      button.html('pause');
    }
    playing = !playing;
    console.log("playing " + playing);
  };

  p.myCustomRedrawAccordingToNewPropsHandler = function (props) {
      if(vid){
          playing = !props.isplaying
          p.toggleVid();
      }else{
          video_name = props.video_name;
      }

 }

}
