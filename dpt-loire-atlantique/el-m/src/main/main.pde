PImage img; // image de fond d'ecran

boolean changeColor = false;

/*
Variables d'ajustement pour détecter au mieux le mouvement
--------------------------------------------------------  ---------------
treshold:
Définit un seuil (pour la vitesse angulaire) à partir duquel la manivelle 
est considérée comme tournant (ignorer les micro mouvements)

*/
double treshold = 30;

SoldiersList allSoldiers; // liste de tous les soldats
SoldiersList displayedSoldiers_birth; // liste des soldats dont il faut afficher le lieu de naissance
SoldiersList displayedSoldiers_death; // liste des soldats dont il faut afficher le lieu de mort
SoldiersList matricules; // liste des soldats dont il faut afficher le matricule

Date formerDate; // ancienne date
Date currentDate; // date courante
Date warDate; // date de début de la guerre (1914)

int iteratorBeforeWar; // itérateur avant la guerre (en années)
int iteratorDuringWar; // itérateur durant la guerre (en mois)

int timeAnimation = millis(); //stocke le temps pour décider quand dessiner
final int delayDeath = 150; // Délai entre l'affichage des points pour les naissances
final int delayBirth = 50; // Délai entre l'affichage des points pour les morts
final int delayReset = 15000; // Délai de retour à zéro si l'utilisateur est inactif

final String[] months = {"Janv.", "Fev.", "Mars", "Avr.", "Mai", "Juin", "Juil.", "Août", "Sept.", "Oct.", "Nov.", "Déc."};


// map1 : dans un vrai repère :
// -9.3 --> longitude gauche
// 37.1 --> longitude droite
// 29.7 --> latitude bas
// 65.458 --> latitude haut
// x total = 13.20
// y total = 26.7

// map2 : dans un vrai repère :
// -16 --> longitude gauche
// 28.43 --> longitude droite
// 35.30 --> latitude bas
// 56.39 --> latitude haut
// 47.7 --> latitude centre
// 5.76 --> longitude centre
// x total = 37.26 --> 18.2476753606 à -19.0107904607
// y total = 21.1 --> -8.69 à 12.4

void initDates(){
  formerDate = new Date(1860, 0, 0, 0, 0); // janvier 1860
  currentDate = new Date(1861, 0, 0, 0, 0); // janvier 1861
}

void setup() {
  // Commence à écouter les messages OSC sur le port 12000
  oscP5 = new OscP5(this,12000);
  //size(400,400);
  fullScreen();
  //size(745, 439);
  img = loadImage("../../img/bords_sombres.png");  
  imageMode(CORNER);
  noStroke();
  background(255);
 
  initDates();
  warDate = new Date(1914, 0, 0, 0, 0); // janvier 1914
  iteratorBeforeWar = 1; // 1 an
  iteratorDuringWar = 1; // 1 mois
  
  allSoldiers = new SoldiersList();
  displayedSoldiers_birth = new SoldiersList();
  displayedSoldiers_death = new SoldiersList();
  matricules = new SoldiersList();
  allSoldiers.initialize(); // remplissage de la liste de tous les soldats
  System.out.println("Nombre de soldats au total : " + allSoldiers.list.size());   
}

void draw() { 
  //background(img);
  image(img,0,0,width,height);
  
  // #################### pour tester sans le téléphone ####################
  fill(51, 204, 51, 63);
  rect(70,165,30,30);
  fill(255, 0, 0, 63);
  rect(25,165,30,30);

  if(mousePressed){
    // clic carré vert pour avancer le temps
    if(mouseX>70 && mouseX <70+30 && mouseY>165 && mouseY <165+30){
      // on passe à la période de temps suivante
      setPeriodOfTime(true);
      //println(getDateAsString(formerDate) + "-->" + getDateAsString(currentDate));
      // MaJ de la liste des lieux de naissance et des lieux de décès en fonction de la période de temps courante
      updateSoldiersLists(true);
    }
    // clic carré rouge pour reculer le temps
    else if(mouseX>25 && mouseX <25+30 && mouseY>165 && mouseY <165+30){
      // MaJ de la liste des lieux de naissance et des lieux de décès en fonction de la période de temps courante
      updateSoldiersLists(false);
      // on repasse à la période de temps précédente
      setPeriodOfTime(false);
      // ajoute les naissances et les décès dans l'intervalle de temps
      addPointsInMeantime(false);
      //println(getDateAsString(formerDate) + "-->" + getDateAsString(currentDate));
    }
  }
  // #######################################################################
  
  checkActivity();
  
  int year = currentDate.getYear();
  double angularSpeed = isRolling();
  
  // Change d'année avec un délai pour les naissances
  if (year < 1914){
    move(delayBirth, angularSpeed);
  }
  
  // Chande de période avec un délai pour les morts
  if (year <= 1919){
    move(delayDeath, angularSpeed);
  }
  
  // suppression des matricules des soldats morts après la date courante
  updateMatricules();
  // affichage de la période
  //drawDate();
  // affiche les lieux de naissance
  drawBirths();
  // affiche les lieux de mort
  drawDeaths();
  // affichage des matricules des soldats morts
  drawMatricules();
  // affichage de la frise chronologique  
  drawTimeline();

}

void checkActivity(){
    if(millis() > (timeAnimation + delayReset)){
      displayedSoldiers_birth.list.clear();
      displayedSoldiers_death.list.clear();
      matricules.list.clear();
      initDates();
      resetSensor();
      timeAnimation = millis();
    }
}

void move(int delay, double angularSpeed){
  
    int rollValue = angularSpeed >= 0 ? 1 : -1;
    boolean rolling = false;
  
    // Vitesse rapide (délai entre les animations)
    if(millis() > (timeAnimation + delay) && Math.abs(angularSpeed) > 3*treshold){
        rolling = true;
    }
    
    // Vitesse moyenne
    if(millis() > (timeAnimation + 2*delay) && Math.abs(angularSpeed) > 2*treshold){
        rolling = true;
    }
    
    // Vitesse lente
    if(millis() > (timeAnimation + 3*delay) && Math.abs(angularSpeed) > treshold){
        rolling = true;
    }
    
    if(rollValue == 1 && rolling){
        moveForward();
        changeColor = true;
    }
    else if (rolling){
        moveBackward();
        changeColor = true;
    }
}

// Met à jour les infos quand on avance
void moveForward(){
    // on passe à la période de temps suivante
    setPeriodOfTime(true);
    // MaJ de la liste des lieux de naissance et des lieux de décès en fonction de la période de temps courante
    updateSoldiersLists(true);
}

// Met à jour les infos quand on recule
void moveBackward(){
  println(currentDate.getYear());
  if(currentDate.getYear() > 1860){
      // MaJ de la liste des lieux de naissance et des lieux de décès en fonction de la période de temps courante
      updateSoldiersLists(false);
      // on passe à la période de temps précédente
      setPeriodOfTime(false);
      // ajoute les naissances et les décès dans l'intervalle de temps
      addPointsInMeantime(false);
  }
}

/**
* avance ou recule la période de temps
*/
void setPeriodOfTime(boolean forward){
  // on avance la date courante
  if(forward && currentDate.getYear() < 1919){
    // avant la guerre
    if(currentDate.compareTo(warDate) < 0){
      formerDate = new Date(currentDate.getYear()+1, 0, 0, 0, 0);
      currentDate.setYear(currentDate.getYear()+iteratorBeforeWar);
    }
    // pendant la guerre
    else{
      // si mois de décembre
      if(currentDate.getMonth()==11){
        formerDate = new Date(currentDate.getYear()+1, 0, 0, 0, 0);
        currentDate = new Date(currentDate.getYear()+1, 1, 0, 0, 0);
      }
      // si mois d'octobre
      else if(currentDate.getMonth()==10){
        formerDate = new Date(currentDate.getYear(), 11, 0, 0, 0);
        currentDate = new Date(currentDate.getYear()+1, 0, 0, 0, 0);
      }
      else{
        formerDate = new Date(currentDate.getYear(), currentDate.getMonth()+1, 0, 0, 0);
        currentDate = new Date(currentDate.getYear(), currentDate.getMonth()+2, 0, 0, 0);
      }
    }
  }
  // on recule la date courante
  else if(!forward && currentDate.getYear() > 1849){
    // avant la guerre
    if(currentDate.compareTo(warDate) < 0) 
    {
      currentDate = new Date(currentDate.getYear(), 0, 0, 0, 0);
      formerDate = new Date(currentDate.getYear(), 0, 0, 0, 0);
    }
    // pendant la guerre
    else{
      // si mois de janvier
      if(currentDate.getMonth() == 0)
      {
        currentDate = new Date(currentDate.getYear()-1, 0, 0, 0, 0);
        // si année du début de la guerre
        if(currentDate.getYear() == 1913) formerDate = new Date(1913, 0, 0, 0, 0);
        else formerDate = new Date(currentDate.getYear(), 11, 0, 0, 0);
      }
      else {
        currentDate = new Date(currentDate.getYear(), currentDate.getMonth(), 0, 0, 0);
        formerDate = new Date(currentDate.getYear(), currentDate.getMonth(), 0, 0, 0);
      }
    }
  }
  timeAnimation = millis();
}

/*
* MaJ les listes des soldats en fonction de la période de temps
*/
void updateSoldiersLists(boolean forward){
  // si on avance
  if(forward){
    // suppression des points de naissance et de décès des soldats morts précédemment
    for (int i = displayedSoldiers_death.list.size()-1; i >= 0; i--) {
      Soldier tmp = displayedSoldiers_death.list.get(i);
      if(!matricules.list.contains(tmp)) matricules.list.add(tmp);
      if(displayedSoldiers_birth.list.contains(tmp)) displayedSoldiers_birth.list.remove(tmp);
      if(displayedSoldiers_death.list.contains(tmp)) displayedSoldiers_death.list.remove(tmp);
    }
    // ajoute les naissances et les décès dans l'intervalle de temps
    addPointsInMeantime(true);
  }
  // si on recule
  else {
    // suppression des naissances et des décès sur la période précédente
   for (int i = displayedSoldiers_birth.list.size()-1; i >= 0; i--) {
      Soldier tmp = displayedSoldiers_birth.list.get(i);
      // si la date de naissance est dans l'intervalle de temps, on supprime le soldat de la liste des soldats à afficher
      if(tmp.dateNaissance.compareTo(formerDate) > 0 && tmp.dateNaissance.compareTo(currentDate) <= 0){
        if(displayedSoldiers_birth.list.contains(tmp)) displayedSoldiers_birth.list.remove(tmp);
      }
    }
    for (int i = displayedSoldiers_death.list.size()-1; i >= 0; i--) {
      Soldier tmp = displayedSoldiers_death.list.get(i);
      // si la date de décès est dans l'intervalle de temps, on supprime le soldat de la liste des soldats à afficher
      if(tmp.dateDeces.compareTo(formerDate) > 0 && tmp.dateDeces.compareTo(currentDate) <= 0){
        if(displayedSoldiers_death.list.contains(tmp)) displayedSoldiers_death.list.remove(tmp);
        if(!displayedSoldiers_birth.list.contains(tmp)) displayedSoldiers_birth.list.add(tmp);
      }
    }
  }
}

/**
* ajoute les naissances et les décès dans l'intervalle de temps
*/
void addPointsInMeantime(boolean forward){
  // si on avance
  if(forward)
  {
    for (Soldier s : allSoldiers.list) {
      // si la date de naissance est dans l'intervalle de temps, on rajoute le soldat à la liste des soldats à afficher
      if(s.dateNaissance.compareTo(formerDate) > 0 && s.dateNaissance.compareTo(currentDate) <= 0){
        //println("----> Naissance");
        if(!displayedSoldiers_birth.list.contains(s)) displayedSoldiers_birth.list.add(s);
      }
      // si la date de décès est dans l'intervalle de temps, on rajoute le soldat à la liste des soldats à afficher
      if(s.dateDeces.compareTo(formerDate) > 0 && s.dateDeces.compareTo(currentDate) <= 0){
        //println("----> Deces");
        if(!displayedSoldiers_death.list.contains(s))  displayedSoldiers_death.list.add(s);
      }
    }
  }
  // si on recule
  else{
    for (Soldier s : allSoldiers.list) {
    // si la date de naissance est dans l'intervalle de temps, on rajoute le soldat à la liste des soldats à afficher
      if(s.dateNaissance.compareTo(formerDate) > 0 && s.dateNaissance.compareTo(currentDate) <= 0){
        //println("----> Naissance");
        if(!displayedSoldiers_birth.list.contains(s)) displayedSoldiers_birth.list.add(s);
      }
      // si la date de décès est dans l'intervalle de temps, on rajoute le soldat à la liste des soldats à afficher
      if(s.dateDeces.compareTo(formerDate) > 0 && s.dateDeces.compareTo(currentDate) <= 0){
        //println("----> Deces");
        if(!displayedSoldiers_death.list.contains(s)) displayedSoldiers_death.list.add(s);
      }
    }
    // si on est pendant la guerre
    if(this.currentDate.compareTo(warDate) >= 0){
      for (Soldier s : displayedSoldiers_death.list) {
        if(!displayedSoldiers_birth.list.contains(s)) displayedSoldiers_birth.list.add(s);
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

/**
* suppression des matricules des soldats morts après la date courante
*/
void updateMatricules(){
  for (int i = matricules.list.size()-1; i >= 0; i--) {
    Soldier tmp = matricules.list.get(i);
    if(tmp.dateDeces.compareTo(currentDate) > 0) matricules.list.remove(tmp);
  }
}
