import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.LinkedList; 
import com.leapmotion.leap.*; 
import processing.sound.*; 
import java.util.Map; 
import java.util.Iterator; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class LeapClass extends PApplet {



/**
* First function that is called at the beginning
*/
public void setup() {
  
  frameRate(30);
  font = getFont();
  audio = new AudioFiles();
  initCircles();
}


/**
* Initialize anything related to circles
* Used at launch or when a theme is changed
*/
public void initCircles() {
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
public void draw() {
  background(15, 24, 34);
  
  Vector v = leap.getCoordHand();
  
  circleActions(v);
  
  vectorActions(v);
}

/*
* Contains everything related to the circles for the drawing generation
* @param v The vector containing the coordinates of the hand
*/
public void circleActions(Vector v) {
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
        if (Math.abs(currentSpeedCoef - 1) < 2.1f) {
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
          }
        }
      } else {
        savedIndexCircleFull = -1;
        timerReachSize = 0;
        if (waitExplosion <= timerExplosion) {
          initCircles();
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
public void vectorActions(Vector v) {
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
public void setSpeedCoef(int newCoef) {
  speedCoef = newCoef;
}

/**
* Check the current speed to the speed coefficient
*/
public void checkSpeed() {
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
public void drawCircles() {
    for (Circle c : listCircles) {
    c.update();
  }

  for (Circle c : listCirclesFull) {
    c.update();
  }
}
/**
* Circle class
*/
class Circle {
  float xpos, ypos, baseSize, size, baseSpeedx, baseSpeedy, speedx, speedy, radius, sizeCurrentCoef, sizeExpansionCoef, sizeProgressionCoef;
  int[] rgb;
  String col, audioName;
  boolean full, hover, hoverReached, reachSize, explosion, mainCircle;

  Circle (boolean full, String audioName) {  
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
    this.mainCircle = false;
    
    this.sizeCurrentCoef = sizeCurrentCoef_f;
    this.sizeExpansionCoef = sizeExpansionCoef_f;
    this.sizeProgressionCoef = sizeProgressionCoef_f;
    
    this.audioName = audioName;
  }

  /**
  * Function that will be called at every frame
  * Change the variables of the circle
  */
  public void update() {
    this.changeSpeed();

    this.hoverEffects();

    // If the circle reaches a top or bottom border, we make it bounce
    if (!mainCircle) {
      if (!this.explosion) {
        this.positionChange();
      } else {
        this.speedx += this.speedx >= 0 ? 1 : -1; 
        this.speedy += this.speedy >= 0 ? 1 : -1; 
        this.xpos = (this.xpos + this.speedx);
        this.ypos = (this.ypos + this.speedy);
      }
      this.representation();
    } else {
      this.invisible();
    }
  }
  
  /**
  * Choose if the circle will be drawn fully or with border only
  */
  private void representation() {
    if (this.full) {
      fill(this.rgb[0], this.rgb[1], this.rgb[2], 255);
      noStroke();
    } else {
      fill(0, 0, 0, 0);
      stroke(this.rgb[0], this.rgb[1], this.rgb[2], 150);
      strokeWeight(4);
    }

    ellipse(this.xpos, this.ypos, this.size, this.size);
  }
  
  /**
  * Change the speed of the circle based on the coef
  * We need to check if the speed is negative or positive
  */
  private void changeSpeed() {
    if (!reach) {
      if (higher) {
        this.speedx = this.speedx >= 0 ? this.speedx + (speedProgressionCoef) : this.speedx - (speedProgressionCoef);
        this.speedy = this.speedy >= 0 ? this.speedy + (speedProgressionCoef/coefSpeedY) : this.speedy - (speedProgressionCoef/coefSpeedY);
      } else {
        this.speedx = this.speedx >= 0 ? this.speedx - (speedProgressionCoef) : this.speedx + (speedProgressionCoef);
        this.speedy = this.speedy >= 0 ? this.speedy - (speedProgressionCoef/coefSpeedY) : this.speedy + (speedProgressionCoef/coefSpeedY);
      }
    }
  }
  
  /**
  * Change the circle based on if the hover is on or not
  */
  private void hoverEffects() {
    if (!reachSize) {
      if (this.full && this.hover) {
        if ((this.sizeCurrentCoef - this.sizeExpansionCoef) < -this.sizeProgressionCoef) {
          this.size += this.sizeProgressionCoef;
          this.radius = this.size / 2;
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
  }
  
  /**
  * Change the position at every frame
  */
  private void positionChange() {
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
  }
  
  /**
  * Set the circle invisible
  */
  private void invisible() {
    if (this.full) {
      fill(this.rgb[0], this.rgb[1], this.rgb[2], 0);
      noStroke();
    }

    ellipse(this.xpos, this.ypos, this.size, this.size);
  }
  
  /**
  * Returns the audio name linked to the circle
  * @return The audio name
  */
  public String getAudioName() {
    return this.audioName;
  }
}
final int[] citoyen1 = {230, 106, 146};
final int[] citoyen2 = {209, 59, 103};
final int[] citoyen3 = {152, 38, 73};
final int[] citoyen4 = {98, 19, 46};

final int[] culture1 = {101, 97, 152};
final int[] culture2 = {80, 65, 145};
final int[] culture3 = {72, 57, 134};
final int[] culture4 = {48, 39, 88};

final int[] deputes1 = {91, 193, 224};
final int[] deputes2 = {59, 170, 216};
final int[] deputes3 = {29, 125, 162};
final int[] deputes4 = {17, 78, 102};

final int[] environnement1 = {143, 196, 118};
final int[] environnement2 = {94, 171, 85};
final int[] environnement3 = {77, 133, 66};
final int[] environnement4 = {54, 98, 52};

final int[] education1 = {235, 141, 77};
final int[] education2 = {233, 124,49};
final int[] education3 = {179, 90, 46};
final int[] education4 = {153, 69, 38};

final int[] histoire1 = {286, 188, 87};
final int[] histoire2 = {238, 176, 52};
final int[] histoire3 = {232, 163, 52};
final int[] histoire4 = {187, 140, 54};
/**
* Check if hand movements are begin detected
* @param detected True if the hand has been detected, false otherwise
*/
public void handMovements(boolean detected) {
  if (detected) {
    setSpeedCoef(1);
  } else {
    setSpeedCoef(50);
  }
}

/**
* Change variables based on if the hand has been just detected or not detected
* @param detected True if the hand has been detected, false otherwise
*/
public void detectionHand(boolean detected) {
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
      if (vrac) {
        coefAmpReach = false;
        coefAmpHigher = false;
        vrac = false;
      }
      handMovements(true);
      reach = false;
    } else {
      handMovements(false);
      reach = false;
      if (!vrac) {
        vrac = true;
        coefAmpHigher = true;
        coefAmpReach = false;
        audio.playVrac(this);
      }
    }
  }
}
/*
* Check if an explosion has been detected
* @param entropy The entropy of the movements of the hand, if it's too high then it will be detected as an explosion
*/
public void detectionExplosion(float entropy) {
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

/**
* Does the effects of an explosion
*/
public void explosion() {
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

public void subExplosition(int[][] corners, Circle c) {
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
// Initialization
AudioFiles audio;
PFont font;
final int nbCircle = 40;
int nbCircleFull;
final int border = 50;
final int sizeTickList = 10;
Circle[] listCircles = new Circle[nbCircle];
Circle[] listCirclesFull;
MainCircle mc = null;
String theme;
Leap leap = new Leap();
LinkedList<Vector> positionList = new LinkedList<Vector>();

// Transitions
final int waitSlow = 180;
final int waitExplosion = 45;
final int waitAppear = 30;
final int waitText = 90;
final int waitSwipe = 50;
final int waitReachSize = 30;
int timerSlow = 0;
int timerExplosion = 0;
int timerAppear = 0;
int timerText = 0;
int timerSwipe = 0;
int timerReachSize = 0;
int savedIndexCircleFull = -1;

// Swipe
final int entropyCoef = 1500;

// Hand detection
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
float coefSpeedY = 4;

// Hover
final float sizeProgressionCoef_f = 5;
final float sizeExpansionCoef_f = 1;
final float sizeCurrentCoef_f = 1;
final float sizeTopCoef_f = 100;
boolean g_hover = false;

// Explosion
boolean explosion = false;

// Text
boolean write = false;
int opacity_text = 0;
boolean fading_higher = true;
int fading_time = 5;

// Swipe
boolean swipe = false;

// Sound Vrac
boolean vrac = false;
float coefAmp = 0;
boolean coefAmpReach = false;
boolean coefAmpHigher = true;
float coefAmpProgression = 0.01f;

// Tests
// Test var for accelerating/deccelerating every x frames
boolean enableTest = false;
int tmpTestTime = 100;
int tmpTestCurrent = 0;
int tmpTestTimeStop = 300;
// Test var for mouse hover
boolean enableTestSize = false;
int tmpTestTimeSize = 50;
int tmpTestCurrentSize = 0;
int tmpTestTimeSizeStop = 100;
// Test var for accelerating/deccelerating every x frames
boolean enableTestExplosion = false;
int tmpTestTimeExplosion = 50;
int tmpTestCurrentExplosion = 0;
int tmpTestTimeExplosionStop = 100;
/**
* Does the "no hover" state for every non hovered circles
*/
public void noHover() {
  for (Circle c : listCirclesFull) {
    c.hover = false;
    c.reachSize = false;
    c.sizeExpansionCoef = 1;
  }
}

public void detectionHover(int index) {
  if (enableTestSize) {
    if (tmpTestCurrentSize == tmpTestTimeSize) {
      circleHover(1);
    } else if (tmpTestCurrentSize == tmpTestTimeSizeStop) {
      noHover();
    }
  } else {
    if (index != -1) {
      circleHover(index);
      //check if the user select the circle
      if (leap.actionPoing()) {
        g_hover = true;
        Circle c = listCirclesFull[index];
        c.mainCircle = true;
        mc = new MainCircle(c.xpos, c.ypos, c.rgb, c.size, index, audio.getDuration(this, theme, c.getAudioName())*30 + 30, c.getAudioName());
        
      }
    } else {
      noHover();
    }
  }
}

/**
* Does the effects when a circle is being hovered
* @param index The index of the circle which is being hovered
*/
public void circleHover(int index) {
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

/**
* Check if a circle is being hovered or not
* @param x_coord The coordinate x of the hand
* @param y_coord The coordinate y of the hand
* @The index of the detected circle being hovered, -1 if none
*/
public int checkIfHover(int x_coord, int y_coord) {
  for (int i = 0; i < listCirclesFull.length; i++) {
    //(x - center_x)^2 + (y - center_y)^2 < radius^2
    if ((Math.pow(x_coord - listCirclesFull[i].xpos, 2) +  Math.pow(y_coord - listCirclesFull[i].ypos, 2)) < Math.pow(listCirclesFull[i].radius, 2)) {
      return i;
    }
  }
  return -1;
}

/**
* Does the effect when you swipe down
*/
public void checkSwipeDown() {
  if (mc != null && mc.isPlaying && leap.isSwipingDown()) {
    mcClosing();
    swipe = true;
  }
}

public class Leap {
  
  private Controller controller;
  public Leap() {
    this.controller = new Controller();
    controller.enableGesture(Gesture.Type.TYPE_SWIPE);
  }
  
  /* 
    Return the number of hands detected by the Leap 
  */
  
  public int countHands() {
   Frame frame = this.controller.frame();
   return frame.hands().count();
  }
  
  /*
    Return true if the fist is close, false otherwise
  */
  public boolean actionPoing() {
    Frame frameNow = this.controller.frame();
    Frame previousFrame = this.controller.frame(5);
    final float SEUIL = 0.9f;
    final float DIFFSEUIL = 0.3f;
    boolean ret = false;
    if (frameNow.hands().count() == 1 && previousFrame.hands().count() == 1) {
      Hand handNow = frameNow.hands().get(0);
      Hand previousHand = previousFrame.hands().get(0);
      if (handNow.grabStrength() >= SEUIL && handNow.grabStrength() - previousHand.grabStrength() >= DIFFSEUIL) {
        ret = true;
      }
    }
    return ret;
  }
  
  /*
    Return the coordinates of the hand in pixel (normalized on the width and height of the window)
  */
  public Vector getCoordHand() {
    Vector v = null;
    Frame frame = this.controller.frame();
    if (frame.hands().count() >= 1) {
      Hand hand = frame.hands().get(0);
      v = frame.interactionBox().normalizePoint(hand.palmPosition());
      v.setX(smoothNormalize(map(v.getX()), width));
      v.setZ(smoothNormalize(map(v.getZ()), height));
    }
    return v;
  }
  
  /*
    Return the entropy based on the speed of the hands in front of the leap
  */
  public float getEntropy() {
    return this.estimateEntropy();
  }
  
  /*
   Return wheter or not a swipe gesture directed down is currently performed
   */
  public boolean isSwipingDown() {
   boolean ret = false;
   Frame frame = this.controller.frame();
   if (frame.gestures().count() > 0) {
     for (Gesture g : frame.gestures()) {
       if (g.type() == Gesture.Type.TYPE_SWIPE) {
         SwipeGesture swipe = new SwipeGesture(g);
         if (swipe.direction().getY() < 0 && swipe.speed() >= 150) {
            ret = true;
            break;
         }
       }
     }
   }
   return ret;
  }
   
  private float estimateEntropy() {
    int sizeHistory = 5;
    float average = 0;
    for (int i = 0 ; i < sizeHistory ; i++ ) {
      Frame frame = this.controller.frame(i);
      Hand hand = frame.hands().get(0);
      Vector velocity = hand.palmVelocity();   
      average += (float) (Math.pow(velocity.getX(), 2) + Math.pow(velocity.getY(), 2) + Math.pow(velocity.getZ(), 2)) / 1000;
    } 
    return average / sizeHistory;
  }
   
  private float smoothNormalize(float x, float axis){
    return (axis / 2) * (1+x);
  }
  
  private float map(float x) {
   if (x <= 0.5f) {
     return -1 + (x * 2);
   } else {
     return (x - 0.5f) * 2;
   }
  }
}
class MainCircle {
  int indexCircle;
  
  String question;
  
  float xpos, ypos;
  float speedX, speedY;
  //change nbFrames to adapt the speed of the circle (time to go to the middle)
  int nbFrames;
  boolean isCentered = false;
  
  float size;
  boolean isGrowing = false;

  float time;
  Timer timer;
  int[] rgb;
  boolean isPlaying = false;
  
  float speedClosing, speedMinimize;
  float sizeClosed;
  boolean isClosing = false;
  float finalPosX, finalPosY;
  float finalSpeedX, finalSpeedY;
  
  boolean audioStarted = false;
  int moveSpeedCoef = 5;
  
  MainCircle (float x, float y, int[] rgb, float size, int indexCircle, float time, String question) {
    this.indexCircle = indexCircle;
    
    this.xpos = x;
    this.ypos = y;
    this.rgb = rgb;
    this.size = size;
    this.sizeClosed = size;

    this.isGrowing = true;
    this.time = time;
    timer = new Timer(time);
    
    this.question = question;
    
    //Calcul of the speed to center the circle
    //nbFrames = number of frames to go to the middle
    this.nbFrames = 50;
    this.speedX = abs(xpos - width/2) / nbFrames;
    if (xpos - width/2 > 0) {
      this.speedX *= -1;
    }
    this.speedY = abs(ypos - height/2) / nbFrames;
    if (ypos - height/2 > 0) {
      this.speedY *= -1;
    }  
  }
  
  public void update() {
    if (!isCentered) {
       xpos += speedX;
       ypos += speedY;
       nbFrames--;
       size += 3;
       //check if the circle is centerded
       if(nbFrames == 0) {
         xpos = width/2;
         ypos = height/2;
         isCentered = true;
         isGrowing = true;
       }
       
      fill(rgb[0], rgb[1], rgb[2], 255);
      ellipse(xpos, ypos, size, size);
      noFill();
    }
    else if (isGrowing) {
      //change size to adapt the growing speed
      size += 6;
      //change the value of the test to adapt the size of the main circle
      if (size >= 800) {
        isGrowing = false;
        isPlaying = true;
      }
      fill(rgb[0], rgb[1], rgb[2], 255);
      ellipse(width/2, height/2, size, size);
      noFill();
      
    } else if (isPlaying) {
      if (!audioStarted) {
        audio.play();
        audioStarted = true;
      }
      fill(rgb[0], rgb[1], rgb[2], 255);
      ellipse(width/2, height/2, size, size);
      // To add effect to move the circle while audio is playing 
      if (size > 550 || size < 450) {
         moveSpeedCoef = -moveSpeedCoef;
      }
      // size += moveSpeedCoef; activate this
      
      noFill();
      
      writeCentralText(this.question);
      
      if (time > 0 ) {
        time--;
        timer.update();
      } else {
        mcClosing();
      }
    } else if (isClosing) {
       audioStarted = false;
       g_hover = false;
       xpos += finalSpeedX;
       ypos += finalSpeedY;
       size -= speedMinimize;
       nbFrames--;  
      
      if(nbFrames == 0) {
         mc = null;
         if (indexCircle >= 0 && indexCircle < listCirclesFull.length) {
            listCirclesFull[indexCircle].mainCircle = false;
         }
         noHover();
       }
      
      fill(rgb[0], rgb[1], rgb[2], 255);
      ellipse(xpos, ypos, size, size);
      noFill();
      
    }
    
  } 
}

public void mcClosing() {
  audio.play.stop();
  
  mc.isPlaying = false;
  mc.isClosing = true;
  
  Circle dest = listCirclesFull[mc.indexCircle];
  float destX = dest.xpos;
  float destY = dest.ypos;
  
  // spped of closing
  mc.nbFrames = 50;
    
  mc.finalSpeedX = abs(width/2 - destX) / mc.nbFrames;
  if (width/2 - destX > 0) {
      mc.finalSpeedX *= -1;
    }
  mc.finalSpeedY = abs(height/2 - destY) / mc.nbFrames;
  if (height/2 - destY > 0) {
    mc.finalSpeedY *= -1;
  }  
  
  mc.speedMinimize = (mc.size - mc.sizeClosed) / 50;
  
}

// The timer around the center circle
// update : make it decrease automatically
class Timer {
  float totalTime;
  float actualTime;
  int[] rgb;
  
  Timer (float t) {
    this.totalTime = t;
    this.actualTime = t;
    this.rgb = getColorTimer(theme);
  } 
  
  public void update() {
    //calcul the radiant for the size of the arc
    float percent = ((float) actualTime / (float) totalTime) * 100;
    float degree = percent * 3.6f;
    double radiant = degree * Math.PI/180;
    
    noFill();
    stroke(this.rgb[0], this.rgb[1], this.rgb[2]);
    strokeWeight(40);
    strokeCap(SQUARE);
    // "-HALF_PI" make it begin at the top of the circle (without it, it would start at the right of the circle)
    arc(width/2, height/2, 790, 790, 3 * HALF_PI - (float) radiant, 3 * HALF_PI); 
    noStroke();
    
    actualTime--;
 } 
}




/**
* Audio class
*/
class AudioFiles {
  
  boolean playing = false;
  SoundFile play;
  HashMap<String, ArrayList<String>> musics;
  
  AudioFiles() {
    String path = sketchPath();
    
    String[] directoriesNames = listFileNames(path + "/data/");
    
    this.musics = new HashMap<String, ArrayList<String>>();
    
    for (String dname : directoriesNames) {
      if (!dname.equals("DK_Bocadillo.otf") && !dname.equals("vrac.mp3")) {
        this.musics.put(dname, new ArrayList<String>());
        String[] filesNames = listFileNames(path + "/data/" + dname + "/");
        for (String aname : filesNames) {
          aname = aname.split("\\.")[0] += " ?";
          this.musics.get(dname).add(aname);
        }
      }
    }
  }
  
  /**
  * Change the amplitude of the audio (fading ish)
  */
  public void changeAmp() {
    if (!coefAmpReach && coefAmp < 1 && coefAmpHigher) {
      coefAmp += coefAmpProgression;
      this.play.amp(coefAmp);
      if ((coefAmp - 1) > 0.001f) {
        coefAmpReach = true;
        coefAmpHigher = false;
      }
    } else if (!coefAmpReach && coefAmp > 0 && !coefAmpHigher) {
      coefAmp -= coefAmpProgression;
      this.play.amp(coefAmp);
      if ((coefAmp - 0) < 0.001f) {
        coefAmpReach = true;
        coefAmpHigher = true;
        this.play.stop();
        this.playing = false;
      }
    }
  }
  
  /**
  * Plays the brouhaha
  * @param pa The parent applet in order to play sound file
  */
  public void playVrac(PApplet pa) {
    if (!this.playing) {
      this.play = new SoundFile(pa, "vrac.mp3");
      this.play.loop();
      this.playing = true;
    }
  }
  
  /**
  * Play the current selected audio file
  */
  public void play() {
    this.play.play();
  }
  
  /**
  * Get the duration of the audio file
  * @param pa The parent application in order to create a sound file
  * @param theme The current selected theme
  * @param video The video go the the duration
  * @return The duration of the audio file
  */
  public float getDuration(PApplet pa,String theme, String video) {
    video = video.substring(0,video.length() - 2);
    System.out.println(theme + "/" + video + ".mp3");
    this.play = new SoundFile(pa, theme + "/" + video + ".mp3");
    return this.play.duration();
  }
  
  // This function returns all the files in a directory as an array of Strings  
  private String[] listFileNames(String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {
      String names[] = file.list();
      return names;
    } else {
      // If it's not a directory
      return null;
    }
  }
  
  // Recursive function to traverse subdirectories
  public void recurseDir(ArrayList<File> a, String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {
      // If you want to include directories in the list
      a.add(file);  
      File[] subfiles = file.listFiles();
      for (int i = 0; i < subfiles.length; i++) {
        // Call this function on all files in this directory
        recurseDir(a, subfiles[i].getAbsolutePath());
      }
    } else {
      a.add(file);
    }
  }
  
  public int getNbCat() {
    return this.musics.size();
  }
  
  public int getNbMusicsForCat(String cat) {
    return this.musics.get(cat).size();
  }
  
  public String getCatIndex(int index) {
    for (String key : this.musics.keySet()) {
      if (index == 0) {
        return key;
      }
      index--;
    }
    return null;
  }
  
  public String getMusicAtCatByIndex(String cat, int index) {
    return this.musics.get(cat).get(index);
  }
  
}
/**
* Write a text during the transition (the theme)
* @param text The text to write
*/
public void writeText(String text) {
  if (fading_higher && timerText < (waitText / fading_time)) {
    opacity_text += (255 / (waitText / fading_time));
  } else if (!fading_higher && timerText > ((waitText / fading_time)*(fading_time-1))) {
    opacity_text -= (255 / (waitText / fading_time));
  }
  if (opacity_text >= 240) {
    fading_higher = false;
  }
  textFont(font);
  int[] darkest = getBrighestColor();
  fill(darkest[0], darkest[1], darkest[2], opacity_text);
  text(text, width/2, height/2);
  textAlign(CENTER, CENTER);
}

/**
* Create a new font
* @return The new font
*/
public PFont getFont() {
  return createFont("DK_Bocadillo.otf", 150);
}

/**
* Write a text in the main circle
* @param text The text to write
*/
public void writeCentralText(String text) {
  
  int nbChar = text.length();
  
  textFont(createFont("DK_Bocadillo.otf", 3500/nbChar));
  
  int[] rgb = getColorTimer(theme);
  
  fill(rgb[0], rgb[1], rgb[2], 255);
  text(text, width/2 - 350, height/2 - 350, 700, 700);
  textAlign(CENTER, CENTER);
}
public String getTheme() {
  String themeRet = "";
  do {
  int rand = (int) (Math.random() * (audio.getNbCat()));
  
  themeRet = audio.getCatIndex(rand);
  } while (theme == themeRet);
  
  return themeRet;
}

public int[] getBrighestColor() {
  if (theme.equals("Citoyen")) {
    return citoyen1;
  } else if (theme.equals("Culture")) {
    return culture1;
  } else if (theme.equals("Députés")) {
    return deputes1;
  } else if (theme.equals("Environnement")) {
    return environnement1;
  } else if (theme.equals("Éducation")) {
    return education1;
  } else if (theme.equals("Histoire")) {
    return histoire1;
  }
  return new int[3];
}

public int[] getColorRGB(String theme) {
  int rand = (int) (Math.random() * (3));
  int[] rgb = new int[3];
  if (theme.equals("Citoyen")) {
    switch (rand) {
      case 0:
        rgb = citoyen1;
        break;
      case 1:
        rgb = citoyen2;
        break;
      case 2:
        rgb = citoyen3;
        break;
    }
  } else if (theme.equals("Culture")) {
    switch (rand) {
      case 0:
        rgb = culture1;
        break;
      case 1:
        rgb = culture2;
        break;
      case 2:
        rgb = culture3;
        break;
    }
  } else if (theme.equals("Députés")) {
    switch (rand) {
      case 0:
        rgb = deputes1;
        break;
      case 1:
        rgb = deputes1;
        break;
      case 2:
        rgb = deputes1;
        break;
    }
  } else if (theme.equals("Environnement")) {
    switch (rand) {
      case 0:
        rgb = environnement1;
        break;
      case 1:
        rgb = environnement2;
        break;
      case 2:
        rgb = environnement3;
        break;
    }
  } else if (theme.equals("Éducation")) {
    switch (rand) {
      case 0:
        rgb = education1;
        break;
      case 1:
        rgb = education2;
        break;
      case 2:
        rgb = education3;
        break;
    }
  } else if (theme.equals("Histoire")) {
    switch (rand) {
      case 0:
        rgb = histoire1;
        break;
      case 1:
        rgb = histoire2;
        break;
      case 2:
        rgb = histoire3;
        break;
    }
  }

  return rgb;
}

public int[] getColorTimer(String theme) {
    int[] rgb = new int[3];

    if (theme.equals("Citoyen")) {
        rgb = citoyen4;
  } else if (theme.equals("Culture")) {
        rgb = culture4;
  } else if (theme.equals("Députés")) {
        rgb = deputes4;
  } else if (theme.equals("Environnement")) {
        rgb = environnement4;
  } else if (theme.equals("Éducation")) {
        rgb = education4;
  } else if (theme.equals("Histoire")) {
        rgb = histoire4;
  }

  return rgb;

}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--hide-stop", "LeapClass" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
