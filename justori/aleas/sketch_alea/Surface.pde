class Surface {

  CornerPinSurface surface;
  OffScreen offScreenBuffer;
  int width;
  int height;
  
  Surface(Keystone Ks, int Width, int Height , int Resolution, Integer id) {
    surface = Ks.createCornerPinSurface(Width, Height, Resolution);
    offScreenBuffer = new TextFrame(Width, Height, id.toString());
    width = Width;
    height = Height;
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
    //On va détacher le buffer donc la surface du buffer n'est plus celle-ci
    offScreenBuffer.setSurface(null);
    //On change le buffer
    offScreenBuffer = OffScreenBuffer;
    //On change la surface du buffer pour dire que c'est celle-ci
    offScreenBuffer.setSurface(this);
    offScreenBuffer.reset();
  }
  
  void reset(){
    offScreenBuffer.pause();
    offScreenBuffer.free();
    setOffScreenBuffer(new OffScreen(width, height));
  }
  
  void pause(){
    offScreenBuffer.pause();
  }
  
  void play(){
    offScreenBuffer.play();
  }

}
