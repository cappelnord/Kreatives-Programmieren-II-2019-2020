/* ========================================================

   -----------------------------------------------------
   Übungen zu Kreatives Programmieren 4: SuperCollider 2
   -----------------------------------------------------

   Sitzung 06 - 27.05.2020

======================================================== */


// ----------------------------
// Wavetable editing proto-GUI
// ----------------------------


import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress supercollider;

int[] yCoords;
float smp;


void setup() {
  
  osc = new OscP5(this, 12000);
  supercollider = new NetAddress("127.0.0.1", 57120);
  
  size(500, 500);
  
  yCoords = new int[width];
  
  // initialize wavetable
  for (int i = 0; i < yCoords.length; i = i+1) {
    yCoords[i] = height/2;
  };
  
  noLoop();  
};


void draw() {
  background(0);

  stroke(255);
  strokeWeight(1.2);
  
  // draw updated wavetable
  for (int i = 0; i < yCoords.length; i = i+1) {
    point(i, yCoords[i]);
  };
};


void mouseDragged() {
  yCoords[mouseX] = mouseY;  // draw wave (set values) with mouse
  redraw();
};


void keyPressed() {
  
  OscMessage msg = new OscMessage("/waveCycle");
  
  // send updated wavetable to SC by pressing 's'
  if (key == 's') {
    for(int i = 0; i < yCoords.length; i = i+1) {
      smp = (((float(yCoords[i]) / height) * 2.0) - 1.0)  * -1.0;  // scale values to (-1, 1)
      msg.add(smp);
    };
    
    osc.send(msg, supercollider);
  };
};
