final int[] red = {255, 0, 0};
final int[] green = {0, 255, 0};
final int[] blue = {0, 0, 255};
final int nbCircle = 40;
final int nbCircleFull = 5;
final int border = 200;

int x = 0;
int y = 0;
// The coef of progression about of much the speed is accelerating (linear)
float speedProgressionCoef = 1;
// The speed coef that we want to reach
float speedCoef = 50;
// The current speed coef
float currentSpeedCoef = speedCoef;
// Check if we have reached the speedCoef based on our currentSpeedCoef
boolean reach = true;
// Check if the speedCoef is higher or not that our current speed (in others words, check if we are accelerating or deccelelerating)
boolean higher = true;

float sizeProgressionCoef_f = 3;
float sizeExpansionCoef_f = 200;
float sizeCurrentCoef_f = 1;

//Test var for accelerating/deccelerating every x frames
boolean enableTest = false;
int tmpTestTime = 100;
int tmpTestCurrent = 0;
int tmpTestTimeStop = 300;

//Test var for accelerating/deccelerating every x frames
boolean enableTestSize = true;
int tmpTestTimeSize = 50;
int tmpTestCurrentSize = 0;
int tmpTestTimeSizeStop = 100;

Circle[] listCircles = new Circle[nbCircle];
Circle[] listCirclesFull = new Circle[nbCircleFull];

void setup() {
  fullScreen();
  frameRate(30);
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
  
  boolean toReplaceByLeap = false;

  detectionHand(toReplaceByLeap);
  
  int xToReplace = 500;
  int yToReplace = 500;
  
  int detectedHover = checkIfHover(xToReplace, yToReplace);
  if (detectedHover != -1) {
    detectionHover(detectedHover);
  }

  checkSpeed();
  
  drawCircles();
}

class Circle {
  float xpos, ypos, baseSize, size, baseSpeedx, baseSpeedy, speedx, speedy, radius, sizeCurrentCoef, sizeExpansionCoef, sizeProgressionCoef;
  int[] rgb;
  String col;
  boolean full, hover, hoverReached, reachSize;

  Circle (boolean full) {  
    this.xpos = (float) (Math.random() * (width));
    this.ypos = (float) (Math.random() * ((height - border) - border)) + border;
    this.baseSize = full ? (float) (Math.random() * (175 - 150)) + 150 : (float) (Math.random() * (90 - 50)) + 50;
    this.size = baseSize;
    this.radius = this.size / 2;
    
    this.baseSpeedx = (float) (Math.random() * 3) + 1;
    this.baseSpeedx *= Math.floor(Math.random()*2) == 1 ? 1 : -1;
    this.speedx = this.baseSpeedx >= 0 ? this.baseSpeedx + (speedProgressionCoef * (speedCoef / speedProgressionCoef)) : this.baseSpeedx - (speedProgressionCoef * (speedCoef / speedProgressionCoef));
    
    this.baseSpeedy = (float) (Math.random() * 2) + 1;
    this.baseSpeedy *= Math.floor(Math.random()*2) == 1 ? 1 : -1;
    this.speedy = this.baseSpeedy;
    
    this.rgb = new int[3];
    this.rgb[0] = (int) (Math.random() * (255));
    this.rgb[1] = (int) (Math.random() * (255));
    this.rgb[2] = (int) (Math.random() * (255));
    this.full = full;
    this.hover = false;
    this.hoverReached = true;
    this.reachSize = true;
    
    this.sizeCurrentCoef = sizeCurrentCoef_f;
    this.sizeExpansionCoef = sizeExpansionCoef_f;
    this.sizeProgressionCoef = sizeProgressionCoef_f;
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
    
    if (!this.reachSize) {
      if ((this.sizeCurrentCoef - this.sizeExpansionCoef) < -this.sizeProgressionCoef) {
        this.sizeCurrentCoef += this.sizeProgressionCoef;
      } else if ((this.sizeCurrentCoef - this.sizeExpansionCoef) > this.sizeProgressionCoef) {
        this.sizeCurrentCoef -= this.sizeProgressionCoef;
      } else {
        this.reachSize = true;
      }
    }

    if (!hoverReached) {
      if (this.full && this.hover) {
        if ((sizeCurrentCoef - sizeExpansionCoef) < -sizeProgressionCoef) {
          this.size += sizeProgressionCoef;
          this.speedx = 0;
          this.speedy = 0;
        }
      } else if (this.size > this.baseSize) {
        this.size -= sizeProgressionCoef;
        if (this.speedx == 0) {
          this.speedx = this.baseSpeedx >= 0 ? this.baseSpeedx + (speedProgressionCoef * (speedCoef / speedProgressionCoef)) : this.baseSpeedx - (speedProgressionCoef * (speedCoef / speedProgressionCoef));
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
    setSpeedCoef(1);
  } else {
    setSpeedCoef(50);
  }
}

void noHover() {
  for (Circle c : listCirclesFull) {
    c.hover = false;
  }
}

void circleHover(int index) {
  listCirclesFull[index].hover = true;
  listCirclesFull[index].hoverReached = false;
}

int checkIfHover(int x_coord, int y_coord) {
  for (int i = 0; i < listCirclesFull.length; i++) {
    if ((listCirclesFull[i].xpos + listCirclesFull[i].radius) > Math.abs(x_coord - listCirclesFull[i].radius) && 
        (listCirclesFull[i].ypos + listCirclesFull[i].radius) > Math.abs(y_coord - listCirclesFull[i].radius)) {
      return i;
    }
  }
  return -1;
}

void detectionHand(boolean detected) {
  if (enableTest) {
    if (tmpTestCurrent > tmpTestTime && tmpTestCurrent < (tmpTestTime + 300)) {
      handMovements(true);
      reach = false;
    } else {
      handMovements(false);
      reach = false;
    }
  } else {
    if (detected) {
      handMovements(true);
      reach = false;
    } else {
      handMovements(false);
      reach = false;
    }
  }
}

void detectionHover(int index) {
  if (enableTestSize) {
    if (tmpTestCurrentSize == tmpTestTimeSize) {
      circleHover(1);
    } else if (tmpTestCurrentSize == tmpTestTimeSizeStop) {
      noHover();
    }
  } else {
    if (index != -1) {
      circleHover(index);
    } else {
      noHover();
    }
  }
}

class MainCircle {
  int time;
  boolean isGrowing;
  float size;
  Timer timer;
  int[] rgb;

  MainCircle () {
    this.isGrowing = true;
    this.time = 300;
    this.size = 10;
    this.rgb = new int[3];
    this.rgb[0] = 255;
    this.rgb[1] = 0;
    this.rgb[2] = 0;
    timer = new Timer(time, rgb);
  }

  void update() {
    if (isGrowing) {
      size += 2;
      if (size >= 200) {
        isGrowing = false;
      }
      fill(255, 255, 255, 255);
      ellipse(width/2, height/2, size, size);
      noFill();

    } else {
      fill(255, 255, 255, 255);
      ellipse(width/2, height/2, size, size);
      noFill();

      if (time > 0 ) {
        time--;
        timer.update();
      }
    }

  }
}

// The timer around the center circle
// update : make it decrease automatically
class Timer {
  int totalTime;
  int actualTime;
  int[] rgb;

  Timer (int t, int[] rgb) {
    this.totalTime = t;
    this.actualTime = t;
    this.rgb = rgb;
  }

  void update() {
    //calcul the radiant for the size of the arc
    float percent = ((float) actualTime / (float) totalTime) * 100;
    float degree = percent * 3.6;
    double radiant = degree * Math.PI/180;

    noFill();
    stroke(this.rgb[0], this.rgb[1], this.rgb[2]);
    strokeWeight(20);
    // "-HALF_PI" make it begin at the top of the circle (without it, it would start at the right of the circle)
    arc(width/2, height/2, 195, 195, -HALF_PI, (float) radiant - HALF_PI);
    noStroke();
    System.out.println("radiant : " + (float) radiant);

    actualTime--;
 }
}
