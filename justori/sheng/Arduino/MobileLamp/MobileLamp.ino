#include <Wire.h>
#include <Adafruit_MotorShield.h>


// Number of steps of the stepper
int stepsSpecs = 400;

// Relative positions of the several cameras and the origin (nb of steps)
int zero = 0, visA = 66, visB = 166, visC = 234, visD = 333;
int old_pos = 0;

// Message character
char received = 'z'; 

// Stepper setup
Adafruit_MotorShield AFMS = Adafruit_MotorShield(); 
Adafruit_StepperMotor *myMotor = AFMS.getStepper(stepsSpecs, 2);

// Set the stepper to a given position choosing the closest way
void setPos(int pos) {
  int diff = pos - old_pos;
  if(diff > stepsSpecs / 2) {
    diff -= stepsSpecs;
  } else if(diff < -stepsSpecs / 2) {
    diff += stepsSpecs;
  }
  if(diff >= 0)
    myMotor->step(diff, FORWARD, SINGLE);
  else
    myMotor->step(-diff, BACKWARD, SINGLE);
  old_pos = pos;
}

// Setup function (executed in first)
void setup() 
{ 
  // Setup the input messages serial port
  Serial.begin(9600);
  // Setup of the stepper controler
  AFMS.begin();
  myMotor->setSpeed(40); // Rotation Per Minute
}

// Loop function
void loop() {
  // Read a new instruction
  received = Serial.read();

  // Parse the message character
  switch(received) {
    // Camera 1
    case('a') : 
      // Focus on camera 1
      setPos(visA);
      // Flush the port to stay alert
      while(Serial.available()>1){Serial.read();};
      break;
    // Camera 2
    case('b') : 
      setPos(visB);
      while(Serial.available()>1){Serial.read();};
      break;
    // Camera 3
    case('c') :
      setPos(visC);
      while(Serial.available()>1){Serial.read();};
      break;
    // Camera 4
    case('d') : 
      setPos(visD);
      while(Serial.available()>1){Serial.read();};
      break;
    // No faces detected
    case('z') : 
      // Make a listtle rotation (continuously cycling while there is non face detected
      setPos((old_pos+stepsSpecs/5)%stepsSpecs);
      while(Serial.available()>1){Serial.read();};
      break;
    // Error or nothing
    default :
      // We flush and put some delay to avoid over-consumption
      while(Serial.available()>1){Serial.read();};
      delay(100);
      break;
  }
} 
