 import oscP5.*;
 
OscP5 oscP5;
ArrayList<Double> recordSpeeds = new ArrayList<Double>();

/* Traitement des messages OSC reçus (envoyés par le téléphone) */
synchronized void oscEvent(OscMessage theOscMessage) {

  // On enregistre la vitesse angulaire sur l'axe y converti en dégrés
  double speedY = (Float) theOscMessage.arguments()[1] * 57.3;
  // La vitesse est positive si on tourne dans le bon sens
  recordSpeeds.add(new Double(speedY));
}

/* On sa base sur la moyenne des mouvements enregistrés entre les affichages */
synchronized double isRolling(){
  double total = 0.0;
  
  for(double record : recordSpeeds){
    total += record; 
  }
  
  double averageSpeed = total / recordSpeeds.size();
  recordSpeeds.removeAll(recordSpeeds);
  
  return averageSpeed; 
}
