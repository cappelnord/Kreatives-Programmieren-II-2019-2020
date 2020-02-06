// window, view
w = Window.new(); // container (special) / parent
// fill the window with gui stuff
CheckBox(w, Rect(20, 20, 20, 20)); // child
StaticText(w, Rect(50, 20, 100, 20)).string_("Learn about SC"); // child
w.front;

// container, parent, child
// CompositeView
(
var width, height;
width = 600;
height = 400;
w = Window.new("", Rect(450, 100, width, height));
c = CompositeView(w, Rect(0, 0, width / 2, height)).background = Color.rand;
CheckBox(c, Rect(20, 20, 20, 20)).string_("Learn about SC");
StaticText(c, Rect(50, 20, 100, 20)).string_("Learn about SC");
t = CompositeView(w, Rect(width / 2, 0, width / 2, height)).background = Color.rand;
TextField(t, Rect(20, 20, width / 2 - 40, height - 40));
w.front;
)
// resize

// decorator