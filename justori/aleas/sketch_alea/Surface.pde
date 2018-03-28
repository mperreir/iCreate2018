class Surface {
  CornerPinSurface surface;
  OffScreen offScreenBuffer;
  
  Surface(Keystone Ks, int Width, int Height , int Resolution) {
    surface = Ks.createCornerPinSurface(Width, Height, Resolution);
    offScreenBuffer = new OffScreen(Width, Height);
  }
  
  Surface(Keystone Ks, int Width, int Height , int Resolution, OffScreen OffScreenBuffer) {
    surface = Ks.createCornerPinSurface(Width, Height, Resolution);
    offScreenBuffer = OffScreenBuffer;
  }
  
  void draw(){
    offScreenBuffer.draw();
    
    surface.render(offScreenBuffer.getFrame());
  }
  
  void setOffScreenBuffer(OffScreen OffScreenBuffer){
    offScreenBuffer = OffScreenBuffer;
  }
}
