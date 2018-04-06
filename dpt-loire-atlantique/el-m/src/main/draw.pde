Date startDate = new Date(1860, 0, 0, 0, 0);
Date endDate = new Date(1920, 0, 0, 0, 0);

/**
* affiche les lieux de naissance
*/
void drawBirths(){
  for (Soldier s : displayedSoldiers_birth.list) {
    fill(0, 0, 255, 63);
    ellipse(s.xNaissance*width, s.yNaissance*height, 20, 20);
  }
}

/**
* affiche les lieux de mort
*/
void drawDeaths(){
  for (Soldier s : displayedSoldiers_death.list) {
    fill(255, 0, 0, 255);
    ellipse(s.xDeces*width, s.yDeces*height, 20, 20);
    // affiche une flèche partant du lieu de naissance vers le lieu de décès
    drawArrow(s.xNaissance*width, s.yNaissance*height, s.xDeces*width, s.yDeces*height);
  }
}

/**
* dessine une flèche de (x1, y1) vers (x2, y2)
*/
void drawArrow(float x1, float y1, float x2, float y2) {
  pushStyle();
  stroke(0, 0, 0, 63);
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
  int col = 1;
  int li = 1;
  for (Soldier s : matricules.list) {
    textSize(10);
    // si on arrive à la fin de la simulation
    if(currentDate.getYear() == 1919) fill(102, 102, 102, 200);
    else fill(102, 102, 102, 20+random(180));
    text(s.matricule, width-(30*col), li*20);
    pushStyle();
    stroke(102, 102, 102);
    //line(width-30, y-5, width-5, y-5);
    popStyle();
    if((li+1)*6 > height){
      col++;
      li = 1;
    }
    else li++;
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
