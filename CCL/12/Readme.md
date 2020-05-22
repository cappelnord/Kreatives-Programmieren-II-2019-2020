# Glitch-Practices

## Software

- [Audacity](https://www.audacity.de/)

- [WSL](https://docs.microsoft.com/de-de/windows/wsl/install-win10) for access to unix tools on Windows

- [ffmpeg](https://ffmpeg.org/download.html) (command line program)

  - on MacOS installation via [brew](https://brew.sh/) 
     `brew install ffmpeg` after installing brew
     
  - on Linux via `sudo apt install ffmpeg`

## Practical Part

### 'i am sitting in a mp3'

Based on Alvin Lucier's [I Am Sitting In A Room]([https://www.youtube.com/watch?v=fAxHlLK3Oyk](https://www.youtube.com/watch?v=fAxHlLK3Oyk)), we want to take an mp3-sound file and recursively compress it using the mp3-encoder again and again.

For that you first need a (preferably short) mp3-file.

Place it in a directory you want to be working in.

Also create a new folder called `out` for our output files, as we will create lots of audio files and we don't want to mess up our folder.

Now open nano (or any text editor of your choice) to write the following shell-script:

```
#! /bin/sh

f=./yourfile.mp3

for i in {1..99}
do
	ffmpeg -i $f -af loudnorm=I=-16:TP=-1.5:LRA=11 ./out/youroutputfile$i.mp3
	# alternative, if you don't have 'loudnorm':
	# ffmpeg -i $f ./out/youroutputfile$i.mp3
	
	f=./out/youroutputfile$i.mp3
	echo "written to $f"
done
```

Save this file as `yourshellscriptfilename.sh` by typing `Ctrl-O` in nano.

Then, in the terminal run:
`bash yourshellscriptfilename.sh`

or: 

`chmod +x yourshellscriptfilename.sh`
and then:
`./yourshellscriptfilename.sh`

  Your `out` folder should now be full with mp3-files numbered from 1-99. Can you hear the artifacts of the recursively applied mp3-compression?

### Used Commands:

- `echo`:  print something in your terminal
	- `echo "hi there"`

- `mkdir`: make a new directory
	- `mkdir desiredfoldername`

- `cd`: Change directory
- `pwd`: print working (or current) directory
- `nano`: Text-Editor inside the terminal
	-   `nano yourfilename` open a file in nano
	- `nano` open nano with a blank (not yet saved) file
		-   Ctrl-O: WriteOut File
		-    Ctrl-X: Exit Nano

- `hexdump`: print the data in hexadecimal format

	-   `hexdump -C yourfilename`

	-   `hexdump -C -n 64 yourfilename` --> `-n 64` stands for: get the first 64 bytes

 - `cat`: print the data of a file
 - `head`: print a part of the data
	-   `head -c 64 yourfilename`
- `ffmpeg`: command line media tool
	- `ffmpeg -i yourinput youroutputfile`
	- `ffmpeg -f yourdesireddataformat -s 8x8 -pix_fmt gray -i yourinput youroutputfile`

- `|` (so called "pipe"): pipe the data from that youget from one terminal command into a second
	-   `head -c 64 yourfilename | ffmpeg -f rawvideo -s 8x8 -pix_fmt gray -i - youroutputfile`
	-   `head -c 64 yourfilename | ffmpeg -f rawvideo -s 8x8 -pix_fmt gray -i - -vf scale=500:500 -sws_flags neighbor -y youroutputfile`


## Discussion – Links - Names

- [Shannon-Weaver-model (Wiki)](https://en.wikipedia.org/wiki/Shannon%E2%80%93Weaver_model)
- [Menkman, Rosa. _The glitch moment (um)_. Amsterdam: Institute of Network Cultures, 2011](https://dpya.org/wiki/images/5/59/NN4_RosaMenkman.pdf)
- [Nick Briz: Glitch Codec Tutorial](http://nickbriz.com/glitchcodectutorial/)

### Names mentioned during the discussion:

Sorry, I am not able anymore to reconstruct the context out of my memory.

- Farmers Manual on Editions Mego
- Russel Haswell
- Florian Hecker
- Editions Mego (Label)
- Mille Plateaux (Label)
- Thomas Brinkman
- Autechre
- Curtis Roads
- Trevor Wishart
- Yasunao Tone: mp3 deviations
- Carsten Nikolai

### Mark's Recommendations:

- [Patrick Liddell: »VIDEO ROOM 1000«](https://mashable.com/2010/06/03/youtube-i-am-sitting/?europe=true) 
- [Murphy, Christopher. _Glitch: designing imperfection_. Mark Batty Publisher, 2009](https://books.google.co.uk/books/about/Glitch.html?id=3r65PAAACAAJ&source=kp_book_description&redir_esc=y) – interesting and early book on "Glitch Aesthetics"
- [Gidal, Peter. _Structural film anthology_. British Film Institute, 1976](http://markfell.com/hfg/misc_papers/Gidal_Peter_ed_Structural_Film_Anthology.pdf) alternative description of practices that engage technical systems in a critical manner. peter gidal structural/material film /media theory
- [Hasson, Uri, et al. "Brain-to-brain coupling: a mechanism for creating and sharing a social world." _Trends in cognitive sciences_ 16.2 (2012): 114-121](http://markfell.com/hfg/misc_papers/Brain-to-brain%20coupling%20-%20a%20mechanism%20for%20creating%20and%20sharing%20a%20social%20world.pdf) – Brain-to-brain coupling as alternative to Shannon and Weaver
- [Latour, Bruno. "A collective of humans and nonhumans: Following Daedalus’s labyrinth." _Readings in the Philosophy of Technology_ 11 (2009)](http://markfell.com/hfg/misc_papers/Latour-collective%20of%20humans%20and%20non%20humans.pdf) – Networks of humans and non humans (actor network theory) as alternative to Shannon and Weaver
- [Gumbrecht, Hans Ulrich. _Production of presence: What meaning cannot convey_. Stanford University Press, 2004](https://www.sup.org/books/title/?id=1360) – Gumbrecht's hypothesis as presence in place of meaning as critique of artworks as about the control and transmission of semantic meaning (between minds separated by noise sources)
- Donald Davidson about metaphoric expressions

