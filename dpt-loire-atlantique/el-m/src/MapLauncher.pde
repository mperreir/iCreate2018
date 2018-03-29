PImage img;
int smallPoint, largePoint;
ArrayList<Coordinate> coords;
float scaleH = 15;
float scaleW = 15;

// dans un vrai repère :
// -9.3 --> longitude gauche --> x = -6.67
// 37.1 --> longitude droite --> x = -6.67
// 29.7 --> latitude bas --> y = -6.67
// 56.39 --> latitude haut --> y = -6.67

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
  
  coords = new ArrayList<Coordinate>();
  
  //for(int i = 0; i < 10 ; i++){
  //  coords.add(new Coordinate(random(img.width), random(img.height)));
  //}
  
  // Paris
  coords.add(new Coordinate(48.85, 2.35));
  // Athènes
  coords.add(new Coordinate(37.97, 23.74));
  // centre de la carte
  coords.add(new Coordinate(42.7, 14.15));
  // pointe Sud Tunisie
  coords.add(new Coordinate(30.23, 9.56));
  // gauche
  coords.add(new Coordinate(42.7, -9.3));
  // droite
  coords.add(new Coordinate(42.7, 37.1));
  // haut
  coords.add(new Coordinate(56.39, 14.15));
  // gauche
  coords.add(new Coordinate(29.7, 14.15));
  
}

void draw() { 
  background(img);
  
  // parcours des coordonnées
  for (Coordinate c : coords) {
    fill(255, 0, 0, 63);
    ellipse(c.getX()*img.width, c.getY()*img.height, 5, 5);
    // ellipse(15, 50, 50, 50);
    // ellipse(50, 15, 50, 50);
  }
  
  //delay(int(random(20)));
  //addCoordinate();
}

void addCoordinate(){
  coords.add(new Coordinate(random(img.width), random(img.height)));
}
