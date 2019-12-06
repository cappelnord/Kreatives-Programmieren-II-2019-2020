// Sketch => Import Library => Add Library => Minim

import ddf.minim.*;

Minim minim;
AudioInput in;

void setup() {
  // Auflösung/Fenstergröße
  size(800, 800, P3D);
  minim = new Minim(this);
  
  in = minim.getLineIn(Minim.STEREO, 512);
  
  smooth();
  background(0);
  
  frameRate(60);
}

void draw() {
  blendMode(BLEND);
  noStroke();
  // 80 = Alpha; steuert wie viel vom alten
  // Bild beibehalten werden soll
  fill(0, 0, 0, 80); 
  rect(0, 0, width, height);
  
  blendMode(ADD);
  
  noFill();
  // RGB Farbe des Oszilloskops
  stroke(5, 128, 30);
  // Wie dick die Linie ist
  strokeWeight(4);
  
  for(int i = 1; i < in.bufferSize(); i++) {
    float x1 = map(in.left.get(i-1), -1.0, 1.0, 0, width);
    float y1 = map(in.right.get(i-1), -1.0, 1.0, 0, height);
    float x2 = map(in.left.get(i), -1.0, 1.0, 0, width);
    float y2 = map(in.right.get(i), -1.0, 1.0, 0, height);
    
    line(x1, y1, x2, y2);
  }
}
