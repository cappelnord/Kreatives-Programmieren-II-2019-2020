PImage img;

void setup() {
  size(600, 600, P3D);

  // needed for line examples when using P3D
  hint(DISABLE_DEPTH_TEST);

  img = loadImage("pilze.jpg");
  smooth();
  
  img.loadPixels();
  noLoop();
}

void draw() {
  background(0);

   
   int xHop = 10;
   int yHop = 1;
   
  blendMode(ADD);
  stroke(64);
  
  for(int y = 0; y < img.height; y = y + yHop) {
    float lastX = 0;
    float lastY = y;
    for(int x = 0; x < img.width; x = x + xHop) {
      color c = img.pixels[y*img.width+x];      
      float yOffset = brightness(c) * 0.1;
      
      float thisX = x;
      float thisY = y + yOffset;
      
      line(thisX, thisY, lastX, lastY);
      
      lastX = thisX;
      lastY = thisY;
    }
  }
  
  int hop = 5; 
  blendMode(BLEND);
   
  noStroke();

  for(int y = 0; y < img.height; y = y + hop) {
    for(int x = 0; x < img.width; x = x + hop) {
      color c = img.pixels[y*img.width+x];
      fill(c);
      
      if(red(c) * 1.1 > green(c) + blue(c) && brightness(c) > 120) {      
        circle(x, y, brightness(c) *0.2);
      }
    }
  }
  
}
