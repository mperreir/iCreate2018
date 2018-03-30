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

OscP5 osc;
NetAddress remote;

private SketchMapper sketchMapper;
private TestSketch testSketch1;

public void setup() {
  size(800, 600, P3D);

  //On crée le controleur osc qui va nous permettre d'envoyer/recevoir des messages

  osc = new OscP5(this, 12000);

  osc.plug(this, "test", "/accelerometer/linear/y");
  osc.plug(this, "light", "/light");

  //create our SketchMapper
  sketchMapper = new SketchMapper(this);

  testSketch1 = new TestSketch(this, width/2, height/ 2);

  //create a sketch and add it to the SketchMapper
  sketchMapper.addSketch(testSketch1);



}

public void draw() {
  //must call this for the sketches and the GUI to be rendered.
  sketchMapper.draw();
}

public void test(float yaccel) {
  println("### plug event method. /test");
  println("acceleration y = " + yaccel);
}

public void light(float lightLevel) {
    println("@@@ light event");
    if (lightLevel < 255) testSketch1.couleur[0] = Math.round(lightLevel);
}

void oscEvent(OscMessage themsg) {
  if(themsg.isPlugged()==false){
    println("### received an osc message.");
    println("### addrpattern\t"+themsg.addrPattern());

    println(themsg.arguments());
  }
}
