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
}
