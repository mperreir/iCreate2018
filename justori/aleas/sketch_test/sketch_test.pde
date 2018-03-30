/*
  This is a simple test sketch showing the
  The usage of the SketchMapper with one sketch.
  The sketch in TestSketch.pde is a very simple sketch that draws
  random ellipses.
  *** Note: This library requires that you have
            ControlP5 v. 2.2.5 installed and imported ! ***
*/
import controlP5.*;
import javax.media.jai.*;
import jto.processing.sketch.mapper.*;
import com.sun.media.jai.util.*;
import ixagon.surface.mapper.*;
import oscP5.*;
import netP5.*;
import processing.video.*;

OscP5 osc;
NetAddress remote;

private SketchMapper sketchMapper;

public void setup() {
  size(800, 600, P3D);
  
  //On crée le controleur osc qui va nous permettre d'envoyer/recevoir des messages
  
  osc = new OscP5(this, 12000);
  
  osc.plug(this, "test", "/accelerometer/linear/y");

  //create our SketchMapper
  sketchMapper = new SketchMapper(this);
  
  println("loadvid");
  Movie mov = new Movie(this, "stepteen2.mov");
  println("video chargee");

  //create a sketch and add it to the SketchMapper
  //sketchMapper.addSketch(new TestSketch(this, width / 2, height / 2));
  sketchMapper.addSketch(new videoSketch(this, width / 2, height / 2, mov));
  sketchMapper.addSketch(new test(this, width / 2, height / 2));
  
}

public void draw() {
  //must call this for the sketches and the GUI to be rendered.
  sketchMapper.draw();
}

public void test(float yaccel) {
  println("### plug event method. /test");
  println("acceleration y = " + yaccel);
}

void oscEvent(OscMessage themsg) {
  if(themsg.isPlugged()==false){
    println("### received an osc message.");
    println("### addrpattern\t"+themsg.addrPattern());
    println("### typetag\t"+themsg.typetag());
  }
}
