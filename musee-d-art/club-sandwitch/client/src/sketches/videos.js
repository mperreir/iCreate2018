import "p5/lib/addons/p5.sound";
import p5 from "p5";


let vid;
let video_name;
let playing = false;
let timeC;
let timeF;
let boolTC = false;
let boolTF = false;

let mic;
let amp;
let amplitude;
let socket;

export default function sketch(p) {
  p.setup = function() {
    p.createCanvas(0, 0);
    vid = p.createVideo([video_name]);
    //button = p.createButton('play');
    //button.mousePressed(p.toggleVid);
    mic = new p5.AudioIn();
    mic.start();
    amp = new p5.Amplitude(0.2);
    amp.setInput(mic);
    console.log(video_name);
    timeC = p.millis();
    timeF = p.millis();
  };

  p.toggleVid = function() {
    if (playing) {
      vid.pause();
    } else if(video_name === "./video/1.mp4") {
      vid.loop();
    } else {
      vid.play();
    }
    playing = !playing;
    console.log("playing " + playing);
  };

  p.myCustomRedrawAccordingToNewPropsHandler = function (props) {
      if(vid){
          if(video_name !== props.video_name){
             console.log("chat video");
             video_name = props.video_name;
             console.log(video_name);
             vid.hide();
             vid.stop();
             vid = p.createVideo(video_name);
             timeC = p.millis();
             timeF = p.millis();
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
    if(p.millis() - timeC > 11000 && amplitude > 0.2 && video_name === './video/2.mp4') {
      console.log('chien ' + amplitude + ' : ' + p.millis());
      if(boolTC){
        boolTC = true;
      } else {
        socket.emit('play-intro', 3);
        boolTC = true;
      }
      
    } else if (p.millis() - timeF > 10000 && amplitude > 0.2 && video_name === './video/1.mp4') {
      console.log('Presto ' + amplitude + ' : ' + p.millis());
      if(boolTF){
        boolTF = true;
      } else {
        socket.emit('play-intro', 2);
        boolTF = true;
      }
    } else if (amplitude > 0.05 && video_name === './video/2.mp4') {
      console.log('vache - coq - poule ' + amplitude  + ' : ' + p.millis());
    }
  }
}
