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
  
  void update() {
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
         listCirclesFull[indexCircle].mainCircle = false;
         noHover();
       }
      
      fill(rgb[0], rgb[1], rgb[2], 255);
      ellipse(xpos, ypos, size, size);
      noFill();
      
    }
    
  } 
}

void mcClosing() {
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
  
  void update() {
    //calcul the radiant for the size of the arc
    float percent = ((float) actualTime / (float) totalTime) * 100;
    float degree = percent * 3.6;
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
