import java.util.LinkedList;

void setup() {
  fullScreen();
  frameRate(30);
  font = getFont();
  audio = new AudioFiles();
  initCircles();
}

void initCircles() {
  theme = getTheme();
  nbCircleFull = audio.getNbMusicsForCat(theme);
  listCirclesFull = null;
  listCircles = new Circle[nbCircle];
  listCirclesFull = new Circle[nbCircleFull];

  write = true;
  timerText = 0;
  fading_higher = true;
  explosion = false; 
  speedProgressionCoef = 1;
  speedCoef = 50;
  currentSpeedCoef = speedCoef;
  timerExplosion = 0;
  timerAppear = 0;
  
  for (int i = 0; i < nbCircle; i++) {
    listCircles[i] = new Circle(false, null);
  }

  for (int i = 0; i < nbCircleFull; i++) {
    listCirclesFull[i] = new Circle(true, audio.getMusicAtCatByIndex(theme, i));
  }
  
}

void draw() {
  background(15, 24, 34);
  
  Vector v = leap.getCoordHand();
  
  circleActions(v);
  
  vectorActions(v);
}

void circleActions(Vector v) {
  timerAppear++;
  if (write) {
    writeText(theme);
    timerText++;
    if (timerText > waitText) {
      write = false;
    }
  }
  
  if (explosion) {
    timerExplosion++;
  }

  tmpTestCurrent++;
  tmpTestCurrentSize++;
  
  if (!g_hover) {
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
  } else {
    detectionHand(true);
  }
  checkSpeed();
  
  drawCircles();
  
  if (mc != null) {
    mc.update();
  }
}

void vectorActions(Vector v) {
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
    c.update();
  }

  for (Circle c : listCirclesFull) {
    c.update();
  }
}
