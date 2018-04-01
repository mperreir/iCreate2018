 import oscP5.*;
 
/*
Varaibles d'ajustement pour détecter au mieux le mouvement
-----------------------------------------------------------------------
treshold:
Définit un seuil (pour la vitesse angulaire) à partir duquel la manivelle 
est considérée comme tournant (ignorer les micro mouvements)

*/
double treshold = 40;
 
OscP5 oscP5;
ArrayList<Double> recordSpeeds = new ArrayList<Double>();


/* Traitement des messages OSC reçus (envoyés par le téléphone) */
synchronized void oscEvent(OscMessage theOscMessage) {

  // On enregistre la vitesse angulaire sur l'axe y convetie en dégrés
  double speedY = (Float) theOscMessage.arguments()[1] * 57.3;
  // La vitesse est positive si on tourne dans le bon sens
  recordSpeeds.add(new Double(speedY));
}

/* On sa base sur la moyenne des mouvements enregistrés entre les affichages */
synchronized boolean isRolling(){
  double total = 0.0;
  
  for(double record : recordSpeeds){
    total += record; 
  }
  
  double averageSpeed = total / recordSpeeds.size();
  recordSpeeds.removeAll(recordSpeeds);
  
  return averageSpeed > treshold;
}
