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

// Image processing tools
OpenCV ocv1;
OpenCV ocv2;
OpenCV ocv3;
OpenCV ocv4;

// Osc communication with PureData for sound instructions
OscP5 oscp;
NetAddress addr;
OscMessage mess;



int counterZ = 0;
char lastC = 'z';
char lastSent = '0';

// Setup function (executed in first place)
void setup() {
  // Arduino setup
  String[] portNames = Serial.list();
  if (portNames.length == 0) {
    println("There are no ports available for arduino.");
    exit();
  } else {
    // We print the avaliable outputs to choose one if it doesn't work (you may restart the application)
    println("Available serial ports :");
    for (int i = 0; i < portNames.length; i++) {
      println(i + " :: " + portNames[i]);
   }
  }
  
  // ----- You can choose the arduino port by changing the indice of portNames[i] -----
  ardPort = new Serial(this, portNames[1], 9600); 

  // Sound communication setup
  oscp = new OscP5(this, 9001);
  addr = new NetAddress("127.0.0.1", 9002);

  // Webcams setup
  String[] cameras = Capture.list();
  
  // Again here we print the avaliable webcams to help choosing the right ones afterwards
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + " :: " + cameras[i]);
    }
  }
   
  // ----- You can choose the right cameras by changing the indices of cameras[i] -----
  cam1 = new Capture(this, 640/2, 480/2, cameras[4]);
  ocv1 = new OpenCV(this, 640/2, 480/2);
  ocv1.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
  cam1.start();
  cam2 = new Capture(this, 640/2, 360/2, cameras[19]);
  ocv2 = new OpenCV(this, 640/2, 360/2);
  ocv2.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
  cam2.start();
  cam3 = new Capture(this, 640/2, 480/2, cameras[34]);
  ocv3 = new OpenCV(this, 640/2, 480/2);
  ocv3.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
  cam3.start();
  cam4 = new Capture(this, 640/2, 480/2, cameras[49]);
  ocv4 = new OpenCV(this, 640/2, 480/2);
  ocv4.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
  cam4.start();
}

// We don't really use the draw part but we use it as a loop function
void draw() {
  // We get the new image from the cameras
  ocv1.loadImage(cam1);
  ocv2.loadImage(cam2);
  ocv3.loadImage(cam3);
  ocv4.loadImage(cam4);
  
  // We detect the faces in it
  Rectangle[] faces1 = ocv1.detect();
  Rectangle[] faces2 = ocv2.detect();
  Rectangle[] faces3 = ocv3.detect();
  Rectangle[] faces4 = ocv4.detect();

  // Here we test for each cameras wich one may have seen a face, the treatmentt is the same for each cam so we
  // will detail only cam1 treatment
  // Cam 1
  if(faces1.length > 0) {
    // We use this test to avoid a fleeting fake positive (if 2 frames are positive, it's considered as a real detection)
    if(lastC == 'a') {
      // We send the command to the arduino for it to highlight the camera 1
      ardPort.write('a');
      // This test is to avoid sending twice the same command to the sound system 
      if(lastSent != 'a') {
        // We send an osc message to the PureData application
        mess = new OscMessage("/oscICreate");
        mess.add(1);
        oscp.send(mess,addr);
        lastSent = 'a';
      }
      counterZ = 0;
    }
    lastC = 'a';
  }
  // Cam 2
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
  }
  // Cam 3
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
  }
  // Cam 4
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
  }
  // If there is no face detected at all
  else {
    if(lastC == 'z') {
      // We want to let a few frames to the user to get his face capted again before stopping the tale
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
  }
}

void captureEvent(Capture c) {
  c.read();
}
