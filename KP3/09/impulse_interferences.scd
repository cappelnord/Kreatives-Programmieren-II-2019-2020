(
{
	var n = 2000;
	Splay.ar(n.collect {|i|
		Impulse.ar(10 + (0.0001 * i)) * (i%2==0).if(1, -1)
	});
}.play;
)
