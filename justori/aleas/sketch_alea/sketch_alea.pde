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
Surface surf;
Movie mov;

PGraphics offscreenMobile;
CornerPinSurface surfaceMobile;

OscP5 osc;
NetAddress remote;

int gravX=50;
int gravY=50;

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

void setup(){
    // On veut un rendu en 3D pour le fonctionnement de keystone et en plein écran pour la projection
    // Keystone will only work with P3D or OPENGL renderers,
    // since it relies on texture mapping to deform
    //size(800, 600, P3D);

    fullScreen(P3D);
    // On crée l'ojet keystone qui va gérer les surfaces que l'on veut map
    ks=new Keystone(this);
    //On charge les vidéo que l'on veut utiliser
    mov=new Movie(this,"stepteen2.mov");
    //On charge une surface qui sert a la projection d'une vidéo

    osc=new OscP5(this,12000); //listen on port 12000

    ks=new Keystone(this); // init the keystoen object
    // surface=ks.createCornerPinSurface(200,120,20); // create the surface
    // surface2=ks.createCornerPinSurface(160,120,20); // create the surface
    surf=new Surface(ks,500,500,20);
    // offscreenMobile=createGraphics(500,500,P3D);
    // surfaceMobile=ks.createCornerPinSurface(400,400,20);


    osc.plug(this,"rotationR1","/rotation_vector/r1");



}


void draw(){
    //On veut un fond noir et éclairer uniquement les cubes
    background(0);
    surf.draw();
}

void keyPressed(){
    switch(key){
        case'c':
            // enter/leave calibration mode, where surfaces can be warped
            // and moved
            ks.toggleCalibration();
            break;

        case'l':
            // loads the saved layout
            ks.load();
            break;

        case's':
            // saves the layout
            ks.save();
            break;

        case'p':
            // play/pause the movie on keypress
            if (true){
            } else {
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
