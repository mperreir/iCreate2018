import java.util.LinkedList;
final int[] red = {255, 0, 0};
final int[] green = {0, 255, 0};
final int[] blue = {0, 0, 255};
final int nbCircle = 40;
final int nbCircleFull = 5;
final int border = 50;

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

int entropyCoef = 1500;
int sizeTickList = 10;

boolean explosion = false;

final int waitSlow = 180;
int timerSlow = 0;

final int waitExplosion = 45;
int timerExplosion = 0;

final int waitAppear = 30;
int timerAppear = 0;

float sizeProgressionCoef_f = 5;
float sizeExpansionCoef_f = 1;
float sizeCurrentCoef_f = 1;
float sizeTopCoef_f = 100;
float coefSpeedY = 4;

//Test var for accelerating/deccelerating every x frames
boolean enableTest = false;
int tmpTestTime = 100;
int tmpTestCurrent = 0;
int tmpTestTimeStop = 300;

//Test var for accelerating/deccelerating every x frames
boolean enableTestSize = false;
int tmpTestTimeSize = 50;
int tmpTestCurrentSize = 0;
int tmpTestTimeSizeStop = 100;

//Test var for accelerating/deccelerating every x frames
boolean enableTestExplosion = false;
int tmpTestTimeExplosion = 50;
int tmpTestCurrentExplosion = 0;
int tmpTestTimeExplosionStop = 100;

Circle[] listCircles = new Circle[nbCircle];
Circle[] listCirclesFull = new Circle[nbCircleFull];
MainCircle mc = null;

String theme = getTheme();

Leap leap = new Leap();
LinkedList<Vector> positionList = new LinkedList<Vector>();

void setup() {
  fullScreen();
  frameRate(30);
  initCircles();
}

void initCircles() {
  theme = getTheme();
  listCircles = null;
  listCirclesFull = null;
  listCircles = new Circle[nbCircle];
  listCirclesFull = new Circle[nbCircleFull];

  explosion = false; 
  speedProgressionCoef = 1;
  speedCoef = 50;
  currentSpeedCoef = speedCoef;
  timerExplosion = 0;
  timerAppear = 0;
  
  for (int i = 0; i < nbCircle; i++) {
    listCircles[i] = new Circle(false);
  }

  for (int i = 0; i < nbCircleFull; i++) {
    listCirclesFull[i] = new Circle(true);
  }
}

void draw() {
  background(15, 24, 34);
  
  timerAppear++;
  
  if (explosion) {
    timerExplosion++;
  }

  tmpTestCurrent++;
  tmpTestCurrentSize++;
  
  Vector v = leap.getCoordHand();
  
  if (timerAppear > waitAppear) {
    boolean toReplaceByLeap = leap.countHands() > 0;
    detectionHand(toReplaceByLeap);
    
    if (!explosion) {
      if (Math.abs(currentSpeedCoef - 1) < 2.1) {
        float entropy = leap.getEntropy();
        detectionExplosion(entropy);
        
        if (!explosion) {
          if (v != null) {
              int xToReplace = (int)v.getX();
              int yToReplace = (int)v.getZ();
              int detectedHover = checkIfHover(xToReplace, yToReplace);
              detectionHover(detectedHover);
          }
        }
      }
    } else {
      if (waitExplosion <= timerExplosion) {
        initCircles();
      }
    }
  }
  checkSpeed();
  
  drawCircles();
  
  if (mc != null) {
    mc.update();
  }
  
  if (v != null) {
    positionList.add(v);
  }
  if(positionList.size() >= sizeTickList || (positionList.size() > 0 && tmpTestCurrent % 2 == 0)){
      positionList.remove(0);
  }
  
  float i = 0;
  for(Vector pos : positionList) { 
    noStroke();
    fill(171, 210, 252, 255 * (i / positionList.size()));
    ellipse(pos.getX(), pos.getZ(), 10, 10);
    i += 1;
  }
}

class Circle {
  float xpos, ypos, baseSize, size, baseSpeedx, baseSpeedy, speedx, speedy, radius, sizeCurrentCoef, sizeExpansionCoef, sizeProgressionCoef;
  int[] rgb;
  String col;
  boolean full, hover, hoverReached, reachSize, explosion;

  Circle (boolean full) {  
    this.xpos = Math.floor(Math.random()*2) == 1 ? (float) (Math.random() * (width)) - width : (float) (Math.random() * (width)) + width;
    this.ypos = (float) (Math.random() * ((height - border) - border)) + border;
    this.baseSize = full ? (float) (Math.random() * (175 - 150)) + 150 : (float) (Math.random() * (90 - 50)) + 50;
    this.size = baseSize;
    this.radius = this.size / 2;
    
    this.baseSpeedx = (float) (Math.random() * 3) + 1;
    this.baseSpeedx *= Math.floor(Math.random()*2) == 1 ? 1 : -1;
    this.speedx = this.baseSpeedx >= 0 ? this.baseSpeedx + (speedProgressionCoef * (speedCoef / speedProgressionCoef)) : this.baseSpeedx - (speedProgressionCoef * (speedCoef / speedProgressionCoef));
    
    this.baseSpeedy = (float) (Math.random() * 2) + 1;
    this.baseSpeedy *= Math.floor(Math.random()*2) == 1 ? 1 : -1;
    this.speedy = this.baseSpeedy >= 0 ? this.baseSpeedy + (speedProgressionCoef * ((speedCoef / speedProgressionCoef) / coefSpeedY)) : this.baseSpeedy - (speedProgressionCoef * ((speedCoef / speedProgressionCoef) / coefSpeedY)) ;
    
    this.rgb = getColorRGB(theme);
    this.full = full;
    this.hover = false;
    this.hoverReached = true;
    this.reachSize = true;
    this.explosion = false;
    
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
        this.speedy = this.speedy >= 0 ? this.speedy + (speedProgressionCoef/coefSpeedY) : this.speedy - (speedProgressionCoef/coefSpeedY);
      } else {
        this.speedx = this.speedx >= 0 ? this.speedx - (speedProgressionCoef) : this.speedx + (speedProgressionCoef);
        this.speedy = this.speedy >= 0 ? this.speedy - (speedProgressionCoef/coefSpeedY) : this.speedy + (speedProgressionCoef/coefSpeedY);
      }
    }

    if (!reachSize) {
      if (this.full && this.hover) {
        if ((this.sizeCurrentCoef - this.sizeExpansionCoef) < -this.sizeProgressionCoef) {
          this.size += this.sizeProgressionCoef;
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

    if (!this.reachSize) {
      if ((this.sizeCurrentCoef - this.sizeExpansionCoef) < -this.sizeProgressionCoef) {
        this.sizeCurrentCoef += this.sizeProgressionCoef;
      } else if ((this.sizeCurrentCoef - this.sizeExpansionCoef) > this.sizeProgressionCoef) {
        this.sizeCurrentCoef -= this.sizeProgressionCoef;
      } else {
        this.reachSize = true;
      }
    }


    // If the circle reaches a top or bottom border, we make it bounce
    if (!this.explosion) {
      if (timerAppear < waitAppear) {
        this.xpos = (this.xpos + this.speedx) % (width*2);
        if (this.xpos < (-width)) {
          this.xpos = width;
        }
      } else {
        this.xpos = (this.xpos + this.speedx) % width;
        if (this.xpos < 0) {
          this.xpos = width;
        }
      }
      if (((this.ypos + this.speedy) > (height - border)) || ((this.ypos + this.speedy) < border)) {
        this.speedy = -this.speedy;
      }
      this.ypos = (this.ypos + this.speedy) % (height - border);
      if (this.ypos < border) {
        this.ypos = height - border;
      }
    } else {
      this.speedx += this.speedx >= 0 ? 1 : -1; 
      this.speedy += this.speedy >= 0 ? 1 : -1; 
      this.xpos = (this.xpos + this.speedx);
      this.ypos = (this.ypos + this.speedy);
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

void circleHover(int index) {
  listCirclesFull[index].hover = true;
  listCirclesFull[index].hoverReached = false;
  listCirclesFull[index].reachSize = false;
  listCirclesFull[index].sizeExpansionCoef = sizeTopCoef_f;
  
  for (int i = 0; i < listCirclesFull.length; i++) {
    if (i != index) {
      listCirclesFull[i].hover = false;
      listCirclesFull[i].reachSize = false;
      listCirclesFull[i].sizeExpansionCoef = 1;
    }
  }
}

int checkIfHover(int x_coord, int y_coord) {
  for (int i = 0; i < listCirclesFull.length; i++) {
    //(x - center_x)^2 + (y - center_y)^2 < radius^2
    if ((Math.pow(x_coord - listCirclesFull[i].xpos, 2) +  Math.pow(y_coord - listCirclesFull[i].ypos, 2)) < Math.pow(listCirclesFull[i].radius, 2)) {
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

void noHover() {
  for (Circle c : listCirclesFull) {
    c.hover = false;
    c.reachSize = false;
    c.sizeExpansionCoef = 1;
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
      
      //check if the user selct the circle
      if(leap.actionPoing()) {
        Circle c = listCirclesFull[index];
        mc = new MainCircle(c.xpos, c.ypos, c.rgb, c.size);
      }
    } else {
      noHover();
    }
  }
}

void detectionExplosion(float entropy) {
  if (enableTestExplosion) {
    if (tmpTestCurrentExplosion == tmpTestTimeExplosion) {
      explosion();
    }
  } else {
    if (entropy > entropyCoef && !explosion) {
      explosion();
      explosion = true;
    }
  }
}

void explosion() {
  int[] corner1 = {0, 0};
  int[] corner2 = {height, 0};
  int[] corner3 = {height, width};
  int[] corner4 = {0, width};
  int[][] corners = {corner1, corner2, corner3, corner4};
  for (Circle c : listCircles) {
    subExplosition(corners, c);
  }
  for (Circle c : listCirclesFull) {
    subExplosition(corners, c);
  }
}

void subExplosition(int[][] corners, Circle c) {
  int corner_index = 0;
  double value = Integer.MAX_VALUE;
  for (int i = 0; i < corners.length; i++) {
    double tmpDist = Math.sqrt(Math.pow((corners[i][1] - c.xpos), 2) + Math.pow((corners[i][0] - c.ypos), 2));
    if (value > tmpDist) {
      corner_index = i;
      value = tmpDist;
    }
  }
  
  switch (corner_index) {
      case 0:
        c.speedx = -Math.abs(c.speedx);
        c.speedy = -Math.abs(c.speedy);
        break;
      case 1:
        c.speedx = -Math.abs(c.speedx);
        c.speedy = Math.abs(c.speedy);
        break;
      case 2:
        c.speedx = Math.abs(c.speedx);
        c.speedy = Math.abs(c.speedy);
        break;
      case 3:
        c.speedx = Math.abs(c.speedx);
        c.speedy = -Math.abs(c.speedy);
        break;
    }
    
    c.explosion = true;
}
