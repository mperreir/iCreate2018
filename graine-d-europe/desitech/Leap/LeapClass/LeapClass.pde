import com.leapmotion.leap.*;
import java.util.LinkedList;

public class Leap {
  
  private Controller controller;
  public Leap() {
    this.controller = new Controller();
    controller.enableGesture(Gesture.Type.TYPE_SWIPE);
    controller.enableGesture(Gesture.Type.TYPE_CIRCLE);
  }
  
  public int countHands() {
   Frame frame = this.controller.frame();
   return frame.hands().count();
  }
  
  public boolean actionPoing() {
    Frame frame = this.controller.frame();
    final float SEUIL = 0.9;
    boolean ret = false;
    if (frame.hands().count() == 1) {
      Hand hand = frame.hands().get(0);
      if (hand.grabStrength() >= SEUIL) {
        ret = true;
      }
    }
    return ret;
  }
  
  public Vector getCoordHand() {
    Vector v = null;
    Frame frame = this.controller.frame();
    if (frame.hands().count() >= 1) {
      Hand hand = frame.hands().get(0);
      v = frame.interactionBox().normalizePoint(hand.palmPosition());
      v.setX(smoothNormalize(map(v.getX()), width));
      v.setZ(smoothNormalize(map(v.getZ()), height));
    }
    return v;
  }
  
  public boolean getGesture() {
    Frame frame = this.controller.frame();
    return frame.gestures().count() >= 1;
  }
  
  private float smoothNormalize(float x, float axis){
    return (axis / 2) * (1+x);
  }
  
  private float map(float x) {
   if (x <= 0.5) {
     return -1 + (x * 2);
   } else {
     return (x - 0.5) * 2;
   }
  }
}


Leap leap = new Leap();
LinkedList<Vector> ell = new LinkedList<Vector>();

void setup(){
  fullScreen();
  frameRate(45);
}

void draw(){
  background(0);
  boolean poing = leap.actionPoing();
  Vector v = leap.getCoordHand();
  if (v != null) {
    ell.add(v);
  }

  if (poing) {
    ell.clear();
  }
  
  for(Vector e : ell) {
    ellipse(e.getX(), e.getZ(), 10, 10);
  }
}
