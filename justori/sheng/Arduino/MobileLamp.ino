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
  Serial.print("pos(");
  Serial.print(pos);
  Serial.print(") ; diff(");
  Serial.print(diff);
  Serial.println(")");
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
      Serial.print("a : ");
      setPos(visA);
      Serial.flush();
      break;
    case('b') : 
      Serial.print("b : ");
      setPos(visB);
      Serial.flush();
      break;
    case('c') : 
      Serial.print("c : ");
      setPos(visC);
      Serial.flush();
      break;
    case('d') : 
      Serial.print("d : ");
      setPos(visD);
      Serial.flush();
      break;
    case('z') : 
      Serial.print("z : ");
      setPos(zero);
      Serial.flush();
      break;
    default :
      delay(100);
      break;
  }
} 
