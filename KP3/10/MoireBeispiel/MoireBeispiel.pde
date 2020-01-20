void setup() {
  size(800, 800, P3D);
  smooth();
}

void draw() {  
  background(0);
  int stepSize = 8;
  stroke(255);
  noFill();
  
  strokeWeight(2);
  
  for(int y = 0; y < height; y = y + stepSize) {
    line(0, y, width, y);
    // ellipse(width/2, height/2, y*2, y*2);
  }
  
  pushMatrix();
  translate(width/2, height/2);
  rotateZ(map(mouseX, 0, width, -PI/2.0, PI/2.0));
  rotateX(map(mouseY, 0, height, -PI/2.0, PI/2.0));
  translate(-width/2, -height/2);
  
  for(int x = -width; x < width*2; x = x + stepSize) {
    line(x, -height, x, height*2);
  }
  
  popMatrix();
}
