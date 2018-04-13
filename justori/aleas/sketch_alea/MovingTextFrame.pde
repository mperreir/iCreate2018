class MovingTextFrame extends TextFrame {
  
  int i;
  
  MovingTextFrame(int Width, int Height, String Text){
    super(Width, Height, Text);
    i = 0;
  }
  
  @Override
  void draw(){
    offScreen.beginDraw();
    offScreen.background(255);
    offScreen.fill(0);
    offScreen.textFont(f,42);
    offScreen.text(text, width/3, height/2);
    offScreen.endDraw();
    if(movPlaying){
        i++;
    }
    if(i > 300){
      Helper.changerMot(this.surface,this);
    }
  }
  
  @Override
  void reset(){
    i = 0;
    this.play();
  }
  
  @Override
  void free(){
    Helper.freeMot(this);
  }
}
