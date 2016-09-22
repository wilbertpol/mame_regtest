
## Background

While working on the gameboy and other drivers for MAME I was still using Oliver's mame_regtest tool. I even had to do a binary
edit of an older executable to keep the tool usable with newer versions of MAME. The proper way of doing this is of course to
update the source code.

TODO:
* Make current code compile and link under macOS
* Update code to support the updated MAME features (nosound no longer exists for instance)


## Compiling under macOS

Install necessary header files by doing:
* xcode-select --install

Build and create executables by doing:
* make -f makefile_macos



---------------------------------------
original README
---------------------------------------

mame_regtest
(c) Copyright 2005-2014 by Oliver Stoeneberg

http://www.breaken.de/mame_regtest

notes:
	- you need libxml2-2.6.27 to compile this
	- you need zlib 1.2.3 to compile this
	- if you are using a compiler without dirent.h you need dirent API 1.11 to compile this: http://www.softagalleria.net/dirent.php
	- if you are using a system with big-endian byte-order you have to comment the LITTLE_ENDIAN and uncomment the BIG_ENDIAN define
	- XPath tutorial: http://www.zvon.org/xxl/XPathTutorial/General/examples.html

MAME/MESS returncodes:
          1 - terminated / ???
          2 - missing roms
          3 - assertion / fatalerror
          4 - no image specified (MESS-only)
          5 - no such game
          6 - invalid config
        128 - ???  
        100 - exception
-1073741819 - exception (SDLMAME/SDLMESS)

mame_regtest returncodes:
	0 - OK
	1 - error

pngcmp:
	- is built as part of the MAME/MESS "tools" target - please copy it from an existing installation to the mame_regtest folder
	- retuncodes:
		0 - images are identical - no diff written
		1 - images are identical - diff written
	   -1 - an error occured
