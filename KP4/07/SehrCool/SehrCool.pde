// Java

// int : Ganzzahl
// float: Gleitkommazahl
// color: Farbe
// String: Zeichenketten
// void: Für Funktionen ohne Rückgabewert

int zaehler = 0;

int addiere(int a, int b) {
  int result = a + b;
  return result;
}

/*
Rückgabetyp Funktionsnamen(Argumente, Argumente) {
  [return ...]
}
*/

void setup() {
  int cool = addiere(10, 20);
  println("Älöllöölééé");
  println(cool);
}

void draw() {
    println("Hallo Welt!");
    // zaehler = zaehler + 1;
    zaehler++;
    println(zaehler);
}
