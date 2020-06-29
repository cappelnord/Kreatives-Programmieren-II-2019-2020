/* ========================================================

   ------------------------------------
   Übungen zu Kreatives Programmieren 4
   ------------------------------------

   Sitzung 10 - 24.06.2020

======================================================== */


// ---------------------
//  Simple oscilloscope 
// ---------------------


import ddf.minim.*;

Minim minim;
AudioInput in;

void setup() {

  size(600, 600, P3D);
  pixelDensity(displayDensity());
  smooth(8);
  
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  in.enableMonitoring();
}

void draw() {

  background(0);  

  noFill();
  stroke(255);
  strokeWeight(2);
  
  for(int i = 1; i < in.bufferSize() - 1; i++) {
    
    /*---- STANDARD ----*/
    
    float sigL_x1 = map(i - 1, 1, in.bufferSize() - 1, 0, width);
    float sigL_x2 = map(i, 1, in.bufferSize() - 1, 0, width);    
    float sigL_y1 = map(in.left.get(i-1), -1.0, 1.0, 0, (height / 2) - 100);
    float sigL_y2 = map(in.left.get(i), -1.0, 1.0, 0, (height / 2) - 100);
    
    // one channel center
    //line(sigL_x1, sigL_y1 + ((height / 2) + 100) / 2, sigL_x2, sigL_y2  + ((height / 2) + 100) / 2);
    
    line(sigL_x1, sigL_y1 + 50, sigL_x2, sigL_y2 + 50);
    
    float sigR_x1 = map(i - 1, 1, in.bufferSize() - 1, 0, width);
    float sigR_x2 = map(i, 1, in.bufferSize() - 1, 0, width);    
    float sigR_y1 = map(in.right.get(i-1), -1.0, 1.0, 0, (height / 2) - 100);
    float sigR_y2 = map(in.right.get(i), -1.0, 1.0, 0, (height / 2) - 100);
    
    line(sigR_x1, sigR_y1 + 50 + (height / 2), sigR_x2, sigR_y2 + 50 + (height / 2));
    
    
    /*---- XY ----*/
    
    /*
    float x1 = map(in.left.get(i-1), -1.0, 1.0, 0, width);
    float y1 = map(in.right.get(i-1), -1.0, 1.0, 0, height);
    float x2 = map(in.left.get(i), -1.0, 1.0, 0, width);
    float y2 = map(in.right.get(i), -1.0, 1.0, 0, height);
    
    line(x1, y1, x2, y2);
    */
       
  }
}
