static class Helper {
  
  static ArrayList<OffScreen> offScreens;
  static ArrayList<OffScreen> offScreensPlayed;
  static ArrayList<OffScreen> lesImages;
  static ArrayList<OffScreen> lesImagesDisplayed;
  static ArrayList<OffScreen> lesMots;
  static ArrayList<OffScreen> lesMotsDisplayed;
  
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
  
  static void setupImage(Surface surf, int id){
    OffScreen contenu = lesImages.get(id);
    lesImagesDisplayed.add(contenu);
    surf.setOffScreenBuffer(contenu);
    boolean fin = false;
    int i = 0;
    while(i < lesImages.size() && !fin){
      if(lesImages.get(i) == contenu){
        lesImages.remove(i);
        fin = true;
      }
      i++;
    }
  }
  
  static void setupMot(Surface surf, int id){
    OffScreen contenu = lesMots.get(id);
    lesMotsDisplayed.add(contenu);
    surf.setOffScreenBuffer(contenu);
    boolean fin = false;
    int i = 0;
    while(i < lesMots.size() && !fin){
      if(lesMots.get(i) == contenu){
        lesMots.remove(i);
        fin = true;
      }
      i++;
    }
  }
  
  static void changerImage(Surface surf, OffScreen caller){
    int newId = (int)(Math.random() * lesImages.size());
    OffScreen contenu = lesImages.get(newId);
    surf.setOffScreenBuffer(contenu);
    boolean fin = false;
    int i = 0;
    while(i < lesImages.size() && !fin){
      if(lesImages.get(i) == contenu){
        lesImages.remove(i);
        fin = true;
      }
      i++;
    }
    fin = false;
    i = 0;
    while(i < lesImagesDisplayed.size() && !fin){
      if(lesImagesDisplayed.get(i) == caller){
        lesImagesDisplayed.remove(i);
        fin = true;
      }
      i++;
    }
    lesImages.add(caller);
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
  
  static void changerMot(Surface surf, OffScreen caller){
      int newId = (int)(Math.random() * lesMots.size());
      OffScreen contenu = lesMots.get(newId);
      surf.setOffScreenBuffer(contenu);
      lesMotsDisplayed.add(contenu);
      boolean fin = false;
      int i = 0;
      while(i < lesMots.size() && !fin){
        if(lesMots.get(i) == contenu){
          lesMots.remove(i);
          fin = true;
        }
        i++;
      }
      fin = false;
      i = 0;
      while(i < lesMotsDisplayed.size() && !fin){
        if(lesMotsDisplayed.get(i) == caller){
          lesMotsDisplayed.remove(i);
          fin = true;
        }
        i++;
      }
      lesMots.add(caller);
  }
  
  static void setOffScreens(ArrayList<OffScreen> OffScreens){
    offScreens = OffScreens;
    offScreensPlayed = new ArrayList<OffScreen>();
  }
  
  static void setImages(ArrayList<OffScreen> LesImages){
    lesImages = LesImages;
    lesImagesDisplayed = new ArrayList<OffScreen>();
  }
  
  static void setMots(ArrayList<OffScreen> LesMots){
    lesMots = LesMots;
    lesMotsDisplayed = new ArrayList<OffScreen>();
  }
  
  static void freeOffScreen(OffScreen off){
    boolean fin = false;
    int i = 0;
    while(i < offScreensPlayed.size() && !fin){
        if(offScreensPlayed.get(i) == off){
          offScreensPlayed.remove(i);
          fin = true;
        }
        i++;
      }
      offScreens.add(off);
  }
  
  static void freeImage(OffScreen off){
    boolean fin = false;
    int i = 0;
     while(i < lesImagesDisplayed.size() && !fin){
      if(lesImagesDisplayed.get(i) == off){
        
        lesImagesDisplayed.remove(i);
        fin = true;
      }
      i++;
    }
    lesImages.add(off);
  }
  
  static void freeMot(OffScreen off){
    boolean fin = false;
    int i = 0;
     while(i < lesMotsDisplayed.size() && !fin){
      if(lesMotsDisplayed.get(i) == off){
        
        lesMotsDisplayed.remove(i);
        fin = true;
      }
      i++;
    }
    lesMots.add(off);
  }
}
