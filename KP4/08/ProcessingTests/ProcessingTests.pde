float circleSize = 200;
float offset = 50;

PImage schimmel;

void setup() {
  size(400, 400, P3D );
  
  smooth();
  frameRate(30);
  
  schimmel = loadImage("schimmel.png");
}

void draw() {
  background(0);  
  noStroke();
  
  circleSize = map(mouseX, 0, width, 20, 300);
  offset = map(mouseY, 0, height, 20, 200);
  
  blendMode(ADD);
  fill(255, 0, 0);
  ellipse(width/2, height/2 - offset, circleSize, circleSize);
  
  fill(0, 255, 0);
  ellipse(width/2 - offset, height/2 + offset, circleSize, circleSize);
  
  fill(0, 0, 255);
  ellipse(width/2 + offset, height/2 + offset, circleSize, circleSize);

  tint(255, 20);
  blendMode(MULTIPLY);
  image(schimmel, -300, -100);
}
