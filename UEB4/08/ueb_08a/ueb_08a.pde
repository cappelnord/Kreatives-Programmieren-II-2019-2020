/* ========================================================

   -----------------------------------------------------
   Übungen zu Kreatives Programmieren 4: SuperCollider 2
   -----------------------------------------------------

   Sitzung 08 - 10.06.2020

======================================================== */


void setup() {
 
  //size(800, 800);
  
  size(800, 800, P3D);
  pixelDensity(displayDensity());
  smooth(8);
}

void draw() {
  
  background(0);


  /* -------- 1st grid -------- */
  
  grid(width, height, 100, 0, 255, 0);
 
 
  /* -------- 2nd grid -------- */
 
  pushMatrix();
    
    translate(150, 150);
    
    grid(width, height, 255, 255, 0, 0);
    
    strokeWeight(1.0);
    fill(255, 100);
    rect(0, 0, 100, 100);
  
  popMatrix();
  
  
  /* -------- 3rd grid -------- */
  
  translate(width / 2, height / 2);
  rotate(PI / 4);
  //rotate(PI * (mouseX / float(width)) * 2.0);
  rotateX(PI * (mouseX / float(width)) * 2.0);
  
  scale(0.5);
  
  grid(width, height, 255, 0, 0, 255);
  //grid_alt(width, height, 255, 0, 0, 255);
  
  strokeWeight(1.0);
  fill(255, 100);
  rect(50, 200, 100, 100);
  
}


// Function for constructing a regular grid along the x and y axis.
// Origin (0, 0) at the upper left corner of the gird

void grid(int x, int y, int stroke, int r, int g, int b) {
  
  //translate(50, 50);
  
  stroke(stroke);
  strokeWeight(0.5);
  
  for (int i = 0; i <= x; i += 20) {
    line(i, 0, i, y);
  }
  
  for (int i = 0; i <= y; i += 20) {
    line(0, i, x, i);
  }
  
  stroke(r, g, b, 100);
  strokeWeight(2.0);
  line(width / 2, 0, width / 2, height);
  line(0, height / 2, width, height / 2);
  
  stroke(r, g, b);
  strokeWeight(12);
  point(0, 0);
}


// Alternative Function for constructing a regular grid along the x and y axis.
// Origin (0, 0) at the center of the gird

void grid_alt(int x, int y, int stroke, int r, int g, int b) {
  
  //translate(50, 50);
  
  stroke(stroke);
  strokeWeight(0.5);
  
  for (int i = 0; i <= x; i += 20) {
    line(i -(width / 2), -(height / 2), i - (width / 2), height / 2);
  }
  
  for (int i = 0; i <= y; i += 20) {
    line(-(width / 2), i - (height / 2), width / 2, i - (height / 2));
  }
  
  stroke(r, g, b, 100);
  strokeWeight(2.0);
  line(0, -(height / 2), 0, height / 2);
  line(-(width / 2), 0, width / 2, 0);
  
  stroke(r, g, b);
  strokeWeight(12);
  point(0, 0);
}
