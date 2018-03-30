import processing.video.*;

/**
 * This is a simple example of how to use the Keystone library.
 *
 * To use this example in the real world, you need a projector
 * and a surface you want to project your Processing sketch onto.
 *
 * Simply drag the corners of the CornerPinSurface so that they
 * match the physical surface's corners. The result will be an
 * undistorted projection, regardless of projector position or 
 * orientation.
 *
 * You can also create more than one Surface object, and project
 * onto multiple flat surfaces using a single projector.
 *
 * This extra flexbility can comes at the sacrifice of more or 
 * less pixel resolution, depending on your projector and how
 * many surfaces you want to map. 
 */

import deadpixel.keystone.*;

Keystone ks;
collectionSurface surfaces;
ArrayList<Movie> lesFilms;
ArrayList<OffScreen> lesContenus;
VideoFrame frame;
OffScreen frame2;
int y;

void setup() {
  // On veut un rendu en 3D pour le fonctionnement de keystone et en plein écran pour la projection
  fullScreen(P3D);
  // On crée l'ojet keystone qui va gérer les surfaces que l'on veut map
  ks = new Keystone(this);
  //On charge les vidéo que l'on veut utiliser
  String[] fichierFilm = {"portion_1.mp4", "portion_2.mp4", "portion_4.mp4", "portion_6.mp4", "portion_7.mp4", "portion_8.mp4", "portion_9.mp4", "portion_10.mp4", "portion_12.mp4", "portion_13.mp4", "portion_14.mp4"};
  lesFilms = creerMovie(fichierFilm);
  lesContenus = new ArrayList<OffScreen>();
  for(int i = 0; i < lesFilms.size(); i++){
    lesContenus.add(new VideoFrame(600,600,lesFilms.get(i)));
  }
  //On charge une surface qui sert a la projection d'une vidéo
  surfaces = new collectionSurface();
  for(int i = 0; i < 4; i++){
    surfaces.add(new Surface(ks, 600,600,20, i));
  }
  Helper.setOffScreens(lesContenus);
  Helper.setupOffScreen(surfaces.getSurface(0),0);
  Helper.setupOffScreen(surfaces.getSurface(1),1);
  Helper.setupOffScreen(surfaces.getSurface(2),2);
  Helper.setupOffScreen(surfaces.getSurface(3),3);
  y = 0;
}

void draw() {
  //On veut un fond noir et éclairer uniquement les cubes
  background(0);
  surfaces.draw();
  println(y);
  y++;
}

void keyPressed() {
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;
  case 't':
    for(int i = 0; i < surfaces.getSize(); i++){
      surfaces.getSurface(i).setOffScreenBuffer(new OffScreen(500,500));
    }
    break;
  case 'p':
    // play/pause the movie on keypress
    if (!frame.isPlaying()) {
      frame.play();
    } else {
      frame.pause();
    }
    break;
  }
}

void movieEvent(Movie m) {
  m.read();
}

// Permet de créer une liste de films a partir d'une liste de nom de fichiers.
// Les fichiers doivent être dans le dossier data
ArrayList<Movie> creerMovie(String[] liste){
  ArrayList<Movie> movies = new ArrayList<Movie>();
  for(int i = 0; i < liste.length; i++){
    movies.add(new Movie(this, liste[i]));
  }
  return movies;
}
