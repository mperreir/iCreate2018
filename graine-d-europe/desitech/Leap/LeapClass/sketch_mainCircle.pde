class MainCircle {
  float xpos, ypos;
  float speedX, speedY;
  //change nbFrames to adapt the speed of the circle (time to go to the middle)
  int nbFrames;
  boolean isCentered;
  
  float size;
  boolean isGrowing;

  int time;
  Timer timer;
  int[] rgb;
  
  MainCircle (float x, float y, int[] rgb, float size) {
    this.xpos = x;
    this.ypos = y;
    this.rgb = rgb;
    this.size = size;

    this.isGrowing = true;
    this.time = 300;
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
      }
      fill(rgb[0], rgb[1], rgb[2], 255);
      ellipse(width/2, height/2, size, size);
      noFill();
      
    } else {
      fill(rgb[0], rgb[1], rgb[2], 255);
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
    arc(width/2, height/2, 495, 495, -HALF_PI, (float) radiant - HALF_PI);  
    noStroke();
    System.out.println("radiant : " + (float) radiant);
    
    actualTime--;
 } 
}
