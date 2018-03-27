final int[] red = {255, 0, 0};
final int[] green = {0, 255, 0};
final int[] blue = {0, 0, 255};
final int nbCircle = 40;
final int nbCircleFull = 5;
final int border = 200;
final 

int x = 0;
int y = 0;
float speedProgressionCoef = 0.2;
float speedCoef = 50;
float currentSpeedCoef = 1;
boolean reach = false;
boolean coefOn = true;
boolean higher = true;

int tmpTestTime = 200;
int tmpTestCurrent = 0;

Circle[] listCircles = new Circle[nbCircle];
Circle[] listCirclesFull = new Circle[nbCircleFull];

void setup() {
  fullScreen();
  frameRate(60);
  for (int i = 0; i < nbCircle; i++) {
    listCircles[i] = new Circle(false);
  }
  
  for (int i = 0; i < nbCircleFull; i++) {
    listCirclesFull[i] = new Circle(true);
  }
}

void draw() {
  background(0, 35, 70);
  
  tmpTestCurrent++;
  
  if (tmpTestCurrent == tmpTestTime) {
    if (speedCoef == 1) {
      setSpeedCoef(30);
    } else {
      setSpeedCoef(1);
    }
    reach = false;
    tmpTestCurrent = 0;
    
  }
  
  if (!reach) {
    if ((currentSpeedCoef - speedCoef) < -0.1) {
      currentSpeedCoef += speedProgressionCoef;
      coefOn = true;
      higher = true;
    } else if ((currentSpeedCoef - speedCoef) > 0.1) {
      currentSpeedCoef -= speedProgressionCoef;
      coefOn = true;
      higher = false;
    } else {
      coefOn = false;
      currentSpeedCoef = 1;
      reach = true;
    }
  }
  System.out.println("TestCurrent : " + tmpTestCurrent + "; currentSpeedCoef : " + currentSpeedCoef);
  
  for (Circle c : listCircles) {
    c.update(coefOn, higher);
  }
  
  for (Circle c : listCirclesFull) {
    c.update(coefOn, higher);
  }
}

class Circle { 
  float xpos, ypos, size, speedx, speedy, radius;
  int[] rgb;
  String col;
  boolean full;
  
  Circle (boolean full) {  
    this.xpos = (float) (Math.random() * (width));
    this.ypos = (float) (Math.random() * ((height - border) - border)) + border;
    this.size = (float) (Math.random() * (150 - 20)) + 20;
    this.radius = this.size / 2;
    
    this.speedx = (float) (Math.random() * 3) + 1;
    this.speedx *= Math.floor(Math.random()*2) == 1 ? 1 : -1;
    
    this.speedy = (float) (Math.random() * 2) + 1;
    this.speedy *= Math.floor(Math.random()*2) == 1 ? 1 : -1;
    
    this.rgb = new int[3];
    this.rgb[0] = (int) (Math.random() * (255));
    this.rgb[1] = (int) (Math.random() * (255));
    this.rgb[2] = (int) (Math.random() * (255));
    this.full = full;
  } 
  
  void update(boolean coef, boolean higher) {
    if (coef) {
      if (higher) {
        this.speedx = this.speedx >= 0 ? this.speedx + (speedProgressionCoef) : this.speedx - (speedProgressionCoef);
      } else {
        this.speedx = this.speedx >= 0 ? this.speedx - (speedProgressionCoef) : this.speedx + (speedProgressionCoef);
      }
    }
    
    this.xpos = (this.xpos + this.speedx) % width;
    if (this.xpos < 0) {
      this.xpos = width;
    }
    
    if (((this.ypos + this.speedy) > (height - border)) || ((this.ypos + this.speedy) < border)) {
      this.speedy = -this.speedy;
    }
    this.ypos = (this.ypos + this.speedy) % (height - border);
    if (this.ypos < 100) {
      this.ypos = height - border;
    }
    
    if (this.full) {
      fill(this.rgb[0], this.rgb[1], this.rgb[2], 255);
      noStroke();
    } else {
      fill(0, 0, 0, 0);
      stroke(this.rgb[0], this.rgb[1], this.rgb[2]);
      strokeWeight(4);
    }

    ellipse(this.xpos, this.ypos, this.size, this.size);
  } 
} 

void setSpeedCoef(int newCoef) {
  currentSpeedCoef = speedCoef;
  speedCoef = newCoef;
}
