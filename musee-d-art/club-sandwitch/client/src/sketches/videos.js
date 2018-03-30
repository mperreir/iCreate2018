import "p5/lib/addons/p5.dom";

let vid;
let video_name;
let playing = false;


export default function sketch(p) {
  p.setup = function() {
    p.createCanvas(0, 0);
    vid = p.createVideo([video_name]);
  };

  p.toggleVid = function() {
    if (playing) {
      vid.pause();
    } else {
      vid.play();
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
      }
 }
}
