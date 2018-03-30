class VideoFrame extends OffScreen {
  
  Movie mov;
  boolean movPlaying;
  int i;
  
  VideoFrame(int Width, int Height, Movie Mov){
    super(Width, Height);
    mov = Mov;
    mov.frameRate(25);
    this.play();
    this.pause();
  }
  
  @Override
  void draw(){
    offScreen.beginDraw();
    offScreen.background(255);
    offScreen.image(mov, 0, 0); // On ajoute la frame dans le buffer
    offScreen.endDraw(); //<>//
    if (mov.time() > mov.duration() - 0.25) {
      this.pause();
      Helper.changerOffScreen(this.surface, this);
    }
  }
  
  @Override
  void play(){
    mov.play();
    movPlaying = true;
  }
  
  @Override
  void pause(){
    mov.pause();
    movPlaying = false;
  }
  
  @Override
  boolean isPlaying(){
    return movPlaying;
  }
  
  @Override
  void reset(){
    mov.jump(0);
    this.play();
  }
  
  void movieEvent(Movie m) {
    m.read();
  }
}
