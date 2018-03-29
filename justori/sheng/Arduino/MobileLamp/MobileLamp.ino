#include <Wire.h>
#include <Adafruit_MotorShield.h>


// Vitesses
int stepsSpecs = 400;
int zero = 0, visA = 66, visB = 166, visC = 234, visD = 333;
int old_pos = 0;
char received = 'z'; 
Adafruit_MotorShield AFMS = Adafruit_MotorShield(); 
Adafruit_StepperMotor *myMotor = AFMS.getStepper(stepsSpecs, 2);

// Set to a good position choosing the closest way
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

void setup() 
{ 
  Serial.begin(9600);
  AFMS.begin();
  myMotor->setSpeed(40); // RPM
}

void loop() {
  received = Serial.read();
  switch(received) {
    case('a') : 
      setPos(visA);
      while(Serial.available()>1){Serial.read();};
      break;
    case('b') : 
      setPos(visB);
      while(Serial.available()>1){Serial.read();};
      break;
    case('c') : 
      setPos(visC);
      while(Serial.available()>1){Serial.read();};
      break;
    case('d') : 
      setPos(visD);
      while(Serial.available()>1){Serial.read();};
      break;
    case('z') : 
      setPos((old_pos+stepsSpecs/5)%stepsSpecs);
      while(Serial.available()>1){Serial.read();};
      break;
    default :
      while(Serial.available()>1){Serial.read();};
      delay(100);
      break;
  }
} 
