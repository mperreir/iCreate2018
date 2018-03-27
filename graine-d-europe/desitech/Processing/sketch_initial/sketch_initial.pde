final int[] red = {255, 0, 0};
final int[] green = {0, 255, 0};
final int[] blue = {0, 0, 255};
final int nbCircle = 50;
final int nbCircleFull = 5;
final int border = 200;

int x = 0;
int y = 0;

Circle[] listCircles = new Circle[nbCircle];
Circle[] listCirclesFull = new Circle[nbCircleFull];

void setup() {
  fullScreen();
  frameRate(60);
  for (int i = 0; i < nbCircle; i++) {
    listCircles[i] = new Circle(width, height, 100, 5, 5, red, false);
  }
  
  for (int i = 0; i < nbCircleFull; i++) {
    listCirclesFull[i] = new Circle(width, height, 100, 5, 5, red, true);
  }
}

void draw() {
  background(0);
  
  for (Circle c : listCircles) {
    c.update();
  }
  
  for (Circle c : listCirclesFull) {
    c.update();
  }
}

class Circle { 
  float xpos, ypos, size, speedx, speedy, radius;
  int[] rgb;
  String col;
  boolean full;
  
  Circle (float x, float y, float si, float spx, float spy, int[] rgb, boolean full) {  
    this.xpos = (float) (Math.random() * (x));
    this.ypos = (float) (Math.random() * ((y - border) - border)) + border;
    this.size = (float) (Math.random() * (150 - 20)) + 20;
    this.radius = this.size / 2;
    this.speedx = (float) (Math.random() * (3 + 3)) - 3;
    this.speedy = (float) (Math.random() * (3 + 3)) - 3;
    this.rgb = new int[3];
    this.rgb[0] = (int) (Math.random() * (255));
    this.rgb[1] = (int) (Math.random() * (255));
    this.rgb[2] = (int) (Math.random() * (255));
    this.full = full;
  } 
  
  void update() { 
    this.xpos = (this.xpos + this.speedx) % width;
    if (this.xpos < 0) {
      this.xpos = width;
    }
    this.ypos = (this.ypos + this.speedy) % (height - border);
    if (this.ypos < border) {
      this.ypos = height - border;
    }
    if (this.full) {
      fill(this.rgb[0], this.rgb[1], this.rgb[2], 255);
    } else {
      fill(0, 0, 0, 0);
    }
    stroke(this.rgb[0], this.rgb[1], this.rgb[2]);
    strokeWeight(2);
    ellipse(this.xpos, this.ypos, this.size, this.size);
  } 
} 
