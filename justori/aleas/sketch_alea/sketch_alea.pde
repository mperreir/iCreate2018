import processing.video.*;

/**
 * This is a simple example of how to use the Keystone library.
 *
 * To use this example in the real world, you need a projector
 * and a surface you want to project your Processing sketch onto.
 *
 * Simply drag the corners of the CornerPinSurface so that they
 * match the physical surface's corners. The result will be an
 * undistorted projection, regardless of projector position or
 * orientation.
 *
 * You can also create more than one Surface object, and project
 * onto multiple flat surfaces using a single projector.
 *
 * This extra flexbility can comes at the sacrifice of more or
 * less pixel resolution, depending on your projector and how
 * many surfaces you want to map.
 */

import deadpixel.keystone.*;
import oscP5.*;
import netP5.*;
import java.util.Calendar;

Keystone ks;
collectionSurface surfaces;
ArrayList<Movie> lesFilms;
ArrayList<OffScreen> lesContenus;
VideoFrame frame;
OffScreen frame2;
int y;

OscP5 osc;
NetAddress remote;


float[] gravity = {10.0,10.0,10.0};

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


void setup() {
  // On veut un rendu en 3D pour le fonctionnement de keystone et en plein écran pour la projection
  fullScreen(P3D);
  // On crée l'ojet keystone qui va gérer les surfaces que l'on veut map
  ks = new Keystone(this);
  //On charge les vidéo que l'on veut utiliser
  String[] fichierFilm = {"portion_1.mp4", "portion_2.mp4", "portion_4.mp4", "portion_6.mp4", "portion_7.mp4", "portion_8.mp4", "portion_9.mp4", "portion_10.mp4", "portion_12.mp4", "portion_13.mp4"};
  lesFilms = creerMovie(fichierFilm);
  lesContenus = new ArrayList<OffScreen>();
  for(int i = 0; i < lesFilms.size(); i++){
    lesContenus.add(new VideoFrame(600,600,lesFilms.get(i)));
  }
  //On charge une surface qui sert a la projection d'une vidéo
  surfaces = new collectionSurface();
  for(int i = 0; i < 7; i++){
    surfaces.add(new Surface(ks, 600,600,20, i));
  }
  Helper.setOffScreens(lesContenus);
  Helper.setupOffScreen(surfaces.getSurface(0),0);
  Helper.setupOffScreen(surfaces.getSurface(1),1);
  Helper.setupOffScreen(surfaces.getSurface(2),2);
  Helper.setupOffScreen(surfaces.getSurface(3),3);
  y = 0;

  osc=new OscP5(this,12000); //listen on port 12000
  osc.plug(this,"rotationR1","/rotation_vector/r1");
}

void draw() {
  //On veut un fond noir et éclairer uniquement les cubes
  background(0);
  surfaces.draw();
  println(y);
  y++;
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

        // println(themsg.arguments());
    }
}



void rotationR1(float rotationValue) {
    long currentTime = Calendar.getInstance().getTimeInMillis();
    long deltaTemps = currentTime - this.lastRotationDate;

    boolean wasAscendant = estAscendant();
    boolean wasDescendant = estDescendant();

    long prevRotationDate = this.lastRotationDate;
    this.lastRotationDate = currentTime;

    this.rotationVitesseInstant = rotationValue - this.rotation;
    // rotationVitesseInstantCorrige = rotationVitesseInstant / deltaTemps;
    this.rotation = rotationValue;


    println("@@@ rotation r1 event @@@");
    println("t : " + deltaTemps);
    println("dt : " + this.rotationVitesseInstant);

    boolean change = false;

    if (estDescendant()) {
        this.rotationMin = rotationValue;
        this.preRotationMax = this.rotationMax;
        if (wasAscendant) {
            this.dateMax = lastRotationDate;
            change = true;
        }

    }
    if (estAscendant()) {
        this.rotationMax = rotationValue;
        this.preRotationMin = rotationMin;
        if (wasDescendant) {
            this.dateMin = lastRotationDate;
            change = true;
        }
    }
    this.rotationAmplitude = this.preRotationMax - this.preRotationMin;
    this.demiPeriode = Math.abs(dateMax - dateMin);

    println("Minimum : " + this.rotationMin);
    println("Maximum : " + this.rotationMax);
    println("Amplitude : " + this.rotationAmplitude);
    println("Periode : " + (2 * this.demiPeriode));
    println("Frequence : " + (1000/(2.0*this.demiPeriode)));

    if (change) newAmplitude();
}

private void newAmplitude() {
    println("CHANGE");

}

private boolean estDescendant() {
    return rotationVitesseInstant < -0.006;
}

private boolean estAscendant() {
    return rotationVitesseInstant > 0.006;
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
