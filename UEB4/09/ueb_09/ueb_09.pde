/* ========================================================

   ------------------------------------
   Übungen zu Kreatives Programmieren 4
   ------------------------------------

   Sitzung 09 - 17.06.2020

======================================================== */


int iter = 100;

int iX;
int iY;

int extendX = 15;
int extendY = 20;

float stretch = 0.8;

float inc = TWO_PI / iter;
float amp = 250.0;

PVector[] circle;


void setup() {

  //frameRate(10);

  size(800, 800, P3D);
  pixelDensity(displayDensity());
  smooth(8);

  iX = width / 2;
  iY = height / 2;

  circle = circularPath(iter, iX, iY, inc, amp);

  noLoop();
}


void draw() {
  
  //blendMode(ADD);

  background(0);

  PVector[] drunk = rndWalk(iter, iX, iY, extendX, extendY, stretch);

  for (int i = 0; i < iter; i++) {

    int rndVert = int(random(i, (iter - int(random(1, iter)))));  // experiment with constrained and nested randomness
    //int rndVertTwo = int(random(i, (iter - int(random(1, iter)))));
        
    /* --------- lines from circle to random walk --------- */
    
    stroke(255);
    strokeWeight(0.5);
    //line(circle[i].x, circle[i].y, drunk[i].x, drunk[i].y);
    line(circle[i].x, circle[i].y, drunk[rndVert].x, drunk[rndVert].y);
       
    /* --------- constructing polygons --------- */
    
    // Try experimenting by contructing polygons from vectors
    // defined by the circle and random walk functions.
    
    /*
    //noStroke();
    fill(0, int(random(0, 255)), 0, 30);
    
    beginShape();
      vertex(circle[i].x, circle[i].y);
      vertex(circle[rndVert].x, circle[rndVert].y);
      vertex(drunk[rndVertTwo].x, drunk[rndVertTwo].y);
    endShape();
    */
           
    // NOTE: You may want to check out "PShape" as a more flexible 
    // solution for generating custom shapes.
  }

  /* --------- line-trace random walk --------- */
  
  for (int i = 0; i < (iter - 1); i++) {

    stroke(255, 0, 255);
    strokeWeight(2.5);
    line(drunk[i].x, drunk[i].y, drunk[i + 1].x, drunk[i + 1].y);
  }
}


/* --------- press "n" to get new frame --------- */

void keyPressed() {
  if (key == 'n') {
    redraw();
  }
}


/* --------- random walk function --------- */

PVector[] rndWalk(int size, int x, int y, int extX, int extY, float mul) {

  PVector[] walk = new PVector[size];

  for (int i = 0; i < size; i++) {

    walk[i] = new PVector(x, y);
    x = x + (int(random(-extX, extX) * mul));
    y = y + (int(random(-extY, extY) * mul));
  }

  return walk;
}


/* --------- circle function --------- */

PVector[] circularPath(int size, int x, int y, float increment, float amplitude) {

  float angle = 0.0;
  float inc = increment;
  float amp = amplitude;

  PVector[] traj = new PVector[size];

  for (int i = 0; i < iter; i++) {

    traj[i] = new PVector(x + (sin(angle) * amp), y + (cos(angle) * amp));
    //traj[i] = new PVector(x + (sin(angle) * ((amp / iter) * i)), y + (cos(angle) * ((amp / iter) * i)));  // alternative for generating a spiral
    angle = angle + inc;
  }

  return traj;
} 
