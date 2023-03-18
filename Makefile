.PHONY:  all clean emu

all:  src/opcodes.asm experiment/perfecthashmnem.c assembler.prg

clean:
	rm -f assembler.prg assembler.asm src/opcodes.asm *.vice-* experiment/perfecthashmnem.c

emu:  assembler.prg
	mcopy -D o $< x:ASSEMBLER
	x16emu -randram -sdcard ~/cx16sdcard.img -scale 2 -quality best -run -prg $<

assembler.prg: src/assembler.p8 src/filereader.p8 src/asmsymbols.p8 src/asmoutput.p8 src/expression.p8 src/opcodes.asm
	p8compile $< -target cx16

src/opcodes.asm:  src/gen_opcodes.py
	python $< --parser-tree > $@

experiment/perfecthashmnem.c:  src/gen_opcodes.py
	python $< --mnemlist | gperf --no-strlen --null-strings -7 -C -D -E -m 100 > $@

