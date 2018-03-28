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

Keystone ks; // the keystone object
CornerPinSurface surface; // this is the surface
CornerPinSurface surface2; // this is the surface
Surface surf;
Movie mov; // this will hold the movie
Movie mov2;
boolean isPlaying = false;
PGraphics offscreen;
PGraphics offscreen2;// the offsceen buffer

PGraphics offscreenMobile;
CornerPinSurface surfaceMobile;

OscP5 osc;
NetAddress remote;

int gravX = 50;
int gravY = 50;

void setup() {
  // Keystone will only work with P3D or OPENGL renderers,
  // since it relies on texture mapping to deform
  //size(800, 600, P3D);

  fullScreen(P3D);

  osc = new OscP5(this, 12000);

  ks = new Keystone(this); // init the keystoen object
  surface = ks.createCornerPinSurface(200, 120, 20); // create the surface
  surface2 = ks.createCornerPinSurface(160, 120, 20); // create the surface
  surf = new Surface(ks, 500, 500, 20);
  mov = new Movie(this, "stepteen2.mov" ); // load the video
  mov2 = new Movie(this, "step.mov" );
  mov.frameRate(25); // set the framerate
  mov2.frameRate(25); // set the framerate

  // We need an offscreen buffer to draw the surface we
  // want projected
  // note that we're matching the resolution of the
  // CornerPinSurface.
  // (The offscreen buffer can be P2D or P3D)
  offscreen = createGraphics(500, 500, P3D);
  offscreen2 = createGraphics(500, 500, P3D);
  mov.play();// we need to start the movie once
  mov.jump(0);// go to the first frame
  mov.pause(); // and hold it until we hit p
  mov2.play();// we need to start the movie once
  mov2.jump(0);// go to the first frame
  mov2.pause(); // and hold it until we hit p

  offscreenMobile = createGraphics(500,500, P3D);
  surfaceMobile = ks.createCornerPinSurface(400,400,20);

  osc.plug(this, "changeGravX", "/accelerometer/gravity/x");
  osc.plug(this, "changeGravY", "/accelerometer/gravity/y");


}

void draw() {

  // Draw the scene, offscreen
  offscreen.beginDraw(); // start writing into the buffer
  offscreen.background(255);
  offscreen.image(mov, 0, 0); // <-- here we add the current frame to the buffer
  offscreen.endDraw(); // we are done 'recording'

  offscreen2.beginDraw(); // start writing into the buffer
  offscreen2.background(255);
  offscreen2.image(mov2, 0, 0); // <-- here we add the current frame to the buffer
  offscreen2.endDraw(); // we are done 'recording'

  offscreenMobile.beginDraw();
  offscreenMobile.ellipse(gravX,gravY,20,20);
  offscreenMobile.endDraw();

  // most likely, you'll want a black background to minimize
  // bleeding around your projection area
  background(0);
  // this is for resetting the video after it was played.
  if (mov.time() == mov.duration()) {
    mov.jump(0);
  }
  if (mov2.time() == mov2.duration()) {
    mov2.jump(0);
  }

  surf.draw();
  surface.render(offscreen);// add everything to the surface
  surface2.render(offscreen2);
  surfaceMobile.render(offscreenMobile);
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
  case 'p':
    // play/pause the movie on keypress
    if (isPlaying == false) {
      mov.play();
      mov2.play();
      isPlaying = true;
    } else {
      mov.pause();
      mov2.pause();
      isPlaying = false;
    }
    break;
  }
}

void movieEvent(Movie m) {
  m.read();
}

void oscEvent(OscMessage themsg) {
  if(!themsg.isPlugged()){
    println("### received an osc message.");
    println("### addrpattern\t"+themsg.addrPattern());

    // println(themsg.arguments());
  }
}

void changeGravX(float gravity) {
    println("@@@ gravity X event");
    gravX = Math.round(gravity+25)*100;
}
void changeGravY(float gravity) {
    println("@@@ gravity Y event " + gravity);
    gravY = Math.round(gravity + 25)*100;
}
