class OffScreen {
  PGraphics offScreen;
  
  OffScreen(int Width, int Height){
    offScreen = createGraphics(Width, Height, P3D);
  }
  
  void draw(){
    offScreen.beginDraw();
    offScreen.background(255);
    offScreen.endDraw();
  }
  
  PGraphics getFrame(){
    return offScreen;
  }
}
