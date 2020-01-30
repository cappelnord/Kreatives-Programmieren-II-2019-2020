// GoL

Array.fill

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

			// nachbarn aufaddieren (modulo index --> spiegelung auf die andere seite)
			num_neighbors = num_neighbors + ~c[(row_index - 1) % size][(col_index - 1) % size];
			num_neighbors = num_neighbors + ~c[(row_index - 1) % size][ col_index            ];
			num_neighbors = num_neighbors + ~c[(row_index - 1) % size][(col_index + 1) % size];
			num_neighbors = num_neighbors + ~c[ row_index            ][(col_index - 1) % size];
			num_neighbors = num_neighbors + ~c[ row_index            ][(col_index + 1) % size];
			num_neighbors = num_neighbors + ~c[(row_index + 1) % size][(col_index - 1) % size];
			num_neighbors = num_neighbors + ~c[(row_index + 1) % size][ col_index            ];
			num_neighbors = num_neighbors + ~c[(row_index + 1) % size][(col_index + 1) % size];

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
		~print.value(~c);
		0.1.wait;
	}
}.fork;
)

// wiederholung: .do
100.do{|index| index.postln;}

(
[2, 6, 1000, 4].do{|item, index|
	[item, index].postln;
};
)

// wiederholung dictionary
(
1:[1, 2, 3],
2:[5, 6, 7],
6:[100]
)

q = ()
Dictionary
q[\key] = val
q.set(\key, val)

// modulo:
[-3, -2, -1, 0, 1, 2, 3, 4, 5, 6] % 17