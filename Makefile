.PHONY:  all clean run

PROG8C ?= prog8c       # if that fails, try this alternative (point to the correct jar file location): java -jar prog8c.jar
PYTHON ?= python

all:  src/opcodes.asm assembler.prg

clean:
	rm -f assembler.prg assembler.asm src/opcodes.asm *.vice-* experiment/perfecthashmnem.c

run:  assembler.prg
	mcopy -D o $< x:ASSEMBLER
	PULSE_LATENCY_MSEC=20 x16emu -sdcard ~/cx16sdcard.img -scale 2 -quality best -run -prg $<

assembler.prg: src/assembler.p8 src/filereader.p8 src/asmsymbols.p8 src/asmoutput.p8 src/expression.p8 src/opcodes.asm
	$(PROG8C) $< -target cx16

src/opcodes.asm:  src/gen_opcodes.py
	$(PYTHON) $< --parser-tree > $@

#experiment/perfecthashmnem.c:  src/gen_opcodes.py
#	$(python) $< --mnemlist | gperf --no-strlen --null-strings -7 -C -D -E -m 100 > $@

