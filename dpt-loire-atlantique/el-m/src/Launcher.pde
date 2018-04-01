PImage img; // image de fond d'ecran
int smallPoint, largePoint;

SoldiersList allSoldiers; // liste de tous les soldats
SoldiersList displayedSoldiers_birth; // liste des soldats dont il faut afficher le lieu de naissance
SoldiersList displayedSoldiers_death; // liste des soldats dont il faut afficher le lieu de mort

Date formerDate; // ancienne date
Date currentDate; // date courante
Date warDate; // date de début de la guerre (1914)

int iteratorBeforeWar; // itérateur avant la guerre (en années)
int iteratorDuringWar; // itérateur durant la guerre (en mois)


// dans un vrai repère :
// -9.3 --> longitude gauche
// 37.1 --> longitude droite
// 29.7 --> latitude bas
// 56.39 --> latitude haut

// x total = 13.20
// y total = 26.7


void setup() {
  size(745, 439);
  img = loadImage("map.PNG");  
  smallPoint = 4;
  largePoint = 40;
  imageMode(CENTER);
  noStroke();
  background(255);
  
  formerDate = new Date(1850, 0, 0, 0, 0); // janvier 1850
  currentDate = new Date(1851, 0, 0, 0, 0); // janvier 1851
  warDate = new Date(1914, 0, 0, 0, 0); // janvier 1914
  iteratorBeforeWar = 1; // 1 an
  iteratorDuringWar = 1; // 1 mois
  
  allSoldiers = new SoldiersList();
  displayedSoldiers_birth = new SoldiersList();
  displayedSoldiers_death = new SoldiersList();
  allSoldiers.initialize(); // remplissage de la liste de tous les soldats
  System.out.println("Nombre de soldats au total : " + allSoldiers.getSize());
  
  //for(int i = 0; i < 10 ; i++){
  //  coords.add(new Coordinate(random(img.width), random(img.height)));
  //}
  
  // Paris
  //from.add(new Coordinate(1, 48.85, 2.35, new Date(1850, 5, 0, 0, 0), new Date(1914, 5, 0, 0, 0));
  // Athènes
  //from.add(new Coordinate(2, 37.97, 23.74, 6, 1850));
  // centre de la carte
  //from.add(new Coordinate(3, 42.7, 14.15, 6, 1850));
  // pointe Sud Tunisie
  //from.add(new Coordinate(4, 30.23, 9.56, 7, 1850));
  // gauche
  //from.add(new Coordinate(5, 42.7, -9.3, 7, 1850));
  // droite
  //from.add(new Coordinate(6, 42.7, 37.1, 7, 1850));
  // haut
  //from.add(new Coordinate(7, 56.39, 14.15, 8, 1850));
  // gauche
  //from.add(new Coordinate(8, 29.7, 14.15, 9, 1850));
  
}

void draw() { 
  background(img);
  
  fill(51, 204, 51, 63);
  rect(50,50,50,50);
  if(mousePressed){
    if(mouseX>50 && mouseX <50+50 && mouseY>50 && mouseY <50+50){
      //println("pressed");
      nextDate();
      println(getFormerDate() + "-->" + getCurrentDate());
      UpdateSoldiersLists();
    }
  }
  
  // affichage de la période
  drawDate();
  
  // Affichage des lieux de naissance
  for (Soldier s : displayedSoldiers_birth.list) {
    fill(51, 204, 255, 63);
    ellipse(s.xNaissance*img.width, s.yNaissance*img.height, 15, 15);
    //ellipse(50, 50, 15, 15);
  }
  
  // Affichage des lieux de mort
  for (Soldier s : displayedSoldiers_death.list) {
    fill(255, 0, 0, 63);
    ellipse(s.xDeces*img.width, s.yDeces*img.height, 15, 15);
    drawArrow(s.xNaissance*img.width, s.yNaissance*img.height, s.xDeces*img.width, s.yDeces*img.height);
  }
  
  //delay(int(random(20)));
  //addCoordinate();
}

void addCoordinate(){
  //from.add(new Coordinate(29.7 + random(56.39-29.7), -9.3+random(37.1-(-9.3)), int(random(12)), int(random(1900))));
}

/**
* Itère la date courante
*/
void nextDate(){
  formerDate.setYear(currentDate.getYear());
  formerDate.setMonth(currentDate.getMonth());
  // avant la guerre
  if(currentDate.compareTo(warDate) < 0) currentDate.setYear(currentDate.getYear()+iteratorBeforeWar);
  // pendant la guerre
  else{
    currentDate.setMonth((currentDate.getMonth()+iteratorDuringWar)%12);
    // on change d'année
    if (currentDate.getMonth() < formerDate.getMonth()) currentDate.setYear(currentDate.getYear()+1);
  }
}


/*
* MaJ les listes des soldats en fonction de la période de temps
*/
void UpdateSoldiersLists(){
  for (Soldier s : allSoldiers.list) {
    // si la date de naissance est dans l'intervalle de temps, on rajoute le soldat à la liste des soldats à afficher
    if(s.dateNaissance.compareTo(formerDate) > 0 && s.dateNaissance.compareTo(currentDate) <= 0){
      println("----> Naissance");
      displayedSoldiers_birth.list.add(s);
    }
    // si la date de décès est dans l'intervalle de temps, on rajoute le soldat à la liste des soldats à afficher
    if(s.dateDeces.compareTo(formerDate) > 0 && s.dateDeces.compareTo(currentDate) <= 0){
      println("----> Deces");
      displayedSoldiers_death.list.add(s);
    }
  }
}

/**
* renvoie la date courante
*/
String getFormerDate(){
  String ret = "";
  
  // on affiche le mois pendant la guerre
  if(formerDate.getYear() >= 1914){
    switch(formerDate.getMonth()) {
      case 0: 
        ret+="Jan. ";
        break;
      case 1: 
        ret+="Fev. ";
        break;
      case 2: 
        ret+="Mars ";
        break;
      case 3: 
        ret+="Avr. ";
        break;
      case 4: 
        ret+="Mai ";
        break;
      case 5: 
        ret+="Juin ";
        break;
      case 6: 
        ret+="Juil. ";
        break;
      case 7: 
        ret+="Août ";
        break;
      case 8: 
        ret+="Sept. ";
        break;
      case 9: 
        ret+="Oct. ";
        break;
      case 10: 
        ret+="Nov. ";
        break;
      case 11: 
        ret+="Déc. ";
        break;
    }
  }
  
  ret+=formerDate.getYear();
  
  return ret;
}
  
String getCurrentDate(){
  String ret = "";
  
  // on affiche le mois pendant la guerre
  if(currentDate.getYear() >= 1914){
    switch(currentDate.getMonth()) {
      case 0: 
        ret+="Jan. ";
        break;
      case 1: 
        ret+="Fev. ";
        break;
      case 2: 
        ret+="Mars ";
        break;
      case 3: 
        ret+="Avr. ";
        break;
      case 4: 
        ret+="Mai ";
        break;
      case 5: 
        ret+="Juin ";
        break;
      case 6: 
        ret+="Juil. ";
        break;
      case 7: 
        ret+="Août ";
        break;
      case 8: 
        ret+="Sept. ";
        break;
      case 9: 
        ret+="Oct. ";
        break;
      case 10: 
        ret+="Nov. ";
        break;
      case 11: 
        ret+="Déc. ";
        break;
    }
  }
  
  ret+=currentDate.getYear();
  
  return ret;
}

/**
* dessine une flèche de (x1, y1) vers (x2, y2)
*/
void drawArrow(float x1, float y1, float x2, float y2) {
  pushStyle();
  stroke(0, 102, 153);
  line(x1, y1, x2, y2);
  pushMatrix();
  translate(x2, y2);
  float a = atan2(x1-x2, y2-y1);
  rotate(a);
  line(0, 0, -10, -10);
  line(0, 0, 10, -10);
  popMatrix();
  popStyle();
}

/**
* affiche la période de temps
*/
void drawDate(){
  textSize(32);
  fill(102, 102, 102);
  text(getCurrentDate(), 10, img.height-10); 
}
