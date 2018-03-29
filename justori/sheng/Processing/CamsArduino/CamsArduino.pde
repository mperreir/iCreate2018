import gab.opencv.*;
import processing.video.*;
import processing.serial.*;
import java.awt.*;

Serial ardPort;  // Arduino Port

// Webcams
Capture cam1;
Capture cam2;
Capture cam3;
Capture cam4;

OpenCV ocv1;
OpenCV ocv2;
OpenCV ocv3;
OpenCV ocv4;

// Counter
int counterZ = 0;
int lastC = 'z';

void setup() {
  
  // Arduino setup
  String[] portNames = Serial.list();
  if (portNames.length == 0) {
    println("There are no ports available for arduino.");
    exit();
  } else {
    println("Available serial ports :");
    for (int i = 0; i < portNames.length; i++) {
      println(i + " :: " + portNames[i]);
   }
  }

  ardPort = new Serial(this, portNames[5], 9600);

  // Webcams setup
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + " :: " + cameras[i]);
    }
  }
    
  // The camera can be initialized directly using an 
  // element from the array returned by list():
  cam1 = new Capture(this, 640/2, 480/2, cameras[4]);
  ocv1 = new OpenCV(this, 640/2, 480/2);
  ocv1.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
  cam1.start();
  cam2 = new Capture(this, 640/2, 360/2, cameras[19]);
  ocv2 = new OpenCV(this, 640/2, 360/2);
  ocv2.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
  cam2.start();
  cam3 = new Capture(this, 640/2, 480/2, cameras[49]);
  ocv3 = new OpenCV(this, 640/2, 480/2);
  ocv3.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
  cam3.start();
  cam4 = new Capture(this, 640/2, 480/2, cameras[64]);
  ocv4 = new OpenCV(this, 640/2, 480/2);
  ocv4.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
  cam4.start();
}

void draw() {
  ocv1.loadImage(cam1);
  ocv2.loadImage(cam2);
  ocv3.loadImage(cam3);
  ocv4.loadImage(cam4);
  
  Rectangle[] faces1 = ocv1.detect();
  Rectangle[] faces2 = ocv2.detect();
  Rectangle[] faces3 = ocv3.detect();
  Rectangle[] faces4 = ocv4.detect();

  if(faces1.length > 0) {
    if(lastC == 'a') {
      ardPort.write('a');
      counterZ = 0;
    }
    lastC = 'a';
    println("1"); 
  }
  else if(faces2.length > 0) {
    if(lastC == 'b') {
      ardPort.write('b');
      counterZ = 0;
    }
    lastC = 'b';
    println("2"); 
  }
  else if(faces3.length > 0) {
    if(lastC == 'c') {
      ardPort.write('c');
      counterZ = 0;
    }
    lastC = 'c';
    println("3"); 
  }
  else if(faces4.length > 0) {
    if(lastC == 'd') {
      ardPort.write('d');
      counterZ = 0;
    }
    lastC = 'd';
    println("4"); 
  }
  else {
    if(lastC == 'z') {
      if (counterZ >= 11) {
        ardPort.write('z');
      }
      else {
        counterZ++;
      }
    }
    lastC = 'z';
    println("0");
  }
}

void captureEvent(Capture c) {
  c.read();
}
