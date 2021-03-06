# cx16assem

File-based 65c02 assembler for Commander-X16 (Work in progress)

Requires recent prog8 compiler to build from source.

Software License: MIT open source. (see file LICENSE)


## Compiling the assembler

The assembler requires some autogenerated code for instruction matching.
This code is created by a python script. You can do this manually and then use
the Prog8 compiler ``p8compile`` to finally compile the assembler, but
it's easier to use the supplied Makefile:

Just type 'make'.

Type 'make emu' to immediately boot the assembler in the Commander X16 emulator.


## Usage

*Note:* requires using a SD-card image to be mounted as drive 8 in the emulator, doesn't work currently on a host filesystem passthrough.

Usage should be self-explanatory: when started, the assembler prints the available commands.
After successfully assembling a source file, a summary will be printed. 
You can then enter the filename to save the program as on disk (will overwrite existing file with the same name!).
It's always saved in PRG format, so you can load the program again with ``LOAD "NAME",8,1``

At the moment, the source file is cached in (V)RAM and so is limited to 62 Kb.

## Features

- read source files (up to 62 Kb) directly from disk  (sdcard in the emulator)
- write resulting output directly as PRG file to disk (sdcard in the emulator)
- can assemble to any system memory location  
- set program counter with "* = $9000"
- numbers in decimal 12345, hex $abcd, binary %1010011
- symbolic labels
- can use '<value' and '>value' to get the lsb and msb of a value respectively
- define data with ``.byte  1,2,3,4``, ``.word $a004,$ffff`` and ``.str  "hello!"`` 
- can switch to (the rom-based) x16edit to avoid having to swap-load programs all the time
- disk device 8,9,10,11 selectable


## Todo

- more assembler directives?

- can we get it to work on a host mounted filesystem in the emulator?
  
 

### Maybe some day:
  
- include / incbin  to read in separate files
  these files have to be cached in banked ram to avoid having to reload them in phase 2

- simple expressions  (+, -, bitwise and/or/xor, bitwise shifts, maybe simple multiplication)

- local scoped labels and perhaps relative labels (+/-)

- macros

- better error descriptions?
