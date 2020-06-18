/* ========================================================

   -----------------------------------------------------
   Übungen zu Kreatives Programmieren 4: SuperCollider 2
   -----------------------------------------------------

   Sitzung 07 - 03.03.2020

======================================================== */


class Cosine {
  
  int y1;
  int y2;
  int size;
  float[] init;
  
  // Constructor
  Cosine(int temp_y1, int temp_y2, int temp_size) {
    
    y1 = temp_y1;
    y2 = temp_y2;
    size = temp_size;
    
    init = new float[size];
  
    for (int i = 0; i < size; i++) {
      float amount = map(i, 0, size, 0, PI * 2);  // initializes to one full cycle
      init[i] = abs(cos(amount));  // just take positive values (for color space)
    }
  }
  
  void regular() {
    for (int i = 0; i < size; i++) {
      stroke(init[i] * 255);  // scale to color space
      line(i, y1, i, y2);
    }
  }
  
  void dark() {
    for (int i = 0; i < size; i++) {
      stroke((init[i] * 255) / 4);  // shrink color range
      line(i, y1, i, y2);
    }
  }
   
  void inverse() {
    for (int i = 0; i < size; i++) {
      stroke(255 - (init[i] * 255));  // invert cosine
      line(i, y1, i, y2);
    }
  }
}
