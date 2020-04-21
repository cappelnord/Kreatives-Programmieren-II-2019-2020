// current array
~c = Array.fill2D(35, 35, {0.5.coin.asInt});

(
~print = {
	arg array;
	array.do{
		arg row;
		row.do{
			|item|
			item.asBoolean.if({"+".post;}, {"-".post});
			" ".post;
		};
		"".postln;
	};
	"".postln;
};
)

~print.value(~c);

(
~copyArray = {
	arg current_array;
	var size = current_array.size;
	~n = Array.fill2D(size, size, {0});
	current_array.do{
		|row, row_index|
		row.do{
			|item, col_index|
			~n[row_index][col_index] = current_array[row_index][col_index];
		};
	};
	~n
};
)

~copyArray.value(~c);

// next array
~n
~c

// test
~n[0][0] = 0;



// regeln
// anzahl der nachbarn
// n < 2 --> 0
// n > 3 --> 0
// n == 3 --> 1
// n == 2 || n == 3 --> 1

(
~nextGen = {
	var size = ~c.size;
	~c.do{
		|row, row_index|
		row.do{
			|item, col_index|
			var num_neighbors = 0;

			3.do{
				arg r;
				r = r - 1;
				3.do{
					arg c;
					c = c - 1;
					// ((r == 0) && (c == 0)).not.if({
					num_neighbors = num_neighbors + ~c[(row_index + r) % size][(col_index + c) % size];
					// });
				};
			};
			num_neighbors = num_neighbors - ~c[row_index][col_index];


			// copy each array-value to each button value
			{~buttons[row_index][col_index].value = ~c[row_index][col_index]}.defer(0);

			// regeln
			((~c[row_index][col_index] == 1) && ((num_neighbors < 2) || (num_neighbors > 3))).if{
				~n[row_index][col_index] = 0;
			};
			((~c[row_index][col_index] == 0) && (num_neighbors == 3)).if({
				~n[row_index][col_index] = 1;
			});
		};
	};
	// copy next to current
	~n.do{
		|row, row_index|
		row.do{
			|item, col_index|
			~c[row_index][col_index] = ~n[row_index][col_index];
		};
	};
};
)

(
{
	inf.do{
		~nextGen.value;
		// ~print.value(~c);
		0.1.wait;
	}
}.fork;
)


(
var size, buttonSize;
size = ~c.size;
buttonSize = 20;
w = Window.new("Game of Life", Rect(100, 100, size * buttonSize, size * buttonSize)).alwaysOnTop = true;
~buttons = Array.fill2D(size, size, {
	arg r, c;
	Button(w, Rect(r * buttonSize, c * buttonSize, buttonSize, buttonSize))
	.states_([
		["", Color.black, Color.black],
		["", Color.white, Color.white]
	])
	.action_({
		arg button;
		~c[r][c] = button.value;
	});
});
w.front;
)