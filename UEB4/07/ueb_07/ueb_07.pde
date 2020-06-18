/* ========================================================

   -----------------------------------------------------
   Übungen zu Kreatives Programmieren 4: SuperCollider 2
   -----------------------------------------------------

   Sitzung 07 - 03.03.2020

======================================================== */


// ------------------------------------------------------
// Adaption of Processing's "Array example" with classes 
// ------------------------------------------------------


Cosine cosOne, cosTwo, cosThree;


void setup() {
  
  size(640, 360);
  background(255);
  
  noLoop();
}



void draw() {

  int y1 = 0;
  int y2 = height/3;
  
  cosOne = new Cosine(y1, y2, width);
  cosOne.regular();

  y1 = y2;
  y2 = y1 + y1;
  
  cosTwo = new Cosine(y1, y2, width);
  cosTwo.dark();
  
  y1 = y2;
  y2 = height;
  
  cosThree = new Cosine(y1, y2, width);
  cosThree.inverse();
  
}
