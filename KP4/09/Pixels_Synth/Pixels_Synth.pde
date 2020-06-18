
void setup() {
  size(600, 600);
}

void draw() {
  background(0);
  
  float offset = millis() * 0.001;
  
  // Wir synthetisieren ein Bild direkt über die einzelnen Pixel ...
  // ... in Zukunft werden wir das mit Fragment-Shadern machen!
  
  loadPixels();
   for(int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {
      float red = map(x, 0, width, 0, 255);
      float green = map(y, 0, height, 0, 255);
      pixels[y*width + x] = color(red, green, abs(sin(y * 0.1 + offset)) * 256);
    }
  }
  updatePixels();
  
}
