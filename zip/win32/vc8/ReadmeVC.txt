VC8 Readme

This directory has a VC8 project list that can be used to compile Zip
and the utilities.  There are two variants of the Zip project:
- The default zip.dsp project does not include bzip2 support.
- The variant project zipbz2.dsp includes support for the bzip2
  compression method.

To include bzip2 support, get a copy of the bzip2 source (bzip2-1.0.5
or later from http://www.bzip.org/ for instance), expand the bzip2
source into a directory, then copy the contents of the bzip2-1.0.5
directory, for instance, into the zip bzip2 directory.  Use the
variant project to compile zip and support for bzip2 should
automatically be included.  See bzip2/install.txt for additional
information.

Ed Gordon, Chr. Spieler
15 February 2009, 27 February 2009
