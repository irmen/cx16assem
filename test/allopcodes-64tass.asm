
; this assembles into 396 bytes.

	.cpu "w65c02"
	*=$0400
	

; opcodes 00-0f	
; 00 01 4f 04 4f 05 4f 06 4f 07 4f 08 09 4f 0a 0c 31 ea 0d 31 ea 0e 31 ea 0f 4f e5
label00:
	brk			
	ora ($4f,x)
	tsb $4f
	ora $4f
	asl $4f
	;rmb 0,$4f
	php
	ora #$4f
	asl a
	tsb $ea31
	ora $ea31
	asl $ea31
	;bbr 0,$4f,label00
	
; opcodes 10-1f
; 10 fe 11 4f 12 4f 14 4f 15 4f 16 4f 17 4f 18 19 31 ea 1a 1c 31 ea 1d 31 ea 1e 31 ea 1f 4f e1
label10:
	bpl label10
	ora ($4f),y
	ora ($4f)
	trb $4f
	ora $4f,x
	asl $4f,x
	;rmb 1,$4f
	clc
	ora $ea31,y
	inc a
	trb $ea31
	ora $ea31,x
	asl $ea31,x
	;bbr 1,$4f,label10

; opcodes 20-2f
; 20 31 ea 21 4f 24 4f 25 4f 26 4f 27 4f 28 29 4f 2a 2c 31 ea 2d 31 ea 2e 31 ea 2f 4f e3
label20:
	jsr $ea31
	and ($4f,x)
	bit $4f
	and $4f
	rol $4f
	;rmb 2,$4f
	plp
	and #$4f
	rol a
	bit $ea31
	and $ea31
	rol $ea31
	;bbr 2,$4f,label20
	
; opcodes 30-3f
; 30 fe 31 4f 32 4f 34 4f 35 4f 36 4f 37 4f 38 39 31 ea 3a 3c 31 ea 3d 31 ea 3e 31 ea 3f 4f e1
label30:
	bmi label30
	and ($4f),y
	and ($4f)
	bit $4f,x
	and $4f,x
	rol $4f,x
	;rmb 3,$4f
	sec
	and $ea31,y
	dec a
	bit $ea31,x
	and $ea31,x
	rol $ea31,x
	;bbr 3,$4f,label30
	
; opcodes 40-4f
; 40 41 4f 45 4f 46 4f 47 4f 48 49 4f 4a 4c 31 ea 4d 31 ea 4e 31 ea 4f 9a e7
label40:
	rti
	eor ($4f,x)
	eor $4f
	lsr $4f
	;rmb 4,$4f
	pha
	eor #$4f
	lsr a
	jmp $ea31
	eor $ea31
	lsr $ea31
	;bbr 4,$9a,label40

; opcodes 50-5f
; 50 fe 51 4f 52 4f 55 4f 56 4f 57 4f 58 59 31 ea 5a 5d 31 ea 5e 31 ea 5f 4f e6
label50:
	bvc label50
	eor ($4f),y
	eor ($4f)
	eor $4f,x
	lsr $4f,x
	;rmb 5,$4f
	cli
	eor $ea31,y
	phy
	eor $ea31,x
	lsr $ea31,x
	;bbr 5,$4f,label50
	
; opcodes 60-6f
; 60 61 4f 64 4f 65 4f 66 4f 67 4f 68 69 4f 6a 6c 31 ea 6d 31 ea 6e 31 ea 6f 4f e5
label60:
	rts
	adc ($4f,x)
	stz $4f
	adc $4f
	ror $4f
	;rmb 6,$4f
	pla
	adc #$4f
	ror a
	jmp ($ea31)
	adc $ea31
	ror $ea31
	;bbr 6,$4f,label60
	
	
; opcodes 70-3f
; 70 fe 71 4f 72 4f 74 4f 75 4f 76 4f 77 4f 78 79 31 ea 7a 7c 31 ea 7d 31 ea 7e 31 ea 7f 4f e1
label70:
	bvs label70
	adc ($4f),y
	adc ($4f)
	stz $4f,x
	adc $4f,x
	ror $4f,x
	;rmb 7,$4f
	sei
	adc $ea31,y
	ply
	jmp ($ea31,x)
	adc $ea31,x
	ror $ea31,x
	;bbr 7,$4f,label70
	
; opcodes 80-8f
; 80 fe 81 4f 84 4f 85 4f 86 4f 87 4f 88 89 4f 8a 8c 31 ea 8d 31 ea 8e 31 ea 8f 4f e4
label80:
	bra label80
	sta ($4f,x)
	sty $4f
	sta $4f
	stx $4f
	;smb 0,$4f
	dey
	bit #$4f
	txa
	sty $ea31
	sta $ea31
	stx $ea31
	;bbs 0,$4f,label80
	
; opcodes 90-9f
; 90 fe 91 4f 92 4f 94 4f 95 4f 96 4f 97 4f 98 99 31 ea 9a 9c 31 ea 9d 31 ea 9e 31 ea 9f 4f e1
label90:
	bcc label90
	sta ($4f),y
	sta ($4f)
	sty $4f,x
	sta $4f,x
	stx $4f,y
	;smb 1,$4f
	tya
	sta $ea31,y
	txs
	stz $ea31
	sta $ea31,x
	stz $ea31,x
	;bbs 1,$4f,label90
	
; opcodes a0-af
; a0 4f a1 4f a2 4f a4 4f a5 4f a6 4f a7 4f a8 a9 4f aa ac 31 ea ad 31 ea ae 31 ea af 4f e2
labela0:
	ldy #$4f
	lda ($4f,x)
	ldx #$4f
	ldy $4f
	lda $4f
	ldx $4f
	;smb 2,$4f
	tay
	lda #$4f
	tax
	ldy $ea31
	lda $ea31
	ldx $ea31
	;bbs 2,$4f,labela0
	

; opcodes b0-bf
; b0 fe b1 4f b2 4f b4 4f b5 4f b6 4f b7 4f b8 b9 31 ea ba bc 31 ea bd 31 ea be 31 ea bf 4f e1
labelb0:
	bcs labelb0
	lda ($4f),y
	lda ($4f)
	ldy $4f,x
	lda $4f,x
	ldx $4f,y
	;smb 3,$4f
	clv
	lda $ea31,y
	tsx
	ldy $ea31,x
	lda $ea31,x
	ldx $ea31,y
	;bbs 3,$4f,labelb0
	

; opcodes c0-cf
; c0 4f c1 4f c4 4f c5 4f c6 4f c7 4f c8 c9 4f ca cb cc 31 ea cd 31 ea ce 31 ea cf 4f e3
labelc0:
	cpy #$4f
	cmp ($4f,x)
	cpy $4f
	cmp $4f
	dec $4f
	;smb 4,$4f
	iny
	cmp #$4f
	dex
	wai
	cpy $ea31
	cmp $ea31
	dec $ea31
	;bbs 4,$4f,labelc0
	
; opcodes d0-df
; d0 fe d1 4f d2 4f d5 4f d6 4f d7 4f d8 d9 31 ea da db dd 31 ea de 31 ea df 4f e5
labeld0:
	bne labeld0
	cmp ($4f),y
	cmp ($4f)
	cmp $4f,x
	dec $4f,x
	;smb 5,$4f
	cld
	cmp $ea31,y
	phx
	stp
	cmp $ea31,x
	dec $ea31,x
	;bbs 5,$4f,labeld0
	
; opcodes e0-ef
; e0 4f e1 4f e4 4f e5 4f e6 4f e7 4f e8 e9 4f ea ec 31 ea ed 31 ea ee 31 ea ef 4f e4
labele0:
	cpx #$4f
	sbc ($4f,x)
	cpx $4f
	sbc $4f
	inc $4f
	;smb 6,$4f
	inx
	sbc #$4f
	nop
	cpx $ea31
	sbc $ea31
	inc $ea31
	;bbs 6,$4f,labele0
	
; opcodes f0-ff
; f0 fe f1 4f f2 4f f5 4f f6 4f f7 4f f8 f9 31 ea fa fd 31 ea fe 31 ea ff 4f e6
labelf0:
	beq labelf0
	sbc ($4f),y
	sbc ($4f)
	sbc $4f,x
	inc $4f,x
	;smb 7,$4f
	sed
	sbc $ea31,y
	plx
	sbc $ea31,x
	inc $ea31,x
	;bbs 7,$4f,labelf0
	
; branch to positive offsets
; 80 09 3f 4f 06 bf 4f 03 90 01 ea ea
branchpositive:
	bra further
	;bbr 3,$4f,further
	;bbs 3,$4f,further
	bcc further
	nop
further:
	nop

; possible zp or abs confusion
; 4c 4f 00 6c 4f 00 a5 4f b5 4f b9 4f 00
zpornot:	
	jmp $004f
	jmp ($004f)
	lda $004f	; zp
	lda $004f,x	; zp,x
	lda $004f,y	; abs,y

	.end
	

	
	
	
