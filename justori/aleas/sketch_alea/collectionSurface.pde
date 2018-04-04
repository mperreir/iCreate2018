class collectionSurface{
  
  ArrayList<Surface> surfaces;
  
  collectionSurface(){
    surfaces = new ArrayList<Surface>();
  }
  
  void add(Surface surf){
    surfaces.add(surf);
  }
  
  void draw(){
    for(Surface surf: surfaces){
      surf.draw();
    }
  }
  
  Surface getSurface(int id){
    if(id < surfaces.size()){
      return surfaces.get(id);
    } else {
      return null;
    }
  }
  
  int getSize(){
    return surfaces.size();
  }
  
  void play(){
    for(Surface surf: surfaces){
      surf.play();
    }
  }
  
  void pause(){
    for(Surface surf: surfaces){
      surf.pause();
    }
  }
  
  void reset(){
    for(Surface surf: surfaces){
      surf.reset();
    }
  }
}
