
# Glitch-Practices

## Practicals

## Software

- [Audacity](https://www.audacity.de/)

- [ffmpeg](https://ffmpeg.org/download.html) (command line program)

  - on MacOS installation via [brew](https://brew.sh/)
     `brew install ffmpeg` after installing brew

  - on Linux via `sudo apt install ffmpeg`

- to participate from within Windows you can either get [WSL (Windows Subsystem for Linux)](https://docs.microsoft.com/de-de/windows/wsl/install-win10) to get a Linux shell inside of your Windows environment or install Linux in a Virtual Machine (e.g. [VirtualBox](https://www.virtualbox.org/)). We recommend Ubuntu for ease of use and installation. Both installations will take some time so you will need to prepare this beforehand. When using WSL you can run `explorer.exe .` to use Explorer to browse files in your current WSL working directory.

### Shell Commands:

- `echo`:  print something in your terminal
	- `echo "hi there"`

- `mkdir`: make a new directory
	- `mkdir desiredfoldername`

- `cd`: Change directory
- `pwd`: print working (or current) directory
- `nano`: Text-Editor inside the terminal
	- `nano yourfilename` open a file in nano
	- `nano` open nano with a blank (not yet saved) file
		- Ctrl-O: WriteOut File
		- Ctrl-X: Exit Nano

- `hexdump`: print a file's data in hexadecimal format

	- `hexdump -C yourfilename`

	- `hexdump -C -n 64 yourfilename` --> `-n 64` specifies how many

 - `cat`: print the data of a file
 - `head`: print part of a file's data
	-   `head -c 64 yourfilename`

- `ffmpeg`: command line media tool
	- `ffmpeg -i yourinput youroutputfile`
	- `ffmpeg -f yourdesireddataformat -s 'width'x'height' -pix_fmt yourpixelformat -i yourinput youroutputfile`

- `|` (a pipe): "pipes" data from one command's output stream into a second command's input
	- `head -c 64 yourfilename | ffmpeg -f rawvideo -s 8x8 -pix_fmt gray -i - youroutputfile`: pipe 64 bytes from a file to ffmpeg and display them as grayscale image (8-bit per pixel) on a square matrix (8 x 8)
	- `head -c 64 yourfilename | ffmpeg -f rawvideo -s 8x8 -pix_fmt gray -i - -vf scale=500:500 -sws_flags neighbor -y youroutputfile`: same as above but scaled to a larger resolution so we can see something

### 'i am sitting in a mp3'

Based on Alvin Lucier's [I Am Sitting In A Room](https://www.youtube.com/watch?v=fAxHlLK3Oyk](https://www.youtube.com/watch?v=fAxHlLK3Oyk), we want to take an mp3-soundfile and recursively compress it using the mp3-encoder again and again.

For that you first need a (preferably short) mp3-file.

Place it in a directory you want to be working in.

Also create a new folder called `out` for our output files, as we will create lots of audio files and we don't want to mess up our current working directory.

Now open nano (or any text editor of your choice) to write the following shell-script:

```
#! /bin/sh

f=./yourfile.mp3

for i in {0..99}
do
  ffmpeg -i $f ./out/youroutputfile$i.mp3

  # Since successive copies will get progressively quieter we recommend using
  # the 'loudnorm' filter for normalisation if installed on your system.

  # ffmpeg -i $f -af loudnorm=I=-16:TP=-1.5:LRA=11 ./out/youroutputfile$i.mp3

	f=./out/youroutputfile$i.mp3

	echo "written to $f"
done
```

Save this file as `yourshellscriptfilename.sh`.

Then, in the terminal run:
`bash yourshellscriptfilename.sh`

or:

`chmod +x yourshellscriptfilename.sh`
and then:
`./yourshellscriptfilename.sh`

Your `out` folder should now be full with mp3-files numbered from 0-99. Can you hear the artifacts of the recursively applied mp3-compression?

## Discussion - Literature - Links - Names

- [Claude E. Shannon - _The Mathematical Theory of Communication_](https://archive.org/details/MathematicalTheoryOfCommunicationShannon)
- [Rosa Menkman - _The Glitch Moment(um)_](https://dpya.org/wiki/images/5/59/NN4_RosaMenkman.pdf)
- [Nick Briz's Glitch Codec Tutorial](http://nickbriz.com/glitchcodectutorial/)

### Names:

- Editions Mego (Label)
- Mille Plateaux (Label)
- Farmers Manual
- Russel Haswell
- Florian Hecker
- Thomas Brinkmann
- Autechre
- Curtis Roads
- Trevor Wishart
- Yasunao Tone - "MP3 deviations"
- Carsten Nicolai

### Mark's Recommendations:

- [Patrick Liddell: »VIDEO ROOM 1000«](https://mashable.com/2010/06/03/youtube-i-am-sitting/?europe=true)
- [Murphy, Christopher. _Glitch: designing imperfection_. Mark Batty Publisher, 2009](https://books.google.co.uk/books/about/Glitch.html?id=3r65PAAACAAJ&source=kp_book_description&redir_esc=y) – Interesting and early book on "Glitch Aesthetics".
- [Gidal, Peter. _Structural film anthology_. British Film Institute, 1976](http://markfell.com/hfg/misc_papers/Gidal_Peter_ed_Structural_Film_Anthology.pdf) - Alternative description of practices that engage technical systems in a critical manner. Peter Gidal structural/material film/media theory.
- [Hasson, Uri, et al. "Brain-to-brain coupling: a mechanism for creating and sharing a social world." _Trends in cognitive sciences_ 16.2 (2012): 114-121](http://markfell.com/hfg/misc_papers/Brain-to-brain%20coupling%20-%20a%20mechanism%20for%20creating%20and%20sharing%20a%20social%20world.pdf) – Brain-to-brain coupling as alternative to Shannon and Weaver.
- [Latour, Bruno. "A collective of humans and nonhumans: Following Daedalus’s labyrinth." _Readings in the Philosophy of Technology_ 11 (2009)](http://markfell.com/hfg/misc_papers/Latour-collective%20of%20humans%20and%20non%20humans.pdf) – Networks of humans and non-humans (Actor Network Theory) as alternative to Shannon and Weaver.
- [Gumbrecht, Hans Ulrich. _Production of presence: What meaning cannot convey_. Stanford University Press, 2004](https://www.sup.org/books/title/?id=1360) – Gumbrecht's hypothesis as presence in place of meaning as critique of artworks as about the control and transmission of semantic meaning (between minds separated by noise sources).
- Donald Davidson about metaphoric expressions.
