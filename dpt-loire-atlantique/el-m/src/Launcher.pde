PImage img;
int smallPoint, largePoint;
ArrayList<Coordinate> from;
ArrayList<Coordinate> to;
float scaleH = 15;
float scaleW = 15;

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
  
  from = new ArrayList<Coordinate>();
  
  //for(int i = 0; i < 10 ; i++){
  //  coords.add(new Coordinate(random(img.width), random(img.height)));
  //}
  
  // Paris
  from.add(new Coordinate(1, 48.85, 2.35));
  // Athènes
  from.add(new Coordinate(2, 37.97, 23.74));
  // centre de la carte
  from.add(new Coordinate(3, 42.7, 14.15));
  // pointe Sud Tunisie
  from.add(new Coordinate(4, 30.23, 9.56));
  // gauche
  from.add(new Coordinate(5, 42.7, -9.3));
  // droite
  from.add(new Coordinate(6, 42.7, 37.1));
  // haut
  from.add(new Coordinate(7, 56.39, 14.15));
  // gauche
  from.add(new Coordinate(8, 29.7, 14.15));
  
}

void draw() { 
  background(img);
  
  // parcours des coordonnées
  for (Coordinate c : from) {
    fill(255, 0, 0, 63);
    ellipse(c.getX()*img.width, c.getY()*img.height, 15, 15);
  }
  
  rect(50,50,50,50);
  fill(255);
  if(mousePressed){
    if(mouseX>50 && mouseX <50+50 && mouseY>50 && mouseY <50+50){
      println("pressed");
      addCoordinate();
    }
  }
  
  //delay(int(random(20)));
  //addCoordinate();
}

void addCoordinate(){
  from.add(new Coordinate(29.7 + random(56.39-29.7), -9.3+random(37.1-(-9.3))));
}
