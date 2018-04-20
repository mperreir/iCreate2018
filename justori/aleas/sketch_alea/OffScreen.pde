class OffScreen {

  PGraphics offScreen;
  int width;
  int height;
  boolean movPlaying;
  Surface surface;
  
  OffScreen(int Width, int Height){
    offScreen = createGraphics(Width, Height, P2D);
    width = Width;
    height = Height;
    surface = null;
  }
  
  void draw(){
    offScreen.beginDraw();
    offScreen.background(0);
    offScreen.endDraw();
  }
  
  PGraphics getFrame(){
    return offScreen;
  }
  
  void play(){
    movPlaying = true;
  }
  
  void pause(){
    movPlaying = false;
  }
  
  boolean isPlaying(){
    return movPlaying;
  }
  
  void reset(){
    this.play();
  }
  
  void setSurface(Surface Surface){
    surface = Surface;
  };
  
  Surface getSurface(){
    return surface;
  }
  
  void free(){
  }
}
