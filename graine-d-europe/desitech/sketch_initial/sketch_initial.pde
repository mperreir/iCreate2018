final int height = 400;
final int width = 400;
int x = 0;
int y = 0;
void setup(){
  size( 400, 400 );
}

void draw(){
  background(0);
  ellipse(x,y,100,100);
  x = (x + 5) % width;
  y = (y + 5) % height;
  
  Circle c1 = new Circle(0, 0, 100, 5, "red");
  
}

class Circle { 
  float xpos, ypos, size, speed;
  String col;
  Circle (float x, float y, float size, float speed, String col) {  
    xpos = x;
    ypos = y; 
    size = size;
    speed = speed; 
    col = col;
  } 
  void update() { 
    xpos += speed % width;
    ypos += speed % height; 
    ellipse(xpos, ypos, size, size);
  } 
} 
