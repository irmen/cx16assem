.PHONY:  all clean emu

all:  src/opcodes.asm experiment/perfecthashmnem.c assem.prg

clean:
	rm -f assem.prg assem.asm src/opcodes.asm *.vice-* experiment/perfecthashmnem.c

emu:  assem.prg
	x16emu -sdcard ~/cx16sdcard.img -scale 2 -run -prg $<

assem.prg: src/assem.p8 src/filereader.p8 src/asmsymbols.p8 src/opcodes.asm
	p8compile $< -target cx16

src/opcodes.asm:  gen_opcodes.py
	python $< --parser > $@

experiment/perfecthashmnem.c:  gen_opcodes.py
	python $< --mnemlist | gperf --no-strlen --null-strings -7 -C -D -E -m 100 > $@

