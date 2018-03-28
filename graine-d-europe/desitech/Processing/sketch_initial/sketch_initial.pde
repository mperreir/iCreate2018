final int[] red = {255, 0, 0};
final int[] green = {0, 255, 0};
final int[] blue = {0, 0, 255};
final int nbCircle = 40;
final int nbCircleFull = 5;
final int border = 200;
final

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

//Test var for accelerating/deccelerating every x frames
int tmpTestTime = 300;
int tmpTestCurrent = 0;
int tmpTestTimeStop = 50;

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

  if (tmpTestCurrent == tmpTestTime) {
    if (speedCoef == 1) {
      handMovements(true);
    } else {
      handMovements(false);
    }
    reach = false;
    tmpTestCurrent = 0;
  }

  checkSpeed();

  drawCircles();
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
    if ((currentSpeedCoef - speedCoef) < -0.1) {
      currentSpeedCoef += speedProgressionCoef;
      higher = true;
    } else if ((currentSpeedCoef - speedCoef) > 0.1) {
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
    setSpeedCoef(30);
  } else {
    setSpeedCoef(1);
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
