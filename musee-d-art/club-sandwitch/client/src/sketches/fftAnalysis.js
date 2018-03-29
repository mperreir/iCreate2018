import "p5/lib/addons/p5.sound";
import p5 from "p5";

let mic;
let res;
let writingbool = false;
let writer;

let son;
//let son2;
let fft;
let freqChien = [191, 184, 149, 67, 23, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
let freqGrenouille = [201, 229, 232, 203, 142, 113, 89, 43, 5, 8, 23, 8, 0, 0, 0, 0];
let freqVache = [220, 206, 159, 71, 31, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
let freqCoqPoule = [154, 154, 138, 123, 130, 136, 121, 89, 29, 0, 0, 0, 0, 0, 0, 0];

let animaux = ['Grenouille', 'Coq_Poule', 'Chien', 'Vache'];

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
        console.log(freqChien.length);
        fft = new p5.FFT(0.2, 16);
        fft.setInput(mic);
        p.createButton('record')
        .position(10, 10)
        .mousePressed(function() {
            writer = p.createWriter('sound.txt');
            writingbool = true;
        })
        p.createButton('save')
        .position(100, 10)
        .mousePressed(function() {
            if(writingbool) {
                writer.close();
                writer.clear();
            }            
        })
    };

    p.diff = function(spc) {
        let sG = 0, sQP = 0, sC = 0, sV = 0;
        for (var i = 0; i< freqGrenouille.length; i++) {
            sG += Math.abs(freqGrenouille[i] - spc[i]);
            sQP += Math.abs(freqCoqPoule[i] - spc[i]);
            sC +=Math.abs(freqChien[i] - spc[i]);
            sV += Math.abs(freqVache[i] - spc[i]);
        }
        return [sG/100, sQP/100, sC/100, sV/100];
    }
    p.argMin = function(array) {
        return array.map((x, i) => [x, i]).reduce((r, a) => (a[0] < r[0] ? a : r))[1];
      }

    p.draw = function() {
        p.background(0);
        var spectrum = fft.analyze();
        //console.log(spectrum);
        res = p.diff(spectrum);
        console.log(res, animaux[p.argMin(res)]);
        if(writingbool){
            writer.print(spectrum);
        }
        p.noStroke();
        p.fill(0,255,0); // spectrum is green
        for (var i = 0; i< spectrum.length; i++){
            var x = p.map(i, 0, spectrum.length, 0, p.width);
            var h = -p.height + p.map(spectrum[i], 0, 255, p.height, 0);
            p.rect(x, p.height, p.width / spectrum.length, h);
        }

        p.fill(255,255,0); // waveform is red
        for (var i = 0; i< freqChien.length; i++){
            var x = p.map(i, 0, freqChien.length, 500, p.width);
            var h = -p.height + p.map(freqChien[i], 0, 1000, p.height, 0);
            p.rect(x, p.height, p.width / freqChien.length, h);
        }
        p.fill(255,255,255); // waveform is red
        for (var i = 0; i< freqGrenouille.length; i++){
            var x = p.map(i, 0, freqGrenouille.length, 500, p.width);
            var h = -p.height + p.map(freqGrenouille[i], 0, 1000, p.height, 0);
            p.rect(x, 3*p.height/4, p.width / freqGrenouille.length, h);
        }
        p.fill(0,255,255); // waveform is red
        for (var i = 0; i< freqVache.length; i++){
            var x = p.map(i, 0, freqVache.length, 500, p.width);
            var h = -p.height + p.map(freqVache[i], 0, 1000, p.height, 0);
            p.rect(x, p.height/2, p.width / freqVache.length, h);
        }
        p.fill(255,0,255); // waveform is red
        for (var i = 0; i< freqCoqPoule.length; i++){
            var x = p.map(i, 0, freqCoqPoule.length, 500, p.width);
            var h = -p.height + p.map(freqCoqPoule[i], 0, 1000, p.height, 0);
            p.rect(x, p.height/4, p.width / freqCoqPoule.length, h);
        }

        var waveform = fft.waveform();
        p.noFill();
        p.beginShape();
        p.stroke(255,0,0); // waveform is red
        p.strokeWeight(1);
        for (var i = 0; i< waveform.length; i++){
            var x = p.map(i, 0, waveform.length, 0, p.width);
            var y = p.map( waveform[i], -1, 1, 0, p.height);
            p.vertex(x,y);
        }
        p.endShape();
    };
}
