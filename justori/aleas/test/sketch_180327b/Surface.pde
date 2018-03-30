class Surface {
  CornerPinSurface surface;
  PGraphics offScreenBuffer;
  
  Surface(Keystone Ks, int Width, int Height , int Resolution) {
    surface = Ks.createCornerPinSurface(Width, Height, Resolution);
    offScreenBuffer = createGraphics(500, 500, P3D);
  }
  
  void draw(){
    offScreenBuffer.beginDraw();
    offScreenBuffer.background(255); //On met un fond banc pour voir les formes sur le sketch
    offScreenBuffer.endDraw();
    
    surface.render(offScreenBuffer);
  }
}
