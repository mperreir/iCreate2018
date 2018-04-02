Date startDate = new Date(1850, 0, 0, 0, 0);
Date endDate = new Date(1920, 0, 0, 0, 0);

/**
* affiche les lieux de naissance
*/
void drawBirths(){
  for (Soldier s : displayedSoldiers_birth.list) {
    fill(51, 204, 255, 63);
    ellipse(s.xNaissance*width, s.yNaissance*height, 30, 30);
  }
}

/**
* affiche les lieux de mort
*/
void drawDeaths(){
  for (Soldier s : displayedSoldiers_death.list) {
    fill(255, 0, 0, 63);
    ellipse(s.xDeces*width, s.yDeces*height, 30, 30);
    // affiche une flèche partant du lieu de naissance vers le lieu de décès
    drawArrow(s.xNaissance*width, s.yNaissance*height, s.xDeces*width, s.yDeces*height);
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
    text(s.matricule, width-30, y); 
    pushStyle();
    stroke(102, 102, 102);
    line(width-30, y-5, width-5, y-5);
    popStyle();
    y+=10;
  }
}

/**
* affichage la frise chronologique
*/
void drawTimeline(){
  int interval = endDate.getYear() - startDate.getYear();
  fill(0, 0, 0, 63);
  float x = ((float(formerDate.getYear()-startDate.getYear())/interval) + (float(formerDate.getMonth())/11)*(1.0/interval))*width;
  rect(0, height-15, x, 15);
  triangle(x-8, height-25, x, height-15, x+8, height-25);
  drawDate(x);
}

/**
* affiche la date courante
*/
void drawDate(float x){
  textSize(32);
  float textWidth = textWidth(getDateAsString(currentDate));
  x = x + textWidth/2 > width ? x-textWidth : x - textWidth/2 < 0 ? x : x-textWidth/2;
  fill(102, 102, 102);
  text(getDateAsString(currentDate), x, height-30); 
}
