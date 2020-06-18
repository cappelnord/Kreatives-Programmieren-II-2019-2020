/* ========================================================

   -----------------------------------------------------
   Übungen zu Kreatives Programmieren 4: SuperCollider 2
   -----------------------------------------------------

   Sitzung 08 - 10.06.2020

======================================================== */


int num = 200;
float angle = 0;
int[][] colors;


void setup() {
 
  //size(800, 800);
  
  size(800, 800, P3D);
  pixelDensity(displayDensity());
  smooth(8);
  
  rectMode(CENTER);

  // Fill a 2D Array with random RGB values for coloring our rectangles
  
  colors = new int[num][3];

  for (int i = 0; i < num; i++) {
    for (int j = 0; j < 3; j++) { 
      colors[i][j] = int(random(0, 255));
    }
  }
}


void draw() {

  background(255);
  blendMode(SUBTRACT);

  translate(width / 2, height / 2);

  for (int i = 0; i < num; i++) {
    scale(0.95);
    rotate(radians(angle));

    fill(colors[i][0], colors[i][1], colors[i][2], (255 / num) * i);
    rect(0, 0, 700, 700);

    fill(255);
    ellipse(width / 2, 0, 100, 100);
  }

  angle += 0.1;
}
