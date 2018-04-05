import netP5.*;
import oscP5.*;

import netP5.*;
import oscP5.*;

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

// Sound
OscP5 oscp;
NetAddress addr;
OscMessage mess;


// Counter
int counterZ = 0;
char lastC = 'z';
char lastSent = '0';

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

  ardPort = new Serial(this, portNames[1], 9600);

  // Sound setup
  oscp = new OscP5(this, 9001);
  addr = new NetAddress("192.168.1.5", 9002);

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
  cam1 = new Capture(this, 640/2, 480/2, cameras[64]);
  ocv1 = new OpenCV(this, 640/2, 480/2);
  ocv1.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
  cam1.start();
  cam2 = new Capture(this, 640/2, 360/2, cameras[4]);
  ocv2 = new OpenCV(this, 640/2, 360/2);
  ocv2.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
  cam2.start();
  cam3 = new Capture(this, 640/2, 480/2, cameras[49]);
  ocv3 = new OpenCV(this, 640/2, 480/2);
  ocv3.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
  cam3.start();
  cam4 = new Capture(this, 640/2, 480/2, cameras[19]);
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
      if(lastSent != 'a') {
        mess = new OscMessage("/oscICreate");
        mess.add(1);
        oscp.send(mess,addr);
        lastSent = 'a';
      }
      counterZ = 0;
    }
    lastC = 'a';
    println("1"); 
  }
  else if(faces2.length > 0) {
    if(lastC == 'b') {
      ardPort.write('b');
      if(lastSent != 'b') {
        mess = new OscMessage("/oscICreate");
        mess.add(2);
        oscp.send(mess,addr);
        lastSent = 'b';
      }
      counterZ = 0;
    }
    lastC = 'b';
    println("2"); 
  }
  else if(faces3.length > 0) {
    if(lastC == 'c') {
      ardPort.write('c');
      if(lastSent != 'c') {
        mess = new OscMessage("/oscICreate");
        mess.add(3);
        oscp.send(mess,addr);
        lastSent = 'c';
      }
      counterZ = 0;
    }
    lastC = 'c';
    println("3"); 
  }
  else if(faces4.length > 0) {
    if(lastC == 'd') {
      ardPort.write('d');
      if(lastSent != 'd') {
        mess = new OscMessage("/oscICreate");
        mess.add(4);
        oscp.send(mess,addr);
        lastSent = 'd';
      }
      counterZ = 0;
    }
    lastC = 'd';
    println("4"); 
  }
  else {
    if(lastC == 'z') {
      if (counterZ >= 11) {
        ardPort.write('z');
        if(lastSent != 'z') {
          mess = new OscMessage("/oscICreate");
          mess.add(0);
          oscp.send(mess,addr);
          lastSent = 'z';
        }
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
