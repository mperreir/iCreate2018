static class Helper {
  
  static ArrayList<OffScreen> offScreens;
  static ArrayList<OffScreen> offScreensPlayed;
  
  private Helper() {
  }
  
  static void setupOffScreen(Surface surf, int id){
    OffScreen contenu = offScreens.get(id);
    offScreensPlayed.add(contenu);
    surf.setOffScreenBuffer(contenu);
    boolean fin = false;
    int i = 0;
      while(i < offScreens.size() && !fin){
        if(offScreens.get(i) == contenu){
          offScreens.remove(i);
          fin = true;
        }
        i++;
      }
  }
  
  static void changerOffScreen(Surface surf, OffScreen caller){
      int newId = (int)(Math.random() * offScreens.size());
      OffScreen contenu = offScreens.get(newId);
      surf.setOffScreenBuffer(contenu);
      offScreensPlayed.add(contenu);
      boolean fin = false;
      int i = 0;
      while(i < offScreens.size() && !fin){
        if(offScreens.get(i) == contenu){
          offScreens.remove(i);
          fin = true;
        }
        i++;
      }
      fin = false;
      i = 0;
      while(i < offScreensPlayed.size() && !fin){
        if(offScreensPlayed.get(i) == caller){
          offScreensPlayed.remove(i);
          fin = true;
        }
        i++;
      }
      offScreens.add(caller);
  }
  
  static void setOffScreens(ArrayList<OffScreen> OffScreens){
    offScreens = OffScreens;
    offScreensPlayed = new ArrayList<OffScreen>();
  }
}
