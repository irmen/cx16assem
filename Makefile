.PHONY:  all clean emu

all:  opcodes.asm experiment/perfecthashmnem.c assem.prg

clean:
	rm -f assem.prg assem.asm opcodes.asm *.vice-* experiment/perfecthashmnem.c

emu:  assem.prg
	x16emu -sdcard ~/cx16sdcard.img -scale 2 -run -prg $<

assem.prg: assem.p8 filereader.p8 asmsymbols.p8 opcodes.asm
	p8compile $< -target cx16

opcodes.asm:  gen_opcodes.py
	python $< --parser > $@

experiment/perfecthashmnem.c:  gen_opcodes.py
	python $< --mnemlist | gperf --no-strlen --null-strings -7 -C -D -E -m 100 > $@

