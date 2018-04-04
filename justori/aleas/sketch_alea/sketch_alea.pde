import processing.video.*;

import deadpixel.keystone.*;
import oscP5.*;
import netP5.*;
import java.util.Calendar;

import ddf.minim.*;

Keystone ks;
collectionSurface surfaces;
ArrayList<Movie> lesFilms;
ArrayList<OffScreen> lesContenus;
VideoFrame frame;
OffScreen frame2;
int y;

OscP5 osc;
NetAddress remote;


long lastRotationDate = 0;
// long prevRotationDate = 0;

float rotation = 0.0;
float rotationVitesseInstant = 0.0;

boolean ascendant = false;
boolean descendant = false;

float rotationMin = 0.0;
float preRotationMin = 0.0;

float rotationMax = 0.0;
float preRotationMax = 0.0;

float rotationAmplitude = 0.0;

long dateMin = 0;
long dateMax = 0;
long demiPeriode = 0;


float vitesse = 0;
float vitesseMax = 0;
int change = 0;

Minim minim;
AudioPlayer voix;

boolean isPlaying = false;

boolean[] ambiancesPause;
AudioPlayer[] ambiances;

boolean e1 = false;
boolean e2 = false;
boolean e3 = false;
boolean e4 = false;
boolean e5 = false;
boolean e6 = false;
boolean e7 = false;
boolean e8 = false;

void setup() {
  // On veut un rendu en 3D pour le fonctionnement de keystone et en plein écran pour la projection
  fullScreen(P3D);
  // On crée l'ojet keystone qui va gérer les surfaces que l'on veut map
  ks = new Keystone(this);
  //On charge les vidéo que l'on veut utiliser
  // String[] fichierFilm = {"portion_1.mp4", "portion_2.mp4", "portion_4.mp4", "portion_6.mp4", "portion_7.mp4", "portion_8.mp4", "portion_9.mp4", "portion_10.mp4", "portion_12.mp4", "portion_13.mp4"};
  // lesFilms = creerMovie(fichierFilm);
  // lesContenus = new ArrayList<OffScreen>();
  // for(int i = 0; i < lesFilms.size(); i++){
  //   lesContenus.add(new VideoFrame(600,600,lesFilms.get(i)));
  // }
  // //On charge une surface qui sert a la projection d'une vidéo
  // surfaces = new collectionSurface();
  // for(int i = 0; i < 7; i++){
  //   surfaces.add(new Surface(ks, 600,600,20, i));
  // }
  // Helper.setOffScreens(lesContenus);
  // Helper.setupOffScreen(surfaces.getSurface(0),0);
  // Helper.setupOffScreen(surfaces.getSurface(1),1);
  // Helper.setupOffScreen(surfaces.getSurface(2),2);
  // Helper.setupOffScreen(surfaces.getSurface(3),3);
  // y = 0;

  osc=new OscP5(this,12000); //listen on port 12000
  osc.plug(this,"pitch","/orientation/pitch");

  minim = new Minim(this);
  voix = minim.loadFile("sonVideoCorrige.mp3");

  this.ambiances = new AudioPlayer[1];


  this.ambiances[0] = this.minim.loadFile("vent.mp3");
  this.ambiances[0].play();
  this.ambiances[0].loop();
  // this.ambiances[0].setVolume(0);
  this.ambiances[0].setGain(-80);

}

void draw() {
  //On veut un fond noir et éclairer uniquement les cubes
  background(0);
  // surfaces.draw();
  // println(y);
  // y++;
}

void keyPressed() {
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped
    // and moved
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;
  case 't':
    for(int i = 0; i < surfaces.getSize(); i++){
      surfaces.getSurface(i).setOffScreenBuffer(new OffScreen(500,500));
    }
    break;
  case 'p':
    // play/pause the movie on keypress
    if (!frame.isPlaying()) {
      frame.play();
    } else {
        frame.pause();
    }
    break;
  }
}



void movieEvent(Movie m){
    m.read();
}

void oscEvent(OscMessage themsg){
    if(!themsg.isPlugged()){
        // println("### received an osc message.");
        // println("### addrpattern\t"+themsg.addrPattern());
        //
        // println(themsg.arguments());
    }
}



void pitch(float rotationValue) {
    long currentTime = Calendar.getInstance().getTimeInMillis();
    long deltaTemps = currentTime - this.lastRotationDate;

    boolean wasAscendant = estAscendant();
    boolean wasDescendant = estDescendant();

    long prevRotationDate = this.lastRotationDate;
    this.lastRotationDate = currentTime;

    this.rotationVitesseInstant = rotationValue - this.rotation;
    // rotationVitesseInstantCorrige = rotationVitesseInstant / deltaTemps;
    this.rotation = rotationValue;


    this.change += 1;

    if (estDescendant()) {
        this.rotationMin = rotationValue;
        this.preRotationMax = this.rotationMax;
        if (wasAscendant) {
            this.dateMax = lastRotationDate;
            change = 0;
        }

    }
    if (estAscendant()) {
        this.rotationMax = rotationValue;
        this.preRotationMin = rotationMin;
        if (wasDescendant) {
            this.dateMin = lastRotationDate;
            change = 0;
        }
    }
    this.rotationAmplitude = this.preRotationMax - this.preRotationMin;
    this.demiPeriode = Math.abs(dateMax - dateMin);

    // println("@@@ compass pitch event @@@");
    // println("t : " + deltaTemps);
    // println("dt : " + this.rotationVitesseInstant);
    // println("Minimum : " + this.rotationMin);
    // println("Maximum : " + this.rotationMax);
    // println("Amplitude : " + this.rotationAmplitude);
    // println("Periode : " + (2 * this.demiPeriode));
    // println("Frequence : " + (1000/(2.0*this.demiPeriode)));

    if (this.change == 0) newAmplitude(0.02);
    if (this.change > 3) newAmplitude(-0.03);
}

private void newAmplitude(float add) {
    // println("CHANGE");

    // float add = this.rotationAmplitude - 0.1;

    this.vitesse += add;

    if (this.vitesse < 0) {
        this.vitesse = 0.0;
    }
    if (this.vitesse > 1) this.vitesse = 1.0;

    // if (this.vitesse > 0) this.sonPause = false;

    // println(rotationAmplitude);
    println(vitesse);

    verifSon();

}

private void verifSon() {


    if (this.vitesse > 0) {
        if (!this.isPlaying) {
            // println("PLAY");
            this.voix.play();
            this.isPlaying = true;
            // VIDEO BOUCHE PLAY
        }

    } else {
        if (this.isPlaying){
            // println("PAUSE");

            this.voix.pause();
            this.isPlaying = false;
            // PAUSE DE TOUT
            this.ambiances[0].setGain(-80);

            e1 = false;
            e2 = false;
            e3 = false;
            e4 = false;
            e5 = false;
            e6 = false;
            e7 = false;
            e8 = false;

            }
        if (this.change > 4*8) {
            //INACTIVIF DEPUIS 8s
            println("INACTIF");
            reset();
        }

    }
    if ((this.vitesse > 1.0/8) && !e1) {
        println("e1");
        e1 = true;
    }
    if ((this.vitesse > 2.0/8) && !e2) {
        println("e2");
        e2 = true;
        this.ambiances[0].shiftGain(-80, -10, 2000);

    }
    if ((this.vitesse > 3.0/8) && !e3) {
        println("e3");
        e3 = true;

    }
    if ((this.vitesse > 4.0/8) && !e4) {
        println("e4");
        e4 = true;

    }
    if ((this.vitesse > 5.0/8) && !e5) {
        println("e5");
        e5 = true;

    }
    if ((this.vitesse > 7.0/8) && !e6) {
        println("e6");
        e6 = true;
    }


    // final int nbAmbiances = this.ambiances.length;

    // for (int i = 0; i < nbAmbiances; i++) {
    //     if (this.vitesse > 0.5) {
    //         // this.ambiances[i].setGain(-10);
    //         this.ambiances[i].shiftGain(-80, -10, 2000);
    //     } else {
    //         // this.ambiances[i].setGain(-80);
    //         this.ambiances[i].shiftGain(-10,-80, 2000);
    //     }
    //
    // }
}



private boolean estDescendant() {
    return rotationVitesseInstant < -1.5;
}

private boolean estAscendant() {
    return rotationVitesseInstant > 1.5;
}

// Permet de créer une liste de films a partir d'une liste de nom de fichiers.
// Les fichiers doivent être dans le dossier data
ArrayList<Movie> creerMovie(String[] liste){
  ArrayList<Movie> movies = new ArrayList<Movie>();
  for(int i = 0; i < liste.length; i++){
    movies.add(new Movie(this, liste[i]));
  }
  return movies;
}

void reset() {
    println("RESET");
    this.voix.rewind();
    this.voix.pause();
    this.ambiances[0].setGain(-80);
    this.isPlaying = false;

    e1 = false;
    e2 = false;
    e3 = false;
    e4 = false;
    e5 = false;
    e6 = false;
    e7 = false;
    e8 = false;

}
