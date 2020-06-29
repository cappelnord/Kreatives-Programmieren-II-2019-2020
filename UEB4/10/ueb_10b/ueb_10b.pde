/* ========================================================

   ------------------------------------
   Übungen zu Kreatives Programmieren 4
   ------------------------------------

   Sitzung 10 - 24.06.2020

======================================================== */


// ------------------
//  Simple a/v synth 
// ------------------


import ddf.minim.*;

Minim minim;
AudioInput in;

float[][] tmp_buffer; 

void setup() {
  
  size(512, 512, P3D);
  pixelDensity(displayDensity());
  smooth(8);
  
  println(pixelWidth, pixelHeight); // get effective number of pixels to match audio buffer size
  
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 1024);
  in.enableMonitoring();
  
  tmp_buffer = new float[1024][2];
}


void draw() {
  
  background(0);
 
  // copy audio buffer to temporary array to match frame and avoid discontinuities
  for (int i = 0; i < in.bufferSize(); i++) {

    tmp_buffer[i][0] = in.left.get(i);
    tmp_buffer[i][1] = in.right.get(i);
  }
  
  loadPixels();
  
    for(int y = 0; y < pixelHeight; y++) {
      for(int x = 0; x < pixelWidth; x++) {
      
        //float red = map(in.left.get(x), -1.0, 1.0, 0, 255); // read directly from audio buffer
        float red = map(tmp_buffer[x][1], -1.0, 1.0, 0, 255);
      
        //float blue = map(in.left.get(y), -1.0, 1.0, 0, 255); // read directly from audio buffer      
        float blue = map(tmp_buffer[y][0], -1.0, 1.0, 0, 255);
      
        pixels[(y * pixelWidth) + x] = color(red, 0, blue);
      }
    }
  
  updatePixels();
}
