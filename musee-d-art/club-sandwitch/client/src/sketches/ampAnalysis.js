import "p5/lib/addons/p5.sound";
import p5 from "p5";

let mic;
let amp;

let son;
//let son2;
let fft;

export default function sketch(p) {
    p.preload = function() {
        son = p.loadSound("./sonQueteChien/COQ-POULE.mp3");
        //son2 = p.loadSound('CORNE.wav');
    }

    p.setup = function() {
        p.createCanvas(window.innerWidth, window.innerHeight);
        p.background(10);
        son.loop();
        mic = new p5.AudioIn();
        mic.start();
        fft = new p5.FFT(0.2, 16);
        amp = new p5.Amplitude(0.2);
        fft.setInput(mic);
        amp.setInput(mic);
    };

    p.draw = function() {
        let res = amp.getLevel();
        p.background(10);
        console.log(res);
        p.textSize(32);
        p.fill(0, 102, 153);
        p.text(res, 100, 300);

    };
}
