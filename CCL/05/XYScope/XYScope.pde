// Sketch => Import Library => Add Library => Minim

import ddf.minim.*;

Minim minim;
AudioInput in;

void setup() {
  size(800, 800);
  minim = new Minim(this);
  
  in = minim.getLineIn(Minim.STEREO, 512);
  
  smooth();
  
}

void draw() {
  background(0);
  
  stroke(0, 255, 20);
  strokeWeight(4);
  
  for(int i = 1; i < in.bufferSize(); i++) {
    float x1 = map(in.left.get(i-1), -1.0, 1.0, 0, width);
    float y1 = map(in.right.get(i-1), -1.0, 1.0, 0, height);
    float x2 = map(in.left.get(i), -1.0, 1.0, 0, width);
    float y2 = map(in.right.get(i), -1.0, 1.0, 0, height);
    
    line(x1, y1, x2, y2);
  }
}
