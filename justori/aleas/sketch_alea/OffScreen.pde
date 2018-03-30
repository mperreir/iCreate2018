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
    offScreen.background(255,25,48);
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
  }
  
  void setSurface(Surface Surface){
    surface = Surface;
  };
  
  Surface getSurface(){
    return surface;
  }
}
