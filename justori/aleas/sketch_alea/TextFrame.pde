class TextFrame extends OffScreen{
  String text;
  PFont f;
  
  TextFrame(int Width, int Height, String Text){
    super(Width, Height);
    text = Text;
    f = createFont("Arial",16,true);
  }
  
  @Override
  void draw(){
    offScreen.beginDraw();
    offScreen.background(66,244,170);
    offScreen.textFont(f,32);
    offScreen.text(text, width/2, height/2);
    offScreen.endDraw();
  }
}  
