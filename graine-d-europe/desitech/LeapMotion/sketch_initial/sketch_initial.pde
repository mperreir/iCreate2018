final int height = 1080;
final int width = 1920;
int x = 0;
int y = 0;
void setup(){
  size(1920, 1080);
  frameRate(60);
}

  Circle c1 = new Circle(0, 0, 100, 5, 1, "red");
  Circle c2 = new Circle(50, 100, 50, 2, 3, "red");
  Circle c3 = new Circle(200, 100, 125, 3, 4, "red");
  
  GrosseBulle gb = new GrosseBulle();

void draw(){
  background(0);
  
  c1.update();
  c2.update();
  c3.update();
  
  gb.update();
  
}

class Circle { 
  float xpos, ypos, size, speedx, speedy;
  String col;
  Circle (float x, float y, float si, float spx, float spy, String c) {  
    xpos = x;
    ypos = y; 
    size = si;
    speedx = spx;
    speedy = spy;
    col = c;
  } 
  void update() { 
    xpos = (xpos + speedx) % width;
    ypos = (ypos + speedy) % height; 
    
    fill(255, 255, 255, 255);
    ellipse(xpos, ypos, size, size);
    noFill();  
} 
} 

class GrosseBulle {
  int time;
  boolean isGrowing;
  float size;
  Timer timer;
  int[] rgb;
  
  GrosseBulle () {
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
