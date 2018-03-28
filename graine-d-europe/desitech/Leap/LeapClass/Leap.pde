
public class Leap {
  
  private Controller controller;
  public Leap() {
    this.controller = new Controller();
    controller.enableGesture(Gesture.Type.TYPE_SWIPE);
  }
  
  /* 
    Return the number of hands detected by the Leap 
  */
  
  public int countHands() {
   Frame frame = this.controller.frame();
   return frame.hands().count();
  }
  
  /*
    Return true if the fist is close, false otherwise
  */
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
  
  /*
    Return the coordinates of the hand in pixel (normalized on the width and height of the window)
  */
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
  
  /*
    Return the entropy based on the speed of the hands in front of the leap
  */
  public float getEntropy() {
    return this.estimateEntropy();
  }
  
  /*
   Return wheter or not a swipe gesture directed down is currently performed
   */
  public boolean isSwipingDown() {
   boolean ret = false;
   Frame frame = this.controller.frame();
   if (frame.gestures().count() > 0) {
     for (Gesture g : frame.gestures()) {
       if (g.type() == Gesture.Type.TYPE_SWIPE) {
         SwipeGesture swipe = new SwipeGesture(g);
         System.out.println(swipe.speed());
         if (swipe.direction().getY() < 0 && swipe.speed() >= 150) {
            ret = true;
            break;
         }
       }
     }
   }
   return ret;
  }
   
  private float estimateEntropy() {
    Frame frame = this.controller.frame();
    Hand hand = frame.hands().get(0);
    Vector velocity = hand.palmVelocity();    
    return (float) (Math.pow(velocity.getX(), 2) + Math.pow(velocity.getY(), 2) + Math.pow(velocity.getZ(), 2)) / 1000;
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
