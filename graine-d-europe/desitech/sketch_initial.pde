import com.leapmotion.leap.*;

Controller controller = new Controller();
void setup(){
  size( 500, 500 );
}

void draw(){
  background(0);
  Frame frame = controller.frame();
  System.out.println(frame);
  text( frame.hands().count() + " Hands", 50, 50 );
  text( frame.fingers().extended().count() + " Fingers extended", 50, 100 );
  ellipse(100,100,100,100);
}
