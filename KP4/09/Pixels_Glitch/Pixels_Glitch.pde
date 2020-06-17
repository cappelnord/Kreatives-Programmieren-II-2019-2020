PImage img;

void setup() {
  size(600, 600);

  // needed for line examples when using P3D
  // hint(DISABLE_DEPTH_TEST);

  img = loadImage("pilze.jpg");
  smooth();
  
  img.loadPixels();
  noLoop();
}

void draw() {
  background(0);

  // Pixel-Glitch beim Kopieren von einem Array eines Bildes
  // in anderen mit verschiedener Breite ...
  
  loadPixels();
  for(int i = 0; i < width*height; i++) {
    pixels[i] = img.pixels[i];
  }
  updatePixels();
}
