class ImageFrame extends OffScreen {
    PImage image;
    int i;
    
    ImageFrame(int Width, int Height, PImage Image){
        super(Width, Height);
        image = Image;
        i = 0;
    }
    
    @Override
    void draw(){
      offScreen.beginDraw();
      offScreen.image(image, 0,0);
      offScreen.endDraw();
      if(movPlaying){
        i++;
      }
      if(i > 500){
        Helper.changerImage(this.surface,this);
      }
    }
    
  @Override
  void reset(){
    i = 0;
  }
  
  @Override
  void free(){
    Helper.freeImage(this);
  }
}
