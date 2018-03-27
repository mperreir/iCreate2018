final int height = 400;
final int width = 400;
int x = 0;
int y = 0;
void setup(){
  size( 400, 400 );
  frameRate(30);
}

  Circle c1 = new Circle(0, 0, 100, 5, 1, "red");
  Circle c2 = new Circle(50, 100, 50, 2, 3, "red");
  Circle c3 = new Circle(200, 100, 125, 3, 4, "red");

void draw(){
  background(0);
  
  c1.update();
  c2.update();
  c3.update();
  
}

class Circle { 
  float xpos, ypos, size, speedx, speedy;
  String col;
  Circle (float x, float y, float si, float spx, float spy, String c) {  
    xpos = x;
    ypos = y; 
    size = si;
    speedx = spx;
    speedy = spy;
    col = c;
  } 
  void update() { 
    xpos = (xpos + speedx) % width;
    ypos = (ypos + speedy) % height; 
    ellipse(xpos, ypos, size, size);
  } 
} 
