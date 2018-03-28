import com.leapmotion.leap.*;
import java.util.LinkedList;

Leap leap = new Leap();
LinkedList<Vector> ell = new LinkedList<Vector>();

void setup(){
  fullScreen();
  frameRate(45);
}

int time = 0;

void draw(){
  background(44, 10, 104);
  boolean poing = leap.actionPoing();
  Vector v = leap.getCoordHand();
  if (v != null) {
    ell.add(v);

  }
  
  if(ell.size() >= 30 || (time % 3 == 0 && ell.size() > 0)){
    ell.remove(0);
  }
  
  if (leap.isSwipingDown()) {
    ellipse(100,100,100,100); 
  }
  
  float i = 0;
  noStroke();
  for(Vector e : ell) { 

    fill(181, 198, 229, 255 * (i / ell.size()));
    ellipse(e.getX(), e.getZ(), 10, 10);
    i += 1;
  }
  time += 1;
  time %= 45;
}
