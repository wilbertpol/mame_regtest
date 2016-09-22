
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


## Using the tools

My typical workflow consists of the following steps:

1 Setup list of drivers/files to test and make the appropriate configurations in mame_regtest.xml
1 Configure a comparion output report in create_report.xml (eg name_of_test_comparison)
1 Create a baseline output by doing: ./mame_regtest name_of_test
1 Create a baseline html output by doing: xsltproc --stringparam mameRegtest name_of_test mame_regtest_html.xslt mame_regtest.xml > name_of_test.html  (should be moved to create_report?)
1 If desirable, redo the previous steps until happy enough, then copy the baseline output to the reference output: cd output; cp -r name_of_test ../ref_output

Then iterations of:
1 Make code changes
1 Re-run mame_regtest: ./mame_regtest name_of_test
1 Check output changes by doing: xsltproc --stringparam mameRegtest name_of_test mame_regtest_check_regressions.xslt mame_regtest.xml  (for old versions)
1 Check output changes by doing: ./create_report name_of_test_comparison (for new version)
1 When happy with the changes, make the current output set the new reference set: cd output; cp -r name_of_test ../ref_output


To test a single driver with several test images a file listing the images to test is needed. The format of this file is:
<?xml version="1.0"?>                
<images>
  <!-- Cartridges -->
  <image cart="/path/to/cart1.bin"/>
  <image cart="/path/to/cart2.bin"/>
</images>

And in the test description in mame_regtext.xml add a line like:
<option name='device_file' value='test_images.xml'/>


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
