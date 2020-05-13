/* ========================================================

   -----------------------------------------------------
   Übungen zu Kreatives Programmieren 4: SuperCollider 2
   -----------------------------------------------------

   Sitzung 02 - 29.04.2020

======================================================== */

/*

  Osc-messages are recieved from SuperCollider to control 
  the transparency and horizontal position of a circle in
  dependance of a sound source's amplitude and position in 
  the stereo field respectively.

*/

import oscP5.*;
import netP5.*;

int alpha = 0;
int hPos = 0;

OscP5 osc;


void setup() {
  
  osc = new OscP5(this, 12000); // define port for listening to osc-messages
  
  size(400, 400);
  noLoop();
}


void draw() {
  
  background(0);

  fill(255, 0, 0, alpha); // control transparency
  ellipse((width/2) + hPos, height/2, 50, 50); // control horizontal position
}


// function to recieve incomming osc messages

void oscEvent(OscMessage theOscMessage) {
  
  alpha = theOscMessage.get(0).intValue(); // get alpha value
  hPos = theOscMessage.get(1).intValue(); // get horizontal position
  
  redraw();
}

