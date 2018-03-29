// Initialization
final int nbCircle = 40;
final int nbCircleFull = 5;
final int border = 50;
final int sizeTickList = 10;
Circle[] listCircles = new Circle[nbCircle];
Circle[] listCirclesFull = new Circle[nbCircleFull];
MainCircle mc = null;
String theme = getTheme();
Leap leap = new Leap();
LinkedList<Vector> positionList = new LinkedList<Vector>();

// Transitions
final int waitSlow = 180;
final int waitExplosion = 45;
final int waitAppear = 30;
int timerSlow = 0;
int timerExplosion = 0;
int timerAppear = 0;

// Swipe
final int entropyCoef = 1500;

// Hand detection
// The coef of progression about of much the speed is accelerating (linear)
float speedProgressionCoef = 1;
// The speed coef that we want to reach
float speedCoef = 50;
// The current speed coef
float currentSpeedCoef = speedCoef;
// Check if we have reached the speedCoef based on our currentSpeedCoef
boolean reach = true;
// Check if the speedCoef is higher or not that our current speed (in others words, check if we are accelerating or deccelelerating)
boolean higher = true;
float coefSpeedY = 4;

// Hover
final float sizeProgressionCoef_f = 5;
final float sizeExpansionCoef_f = 1;
final float sizeCurrentCoef_f = 1;
final float sizeTopCoef_f = 100;
boolean g_hover = false;

// Explosion
boolean explosion = false;

// Tests
// Test var for accelerating/deccelerating every x frames
boolean enableTest = false;
int tmpTestTime = 100;
int tmpTestCurrent = 0;
int tmpTestTimeStop = 300;
// Test var for mouse hover
boolean enableTestSize = false;
int tmpTestTimeSize = 50;
int tmpTestCurrentSize = 0;
int tmpTestTimeSizeStop = 100;
// Test var for accelerating/deccelerating every x frames
boolean enableTestExplosion = false;
int tmpTestTimeExplosion = 50;
int tmpTestCurrentExplosion = 0;
int tmpTestTimeExplosionStop = 100;
