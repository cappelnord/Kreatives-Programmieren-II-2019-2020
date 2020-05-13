/* ========================================================
 
   -----------------------------------------------------
   Übungen zu Kreatives Programmieren 4: SuperCollider 2
   -----------------------------------------------------

   Sitzung 03 - 06.05.2020
   
======================================================== */

/*

  Make a simple interface for controlling frequency and
  amplitude of a synth in SuperCollider through mouse 
  clicking and send control data via osc-messages.

*/

import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress supercollider;

int eHeight = 0;
int eWidth = 0;


void setup() {
  
  osc = new OscP5(this, 12000);
  supercollider = new NetAddress("127.0.0.1", 57120); // specify destination for osc-messages: 
                                                      // localhost & port number -> 57120 sclang's default port
  
  size(700, 700);
  noLoop();
}


void draw() {

  background(0);
  
  fill(255, 0, 0, 255);
  ellipse(eWidth, eHeight, 20, 20);

  OscMessage msg = new OscMessage("/freq_amp"); // create osc-message with path 
  msg.add(eWidth); // compose osc-message...
  msg.add(eHeight); // compose osc-message...
  msg.add(width); // compose osc-message...
  osc.send(msg, supercollider); // send osc-message
}


void mousePressed() {
    
  eWidth = mouseX;
  eHeight = mouseY;
  
  redraw();
}

