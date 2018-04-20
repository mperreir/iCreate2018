class SurfaceStatique extends Surface {
  SurfaceStatique(Keystone Ks, int Width, int Height , int Resolution, Integer id) {
    super(Ks, Width, Height , Resolution, id);
  }
  
  @Override
  void reset(){
    offScreenBuffer.pause();
    setOffScreenBuffer(new OffScreen(width, height));
  }
}
