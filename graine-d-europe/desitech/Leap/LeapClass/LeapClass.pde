import java.util.LinkedList;

/**
* First function that is called at the beginning
*/
void setup() {
  fullScreen();
  frameRate(30);
  font = getFont();
  audio = new AudioFiles();
  initCircles();
}


/**
* Initialize anything related to circles
* Used at launch or when a theme is changed
*/
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
  
  if (vrac) {
    audio.play.stop();
  }
  vrac = true;
  coefAmp = 0;
  coefAmpReach = false;
  coefAmpHigher = true;
  audio.playing = false;
  audio.playVrac(this);
  
  for (int i = 0; i < nbCircle; i++) {
    listCircles[i] = new Circle(false, null);
  }

  for (int i = 0; i < nbCircleFull; i++) {
    listCirclesFull[i] = new Circle(true, audio.getMusicAtCatByIndex(theme, i));
  }
  
}

/**
* This function is executed at every frame
*/
void draw() {
  background(15, 24, 34);
  
  Vector v = leap.getCoordHand();
  
  circleActions(v);
  
  vectorActions(v);
}

/*
* Contains everything related to the circles for the drawing generation
* @param v The vector containing the coordinates of the hand
*/
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
  
  
  if (!g_hover && !swipe) {
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
              if (detectedHover == -1 && savedIndexCircleFull != -1) {
                timerReachSize += 1;
                if (timerReachSize >= waitReachSize) {
                  savedIndexCircleFull = -1;
                  timerReachSize = 0;
                }
                detectionHover(savedIndexCircleFull);
              } else {
                if (detectedHover != -1 && listCirclesFull[detectedHover].reachSize == true) {
                  savedIndexCircleFull = detectedHover;
                }
                detectionHover(detectedHover);
             }
            }
          } else {
              if (waitExplosion <= timerExplosion) {
                initCircles();
              }
            }
          }
        }
    }
  } else if (!swipe) {
    detectionHand(true);
    checkSwipeDown();
  } else if (swipe) {
    detectionHand(true);
    timerSwipe++;
    if (timerSwipe >= waitSwipe) {
      swipe = false;
    }
  }
  
  checkSpeed();
  
  drawCircles();
  
  audio.changeAmp();
  
  if (mc != null) {
    mc.update();
  }
  
  checkSwipeDown();
}

/*
* Contains everything related to the leap motion for the drawing generation
* @param v The vector containing the coordinates of the hand
*/
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

/**
* Change the speed of the coefficient for the circles max speed
*/
void setSpeedCoef(int newCoef) {
  speedCoef = newCoef;
}

/**
* Check the current speed to the speed coefficient
*/
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

/**
* Update the circles at every frame (change speed for example)
*/
void drawCircles() {
    for (Circle c : listCircles) {
    c.update();
  }

  for (Circle c : listCirclesFull) {
    c.update();
  }
}
