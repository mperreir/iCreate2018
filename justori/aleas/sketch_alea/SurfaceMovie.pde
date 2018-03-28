class SurfaceMovie extends Surface{
  
  Movie mov;
  boolean movPlaying;
  
  SurfaceMovie(Keystone Ks, int Width, int Height , int Resolution, Movie Mov){    
    super(Ks, Width, Height, Resolution);
    mov = Mov;
    mov.frameRate(25);
    this.play();
    mov.jump(0);
    this.pause();
  }
  
  @Override
  void draw(){
    offScreenBuffer.beginDraw(); // On commence a écrire dans le buffer
    offScreenBuffer.background(255);
    offScreenBuffer.image(mov, 0, 0); // On ajoute la frame dans le buffer
    offScreenBuffer.endDraw();
    
    surface.render(offScreenBuffer);
  }
  
  void play(){
    mov.play();
    movPlaying = true;
  }
  
  void pause(){
    mov.pause();
    movPlaying = false;
  }
  
  boolean isPlaying(){
    return movPlaying;
  }
}
