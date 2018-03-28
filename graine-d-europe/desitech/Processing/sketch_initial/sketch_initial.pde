final int[] red = {255, 0, 0};
final int[] green = {0, 255, 0};
final int[] blue = {0, 0, 255};
final int nbCircle = 40;
final int nbCircleFull = 5;
final int border = 200;

int x = 0;
int y = 0;
// The coef of progression about of much the speed is accelerating (linear)
float speedProgressionCoef = 0.2;
// The speed coef that we want to reach
float speedCoef = 50;
// The current speed coef
float currentSpeedCoef = 1;
// Check if we have reached the speedCoef based on our currentSpeedCoef
boolean reach = false;
// Check if the speedCoef is higher or not that our current speed (in others words, check if we are accelerating or deccelelerating)
boolean higher = true;

float sizeProgressionCoef = 3;
float sizeExpansionCoef = 200;
float sizeCurrentCoef = 1;

boolean reachSize = false;

//Test var for accelerating/deccelerating every x frames
boolean enableTest = true;
int tmpTestTime = 300;
int tmpTestCurrent = 0;
int tmpTestTimeStop = 600;

//Test var for accelerating/deccelerating every x frames
boolean enableTestSize = false;
int tmpTestTimeSize = 50;
int tmpTestCurrentSize = 0;
int tmpTestTimeSizeStop = 100;

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
  tmpTestCurrentSize++;
  
  if (enableTest) {
    if (tmpTestCurrent > tmpTestTime && tmpTestCurrent < (tmpTestTime + 300)) {
      handMovements(true);
      reach = false;
    } else {
      handMovements(false);
      reach = false;
    }
  }
  
  if (enableTestSize) {
    if (tmpTestCurrentSize == tmpTestTimeSize) {
      circleHover(1);
      reachSize = false;
    } else if (tmpTestCurrentSize == tmpTestTimeSizeStop) {
      noHover();
      reachSize = false;
    }
  } else {
    reachSize = true;
  }
  
  checkSpeed();
  checkSize();
  
  drawCircles();
}

class Circle { 
  float xpos, ypos, baseSize, size, baseSpeedx, baseSpeedy, speedx, speedy, radius;
  int[] rgb;
  String col;
  boolean full;
  boolean hover;
  
  Circle (boolean full) {  
    this.xpos = (float) (Math.random() * (width));
    this.ypos = (float) (Math.random() * ((height - border) - border)) + border;
    this.baseSize = full ? (float) (Math.random() * (200 - 100)) + 100 : (float) (Math.random() * (100 - 50)) + 50;
    this.size = baseSize;
    this.radius = this.size / 2;
    
    this.speedx = (float) (Math.random() * 3) + 1;
    this.speedx *= Math.floor(Math.random()*2) == 1 ? 1 : -1;
    this.baseSpeedx = this.speedx;
    
    this.speedy = (float) (Math.random() * 2) + 1;
    this.speedy *= Math.floor(Math.random()*2) == 1 ? 1 : -1;
    this.baseSpeedy = this.speedy;
    
    this.rgb = new int[3];
    this.rgb[0] = (int) (Math.random() * (255));
    this.rgb[1] = (int) (Math.random() * (255));
    this.rgb[2] = (int) (Math.random() * (255));
    this.full = full;
    this.hover = false;
  } 
  
  void update(boolean higher) {
    // Change the speed of the circle based on the coef
    // We need to check if the speed is negative or positive
    if (!reach) {
      if (higher) {
        this.speedx = this.speedx >= 0 ? this.speedx + (speedProgressionCoef) : this.speedx - (speedProgressionCoef);
      } else {
        this.speedx = this.speedx >= 0 ? this.speedx - (speedProgressionCoef) : this.speedx + (speedProgressionCoef);
      }
    }
    
    if (!reachSize) {
      if (this.full && this.hover) {
        if ((sizeCurrentCoef - sizeExpansionCoef) < -sizeProgressionCoef) {
          this.size += sizeProgressionCoef;
          this.speedx = 0;
          this.speedy = 0;
        }
      } else if (this.size > this.baseSize) {
        this.size -= sizeProgressionCoef;
        if (this.speedx == 0) {
          this.speedx = this.baseSpeedx;
          this.speedy = this.baseSpeedy;
        }
      }
    }
    
    this.xpos = (this.xpos + this.speedx) % width;
    if (this.xpos < 0) {
      this.xpos = width;
    }
    
    // If the circle reaches a top or bottom border, we make it bounce
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
  speedCoef = newCoef;
}

// Check the current speed to the speed coefficient
void checkSpeed() {
  if (!reach) {
    if ((currentSpeedCoef - speedCoef) < -speedProgressionCoef) {
      currentSpeedCoef += speedProgressionCoef;
      higher = true;
    } else if ((currentSpeedCoef - speedCoef) > speedProgressionCoef) {
      currentSpeedCoef -= speedProgressionCoef;
      higher = false;
    } else {
      reach = true;
    }
  }
}

// Check the current speed to the speed coefficient
void checkSize() {
  if (!reachSize) {
    if ((sizeCurrentCoef - sizeExpansionCoef) < -sizeProgressionCoef) {
      sizeCurrentCoef += sizeProgressionCoef;
    } else if ((sizeCurrentCoef - sizeExpansionCoef) > sizeProgressionCoef) {
      sizeCurrentCoef -= sizeProgressionCoef;
    } else {
      reachSize = true;
    }
  }
}

// Draw the circles at each update
void drawCircles() {
  for (Circle c : listCircles) {
    c.update(higher);
  }
  
  for (Circle c : listCirclesFull) {
    c.update(higher);
  }
}

// Check if hand movements are begin detected
void handMovements(boolean detected) {
  if (detected) {
    setSpeedCoef(30);
  } else {
    setSpeedCoef(1);  
  }
}

void noHover() {
  for (Circle c : listCirclesFull) {
    c.hover = false;
  }
}

void circleHover(int index) {
  listCirclesFull[index].hover = true;
}
