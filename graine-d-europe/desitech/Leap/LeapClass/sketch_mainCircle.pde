class MainCircle {
  int indexCircle;
  
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
  
  MainCircle (float x, float y, int[] rgb, float size, int indexCircle, float time) {
    this.indexCircle = indexCircle;
    
    this.xpos = x;
    this.ypos = y;
    this.rgb = rgb;
    this.size = size;
    this.sizeClosed = size;

    this.isGrowing = true;
    this.time = time;
    timer = new Timer(time, rgb);
    
    
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
      if (size >= 500) {
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
      noFill();
      
      if (time > 0 ) {
        time--;
        timer.update();
      } else {
        isPlaying = false;
        isClosing = true;
        
        mcClosing();
      }
    } else if (isClosing) {
       audioStarted = false;
       g_hover = false;
       listCirclesFull[indexCircle].mainCircle = false;
       xpos += finalSpeedX;
       ypos += finalSpeedY;
       size -= speedMinimize;
       nbFrames--;  
      
      if(nbFrames == 0) {
         mc = null;
         //TODO : relaunch other circle
       }
      
      fill(rgb[0], rgb[1], rgb[2], 255);
      ellipse(width/2, height/2, size, size);
      noFill();
      
    }
    
  } 
}

void mcClosing() {
  Circle dest = listCirclesFull[mc.indexCircle];
  float destX = dest.xpos;
  float destY = dest.ypos;
  
  // spped of closing
  mc.nbFrames = 50;
    
  mc.finalSpeedX = abs(width/2 - destX) / mc.nbFrames;
  if (width/2 - destX < 0) {
      mc.finalSpeedX *= -1;
    }
  mc.finalSpeedY = abs(height/2 - destY) / mc.nbFrames;
  if (height/2 - destY < 0) {
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
  
  Timer (float t, int[] rgb) {
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
    strokeWeight(20);
    // "-HALF_PI" make it begin at the top of the circle (without it, it would start at the right of the circle)
    arc(width/2, height/2, 495, 495, -HALF_PI, (float) radiant - HALF_PI);  
    noStroke();
    
    actualTime--;
 } 
}
