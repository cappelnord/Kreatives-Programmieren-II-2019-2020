PImage img;

void setup() {
  size(600, 600);

  // needed for line examples when using P3D
  // hint(DISABLE_DEPTH_TEST);

  img = loadImage("pilze.jpg");
  smooth();
  
  noLoop();
}

void draw() {
  background(0);

  // Wir passen die Helligkeit des gezeichneten Bildes nachträglich
  // an indem wir die Farbwerte aller Pixel halbieren.

  image(img, 0, 0);
  
  loadPixels();
  for(int i = 0; i < width*height; i++) {
      color c = pixels[i];
      float b = 0.5;
      c = color(red(c) * b, green(c) * b, blue(c) * b);
      pixels[i] = c;   
  }
  updatePixels();
  
}
