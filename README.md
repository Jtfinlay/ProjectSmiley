Notes from James:

You'll need octave 3.8.1+ to run the included packages. They won't
work on ohaton, since the server's missing some required libraries
(well -- something's broken, I dunno).

I had to install octave on my linux server to get this all working. I
had some issues getting the proper version built, but the following
helped for my fortran problems:

> sudo apt-get install f2c gfortran libblas-dev liblapack-dev

You can get the newest version of octave from:

> ftp://ftp.gnu.org/gnu/octave/

and install with

> ./configure && make && make install

Let me know if there are issues. I can add you guys as users on my
server so you don't have to set anything up yourselves. It took
forever to install octave.

Hope this helps!
