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

Keystone ks;
Surface surf;
Movie mov;

PGraphics offscreenMobile;
CornerPinSurface surfaceMobile;

OscP5 osc;
NetAddress remote;

int gravX=50;
int gravY=50;

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

    osc.plug(this,"changeGravX","/accelerometer/gravity/x");
    osc.plug(this,"changeGravY","/accelerometer/gravity/y");

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
        println("### received an osc message.");
        println("### addrpattern\t"+themsg.addrPattern());

        // println(themsg.arguments());
    }
}

void changeGravX(float gravity){
    println("@@@ gravity X event");
    gravX=Math.round(gravity+25)*100;
}
void changeGravY(float gravity){
    println("@@@ gravity Y event "+gravity);
    gravY=Math.round(gravity+25)*100;
}
