import "p5/lib/addons/p5.dom";

let button;
let vid;
let video_name;
let playing = false;

let mic;
let amp;
let amplitude;
let socket;

export default function sketch(p) {
  p.setup = function() {
    p.createCanvas(0, 0);
    vid = p.createVideo([video_name]);
    button = p.createButton('play');
    button.mousePressed(p.toggleVid);
    mic = new p5.AudioIn();
    mic.start();
    amp = new p5.Amplitude(0.99);
    amp.setInput(mic);
  };

  p.toggleVid = function() {
    if (playing) {
      vid.pause();
      button.html('play');
    } else {
      vid.play();
      button.html('pause');
    }
    playing = !playing;
    console.log("playing " + playing);
  };

  p.myCustomRedrawAccordingToNewPropsHandler = function (props) {
      if(vid){
          if(video_name !== props.video_name){
             console.log("chgt video");
             video_name = props.video_name;
             console.log(video_name);
             vid.hide();
             vid = p.createVideo(video_name);
          }
          playing = !props.isplaying
          p.toggleVid();
      }else{
          video_name = props.video_name;
          socket = props.socket;
      }
 }

  p.draw = function() {
    amplitude = amp.getLevel();
    if(amplitude > 0.5) {
      console.log('chien ' + amplitude);
    } else if (amplitude > 0.4 && video_name === '1.mp4') {
      console.log('Presto ' + amplitude);
      socket.emit('playIntro',2);
    } else if (amplitude > 0.4 && video === '2.mp4') {
      console.log('vache - coq - poule ' + amplitude);
      socket.emit('playIntro',3);
    } else {
      console.log('bruit de fond');
    }

  }
}
