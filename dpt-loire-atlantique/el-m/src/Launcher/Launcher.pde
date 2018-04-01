PImage img; // image de fond d'ecran

SoldiersList allSoldiers; // liste de tous les soldats
SoldiersList displayedSoldiers_birth; // liste des soldats dont il faut afficher le lieu de naissance
SoldiersList displayedSoldiers_death; // liste des soldats dont il faut afficher le lieu de mort

Date formerDate; // ancienne date
Date currentDate; // date courante
Date warDate; // date de début de la guerre (1914)

int iteratorBeforeWar; // itérateur avant la guerre (en années)
int iteratorDuringWar; // itérateur durant la guerre (en mois)

int timeAnimation = millis(); //stocke le temps pour décider quand dessiner
int delayDeath = 300; // Délai entre l'affichage des points pour les naissances
int delayBirth = 100; // Délai entre l'affichage des points pour les morts

String[] months = {"Janv.", "Fev.", "Mars", "Avr.", "Mai", "Juin", "Juil.", "Août", "Sept.", "Oct.", "Nov.", "Déc."};
boolean forward = true; // true si on avance, false si on recule


// dans un vrai repère :
// -9.3 --> longitude gauche
// 37.1 --> longitude droite
// 29.7 --> latitude bas
// 56.39 --> latitude haut

// x total = 13.20
// y total = 26.7


void setup() {
  // Commence à écouter les messages OSC sur le port 12000
  oscP5 = new OscP5(this,12000);
  
  size(745, 439);
  img = loadImage("map.PNG");  
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
}

void draw() { 
  background(img);
  
  fill(51, 204, 51, 63);
  rect(70,165,30,30);
  fill(255, 0, 0, 63);
  rect(25,165,30,30);
  /*forward = true;
  if(mousePressed){
    // clic carré vert pour avancer le temps
    if(mouseX>70 && mouseX <70+30 && mouseY>165 && mouseY <165+30){
      println("avance");
      // on passe à la période de temps suivante
      setPeriodOfTime();
      println(getDateAsString(formerDate) + "-->" + getDateAsString(currentDate));
      // MaJ de la liste des lieux de naissance et des lieux de décès en fonction de la période de temps courante
      updateSoldiersLists();
    }
    // clic carré rouge pour reculer le temps
    else if(mouseX>25 && mouseX <25+30 && mouseY>165 && mouseY <165+30){
      println("recule");
      forward = false;
      // MaJ de la liste des lieux de naissance et des lieux de décès en fonction de la période de temps courante
      updateSoldiersLists();
      // on repasse à la période de temps précédente
      setPeriodOfTime();
      println(getDateAsString(formerDate) + "-->" + getDateAsString(currentDate));
      
    }
  }*/
  
  int year = currentDate.getYear();
  int rollValue = isRolling();
  
  // Change d'année avec un délai pour les naissances
  if ((millis() > (timeAnimation + delayBirth)) && (year < 1914) && rollValue!=0){
    // si on avance
    if(rollValue == 1){
      forward = true;
      // on passe à la période de temps suivante
      setPeriodOfTime();
      // MaJ de la liste des lieux de naissance et des lieux de décès en fonction de la période de temps courante
      updateSoldiersLists();
    }
    // si on recule
    else{
      forward = false;
      // MaJ de la liste des lieux de naissance et des lieux de décès en fonction de la période de temps courante
      updateSoldiersLists();
      // on passe à la période de temps précédente
      setPeriodOfTime();
    }
    println(getDateAsString(formerDate) + "-->" + getDateAsString(currentDate));
    timeAnimation = millis();
  }
  
  // Chande de période avec un délai pour les morts
  if ((millis() > (timeAnimation + delayDeath)) && (year >= 1913) && (year < 1919) && rollValue!=0){
    // si on avance
    if(rollValue == 1){
      forward = true;
      // on passe à la période de temps suivante
      setPeriodOfTime();
      // MaJ de la liste des lieux de naissance et des lieux de décès en fonction de la période de temps courante
      updateSoldiersLists();
    }
    // si on recule
    else {
      forward = false;
      // MaJ de la liste des lieux de naissance et des lieux de décès en fonction de la période de temps courante
      updateSoldiersLists();
      // on passe à la période de temps précédente
      setPeriodOfTime();
    }
    println(getDateAsString(formerDate) + "-->" + getDateAsString(currentDate));
    timeAnimation = millis();
  }
  
  // affichage de la période
  drawDate();
  // affiche les lieux de naissance
  drawBirths();
  // affiche les lieux de mort
  drawDeaths();
  // affichage des matricules des soldats morts
  drawMatricules();

}

/**
* avance ou recule la période de temps
*/
void setPeriodOfTime(){
  // on avance la date courante
  if(forward){
    formerDate.setYear(currentDate.getYear());
    formerDate.setMonth(currentDate.getMonth());
    // avant la guerre
    if(currentDate.compareTo(warDate) < 0) currentDate.setYear(currentDate.getYear()+iteratorBeforeWar);
    // pendant la guerre
    else{
      currentDate.setMonth((currentDate.getMonth()+iteratorDuringWar)%12);
      // on change d'année
      if (currentDate.compareTo(formerDate) < 0) currentDate.setYear(currentDate.getYear()+1);
    }
  }
  // on recule la date courante
  else{
    currentDate.setYear(formerDate.getYear());
    currentDate.setMonth(formerDate  .getMonth());
    // avant la guerre
    if(currentDate.compareTo(warDate) < 0) formerDate.setYear(currentDate.getYear()-iteratorBeforeWar);
    // pendant la guerre
    else{
      formerDate.setMonth((currentDate.getMonth()-iteratorDuringWar)%12);
      // on change d'année
      if (currentDate.compareTo(formerDate) < 0) formerDate.setYear(currentDate.getYear()-1);
    }
  }
}


/*
* MaJ les listes des soldats en fonction de la période de temps
*/
void updateSoldiersLists(){
  // si on avance
  if(forward){
    for (Soldier s : allSoldiers.list) {
      // si la date de naissance est dans l'intervalle de temps, on rajoute le soldat à la liste des soldats à afficher
      if(s.dateNaissance.compareTo(formerDate) > 0 && s.dateNaissance.compareTo(currentDate) <= 0){
        //println("----> Naissance");
        displayedSoldiers_birth.list.add(s);
      }
      // si la date de décès est dans l'intervalle de temps, on rajoute le soldat à la liste des soldats à afficher
      if(s.dateDeces.compareTo(formerDate) > 0 && s.dateDeces.compareTo(currentDate) <= 0){
        //println("----> Deces");
        displayedSoldiers_death.list.add(s);
      }
    }
  }
  // si on recule
  else {
    for (int i = displayedSoldiers_birth.list.size()-1; i >= 0; i--) {
      Soldier tmp = displayedSoldiers_birth.list.get(i);
      // si la date de naissance est dans l'intervalle de temps, on supprime le soldat de la liste des soldats à afficher
      if(tmp.dateNaissance.compareTo(formerDate) > 0 && tmp.dateNaissance.compareTo(currentDate) <= 0){
        displayedSoldiers_birth.list.remove(tmp);
      }
    }
    for (int i = displayedSoldiers_death.list.size()-1; i >= 0; i--) {
      Soldier tmp = displayedSoldiers_death.list.get(i);
      // si la date de décès est dans l'intervalle de temps, on supprime le soldat de la liste des soldats à afficher
      if(tmp.dateDeces.compareTo(formerDate) > 0 && tmp.dateDeces.compareTo(currentDate) <= 0){
        displayedSoldiers_death.list.remove(tmp);
      }
    }
  }
}

/**
* renvoie la date au bon format pour l'afficher
*/
String getDateAsString(Date d){
  String ret = "";
  // pendant la guerre, on affiche le mois
  if(d.getYear() >= 1914) ret+=months[d.getMonth()]+" ";
  ret+=d.getYear();
  return ret;
}

void changeYear(){
  setPeriodOfTime();
  println(getDateAsString(formerDate) + "-->" + getDateAsString(currentDate));
  // MaJ de la liste des lieux de naissance et des lieux de décès en fonction de la période de temps courante
  updateSoldiersLists();
  timeAnimation = millis();
}

/**
* affiche la période de temps
*/
void drawDate(){
  textSize(32);
  fill(102, 102, 102);
  text(getDateAsString(currentDate), 10, img.height-10); 
}

/**
* affiche les lieux de naissance
*/
void drawBirths(){
  for (Soldier s : displayedSoldiers_birth.list) {
    fill(51, 204, 255, 63);
    ellipse(s.xNaissance*img.width, s.yNaissance*img.height, 15, 15);
  }
}

/**
* affiche les lieux de mort
*/
void drawDeaths(){
  for (Soldier s : displayedSoldiers_death.list) {
    fill(255, 0, 0, 63);
    ellipse(s.xDeces*img.width, s.yDeces*img.height, 15, 15);
    // affiche une flèche partant du lieu de naissance vers le lieu de décès
    drawArrow(s.xNaissance*img.width, s.yNaissance*img.height, s.xDeces*img.width, s.yDeces*img.height);
  }
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
* affichage des matricules des soldats morts
*/
void drawMatricules(){
  int y = 10;
  for (Soldier s : displayedSoldiers_death.list) {
    textSize(10);
    fill(102, 102, 102);
    text(s.matricule, img.width-30, y); 
    pushStyle();
    stroke(102, 102, 102);
    line(img.width-30, y-5, img.width-5, y-5);
    popStyle();
    y+=10;
  }
}
