; assembly source originally disassembled from CommanderX16 ROM
; hacked a bit for benchmark purposes so it's no longer 1:1 identical to the rom
; memory range: $c000 - almost $ffff (more or less 16 Kb)
*=$c000
 ldx $0386
 ldy $0387
 rts
 bcs $c012
 stx $0383
 sty $0380
 jsr $c074
 ldx $0383
 ldy $0380
 rts
 stx $0386
 sty $0387
 iny
 sty $0388
 dey
 dey
 sty $0389
 jmp $c051
 jsr $dea7
 jsr $e04d
 lda #$02
 jsr $c757
 lda #$00
 sta $0372
 sta $037e
 jsr $deb3
 jsr $cb12
 lda #$61
 sta $0376
 lda #$0c
 sta $037c
 sta $037b
 lda #$80
 ldx #$00
 sta $0334,x
 inx
 cpx $0388
 bne $c055
 lda #$ff
 sta $0334,x
 ldx $0389
 jsr $c88e
 dex
 bpl $c066
 ldy #$00
 sty $0380
 sty $0383
 ldx $0383
 lda $0380
 ldy $0334,x
 bmi $c089
 clc
 adc $0386
 sta $0380
 dex
 bpl $c07a
 jsr $c7cc
 lda $0386
 dec
 inx
 ldy $0334,x
 bmi $c09d
 clc
 adc $0386
 inx
 bpl $c091
 sta $0382
 rts
 jsr $c28c
 jsr $c995
 sta $037b
 sta $0374
 beq $c0a4
 pha
 php
 sei
 lda $037e
 beq $c0c5
 lda $037d
 ldx $0373
 ldy #$00
 sty $037e
 jsr $c660
 plp
 pla
 cmp #$83
 bne $c0dd
 jsr $c962
 ldx #$00
 lda $c6b4,x
 jsr $c9e1
 inx
 cpx #$09
 bne $c0d0
 bra $c0a4
 pha
 sec
 sbc #$85
 bcc $c110
 cmp #$08
 bcs $c110
 cmp #$04
 rol
 and #$07
 ldx #$00
 tay
 beq $c0fd
 lda $c6bd,x
 beq $c0f9
 inx
 bne $c0f1
 inx
 dey
 bne $c0f1
 jsr $c962
 lda $c6bd,x
 jsr $c9e1
 tay
 beq $c10c
 inx
 bne $c100
 pla
 jmp $c0a4
 pla
 cmp #$0d
 bne $c0a1
 ldy $0382
 sty $037f
 jsr $c7d8
 cmp #$20
 bne $c125
 dey
 bne $c11b
 iny
 sty $0378
 ldy #$00
 sty $0374
 sty $0380
 sty $0381
 lda $0379
 bmi $c15f
 ldx $0383
 cpx $0379
 beq $c144
 jsr $c25b
 cpx $0379
 bne $c15f
 lda $037a
 sta $0380
 cmp $0378
 bcc $c15f
 bcs $c1a7
 tya
 pha
 txa
 pha
 lda $037f
 beq $c10d
 ldy $0380
 jsr $c7d8
 sta $0384
 bit $0372
 bvs $c184
 and #$3f
 asl $0384
 bit $0384
 bpl $c179
 ora #$80
 bcc $c180
 ldx $0381
 bne $c184
 bvs $c184
 ora #$40
 bit $038a
 stz $038a
 bpl $c19c
 cmp #$60
 bcs $c19a
 pha
 jsr $c7d8
 bmi $c199
 pla
 bra $c19c
 pla
 lda #$00
 inc $0380
 jsr $c1d8
 cpy $0378
 bne $c1c1
 lda #$00
 sta $037f
 lda #$0d
 ldx $028a
 cpx #$03
 beq $c1bc
 ldx $028b
 cpx #$03
 beq $c1bf
 jsr $c28c
 lda #$0d
 sta $0384
 pla
 tax
 pla
 tay
 lda $0384
 bit $0372
 bvs $c1d6
 cmp #$de
 bne $c1d6
 lda #$ff
 clc
 rts
 cmp #$22
 bne $c1e6
 lda $0381
 eor #$01
 sta $0381
 lda #$22
 rts
 bit $0372
 bvs $c1f3
 ora #$40
 ldx $0377
 beq $c1f5
 ora #$80
 ldx $0385
 beq $c1fd
 dec $0385
 ldx $0376
 jsr $c660
 jsr $c216
 pla
 tay
 lda $0385
 beq $c210
 lsr $0381
 pla
 tax
 pla
 clc
 cli
 rts
 jsr $c53b
 inc $0380
 lda $0382
 cmp $0380
 bcs $c271
 cmp #$4f
 beq $c266
 lda $0374
 beq $c230
 jmp $c608
 ldx $0383
 cpx $0387
 bcc $c241
 jsr $c59b
 dec $0383
 ldx $0383
 asl $0334,x
 lsr $0334,x
 inx
 lda $0334,x
 ora #$80
 sta $0334,x
 dex
 lda $0382
 clc
 adc $0386
 sta $0382
 lda $0334,x
 bmi $c263
 dex
 bne $c25b
 jmp $c7cc
 dec $0383
 jsr $c4f8
 lda #$00
 sta $0380
 rts
 ldx $0383
 bne $c27e
 stx $0380
 pla
 pla
 bne $c206
 dex
 stx $0383
 jsr $c074
 ldy $0382
 sty $0380
 rts
 bit $038a
 bpl $c2c9
 bit $0372
 bvc $c2a2
 pha
 lda #$02
 sta $0381
 pla
 inc $0385
 bra $c2ba
 cmp #$20
 bcs $c2ab
 inc $0377
 ora #$40
 cmp #$80
 bcc $c2ba
 cmp #$a0
 bcs $c2ba
 inc $0377
 and #$7f
 ora #$60
 jsr $c2d3
 stz $038a
 stz $0377
 stz $0381
 and #$ff
 rts
 cmp #$80
 bne $c2d3
 ror $038a
 and #$ff
 rts
 pha
 sta $0384
 txa
 pha
 tya
 pha
 lda #$00
 sta $037f
 ldy $0380
 lda $0384
 bpl $c2eb
 jmp $c42d
 ldx $0381
 cpx #$02
 beq $c2f9
 cmp #$0d
 bne $c2f9
 jmp $c512
 cmp #$20
 bcc $c312
 bit $0372
 bvs $c30c
 cmp #$60
 bcc $c30a
 and #$df
 bne $c30c
 and #$3f
 jsr $c1d8
 jmp $c1ee
 ldx $0385
 beq $c322
 bit $0372
 bvc $c31f
 jmp $c1f5
 jmp $c1f3
 cmp #$14
 bne $c359
 tya
 bne $c32f
 jsr $c272
 jmp $c34c
 jsr $c526
 dey
 sty $0380
 iny
 jsr $c7d8
 dey
 jsr $c806
 iny
 jsr $c7d3
 dey
 jsr $c800
 iny
 cpy $0382
 bne $c336
 lda #$20
 jsr $c806
 lda $0376
 jsr $c800
 bpl $c3bf
 ldx $0381
 beq $c369
 bit $0372
 bvc $c366
 jmp $c1f5
 jmp $c1f3
 cmp #$12
 bne $c375
 bit $0372
 bvs $c375
 sta $0377
 cmp #$13
 bne $c37c
 jsr $c06c
 cmp #$1d
 bne $c39b
 iny
 jsr $c53b
 sty $0380
 dey
 cpy $0382
 bcc $c398
 dec $0383
 jsr $c4f8
 ldy #$00
 sty $0380
 jmp $c206
 cmp #$11
 bne $c3c2
 clc
 tya
 adc $0386
 tay
 inc $0383
 cmp $0382
 bcc $c395
 beq $c395
 dec $0383
 sbc $0386
 bcc $c3bc
 sta $0380
 bne $c3b2
 jsr $c4f8
 jmp $c206
 jsr $c55a
 cmp #$0e
 bne $c3d6
 bit $0372
 bvs $c3e4
 lda #$03
 jsr $c8e1
 jmp $c206
 cmp #$8e
 bne $c3e7
 bit $0372
 bvs $c3e4
 lda #$02
 jsr $c8e1
 jmp $c206
 cmp #$08
 bne $c3f2
 lda #$80
 ora $0372
 bmi $c3fb
 cmp #$09
 bne $c401
 lda #$7f
 and $0372
 sta $0372
 jmp $c206
 cmp #$0f
 bne $c411
 lda #$01
 jsr $c8e1
 lda $0372
 ora #$40
 bra $c41f
 cmp #$8f
 bne $c3e4
 lda #$02
 jsr $c8e1
 lda $0372
 and #$bf
 sta $0372
 lda #$ff
 jsr $cb12
 jsr $c051
 jmp $c206
 and #$7f
 bit $0372
 bvs $c43a
 cmp #$7f
 bne $c43a
 lda #$5e
 cmp #$20
 bcc $c441
 jmp $c1e7
 ldx $0381
 cpx #$02
 beq $c44f
 cmp #$0d
 bne $c44f
 jmp $c512
 ldx $0381
 bne $c49d
 cmp #$14
 bne $c498
 ldy $0382
 jsr $c7d8
 cmp #$20
 bne $c467
 cpy $0380
 bne $c46e
 cpy #$4f
 beq $c495
 jsr $c605
 ldy $0382
 dey
 jsr $c7d8
 iny
 jsr $c806
 dey
 jsr $c7d3
 iny
 jsr $c800
 dey
 cpy $0380
 bne $c471
 lda #$20
 jsr $c806
 lda $0376
 jsr $c800
 inc $0385
 jmp $c206
 ldx $0385
 beq $c4a7
 bit $0372
 bvs $c4a4
 ora #$40
 jmp $c1f3
 cmp #$11
 bne $c4c6
 ldx $0383
 beq $c4ed
 dec $0383
 lda $0380
 sec
 sbc $0386
 bcc $c4c1
 sta $0380
 bpl $c4ed
 jsr $c074
 bne $c4ed
 cmp #$12
 bne $c4cf
 lda #$00
 sta $0377
 cmp #$1d
 bne $c4e6
 tya
 beq $c4e0
 jsr $c526
 dey
 sty $0380
 jmp $c206
 jsr $c272
 jmp $c206
 cmp #$13
 bne $c4f0
 jsr $c051
 jmp $c206
 ora #$80
 jsr $c55a
 jmp $c3d6
 lsr $0379
 ldx $0383
 inx
 cpx $0387
 bne $c507
 jsr $c59b
 lda $0334,x
 bpl $c4fe
 stx $0383
 jmp $c074
 ldx #$00
 stx $0385
 stx $0377
 stx $0381
 stx $0380
 jsr $c4f8
 jmp $c206
 ldx #$02
 lda #$00
 cmp $0380
 beq $c537
 clc
 adc $0386
 dex
 bne $c52a
 rts
 dec $0383
 rts
 ldx #$02
 lda $0386
 dec
 cmp $0380
 beq $c54e
 clc
 adc $0386
 dex
 bne $c541
 rts
 ldx $0383
 cpx $0387
 beq $c559
 inc $0383
 rts
 cmp #$01
 bne $c56f
 lda $0376
 asl
 adc #$80
 rol
 asl
 adc #$80
 rol
 sta $0376
 lda #$01
 rts
 ldx #$0f
 cmp $c58b,x
 beq $c57a
 dex
 bpl $c571
 rts
 pha
 lda $0376
 and #$f0
 stx $0376
 ora $0376
 sta $0376
 pla
 rts
 bcc $c592
 trb $9c9f
 asl $9e1f,x
 sta ($95,x)
 stx $97,y
 tya
 sta $9b9a,y
 ldx #$ff
 dec $0383
 dec $0379
 dec $0375
 inx
 jsr $c7cc
 cpx $0389
 bcs $c5b7
 phx
 inx
 jsr $c83e
 plx
 bra $c5a6
 jsr $c88e
 ldx #$00
 lda $0334,x
 and #$7f
 ldy $0335,x
 bpl $c5c8
 ora #$80
 sta $0334,x
 inx
 cpx $0389
 bne $c5bc
 ldy $0389
 lda $0334,y
 ora #$80
 sta $0334,y
 lda $0334
 bpl $c59b
 inc $0383
 inc $0375
 jsr $ca64
 and #$04
 beq $c601
 lda #$08
 ldy #$00
 nop
 dex
 bne $c5f2
 dey
 bne $c5f2
 sec
 sbc #$01
 bne $c5f2
 jsr $c962
 ldx $0383
 rts
 ldx $0383
 inx
 lda $0334,x
 bpl $c608
 stx $0375
 cpx $0389
 beq $c625
 bcc $c625
 jsr $c59b
 ldx $0375
 dex
 dec $0383
 jmp $c241
 ldx $0387
 dex
 jsr $c7cc
 cpx $0375
 bcc $c63b
 beq $c63b
 phx
 dex
 jsr $c83e
 plx
 bra $c628
 jsr $c88e
 ldx $0387
 dex
 dex
 cpx $0375
 bcc $c65a
 lda $0335,x
 and #$7f
 ldy $0334,x
 bpl $c654
 ora #$80
 sta $0335,x
 dex
 bne $c643
 ldx $0375
 jmp $c241
 ldy #$02
 sty $037c
 ldy $0380
 jmp $c830
 lda $037b
 bne $c6b3
 dec $037c
 bne $c6b3
 jsr $c8b4
 lda #$14
 sta $037c
 ldy $0380
 lsr $037e
 php
 jsr $c837
 inc $037e
 plp
 bcs $c696
 sta $037d
 stx $0373
 ldx $0376
 bit $0372
 bvc $c6a8
 cmp #$9f
 bne $c6a4
 lda $037d
 bra $c6aa
 lda #$9f
 bra $c6aa
 eor #$80
 ldy $0380
 jsr $c830
 jsr $c8cc
 rts
 jmp $414f
 .byte $44,$0d
 eor ($55)
 lsr $4c0d
 eor #$53
 .byte $54,$0d
 brk
 eor $4e4f
 eor #$54
 bbr4 $52,$c6d8
 brk
 eor ($55)
 lsr $000d
 nop
 nop
 nop
 and ($35)
 and $0d,x
 brk
 jmp $414f
 .byte $44,$0d
 brk
 nop
 eor ($56,x)
 eor $22
 brk
 .byte $44,$4f
 nop
 .byte $22,$24
 ora $4400
 bbr4 $53,$c712
 brk
 stz $9f25
 lda #$02
 jsr $c8e1
 lda #$60
 sta $9f34
 lda #$00
 sta $9f35
 lda #$7c
 sta $9f36
 stz $9f37
 stz $9f38
 stz $9f39
 stz $9f3a
 lda #$02
 sta $9f25
 stz $9f29
 lda #$a0
 sta $9f2a
 stz $9f2b
 lda #$78
 sta $9f2c
 stz $9f25
 lda #$21
 sta $9f29
 lda #$80
 sta $9f2a
 sta $9f2b
 stz $9f2c
 stz $9f20
 lda #$fc
 sta $9f21
 lda #$11
 sta $9f22
 ldx #$04
 ldy #$00
 stz $9f23
 iny
 bne $c74d
 dex
 bne $c74d
 rts
 cmp #$ff
 bne $c764
 lda #$02
 cmp $0261
 bne $c764
 lda #$00
 sta $0261
 cmp #$00
 beq $c790
 cmp #$01
 bne $c771
 sec
 rts
 cmp #$02
 beq $c77f
 cmp #$80
 beq $c788
 cmp #$81
 beq $c76f
 bra $c76f
 ldx #$50
 ldy #$3c
 lda #$80
 clc
 bra $c797
 jsr $c7c0
 ldy #$19
 sec
 bra $c793
 clc
 ldy #$1e
 ldx #$28
 lda #$40
 pha
 bcs $c79d
 stz $9f2d
 pla
 sta $9f2a
 sta $9f2b
 cpy #$19
 bne $c7ac
 lda #$c8
 bra $c7ae
 lda #$f0
 pha
 lda #$02
 sta $9f25
 pla
 sta $9f2c
 stz $9f25
 jsr $c019
 clc
 rts
 lda #$0e
 sta $0376
 stz $02
 stz $03
 jmp $e083
 stz $0262
 stx $0263
 rts
 tya
 sec
 rol
 bra $c7ee
 tya
 cmp $0386
 bcc $c7ed
 sec
 sbc $0386
 asl
 sta $9f20
 lda $0263
 adc #$01
 bne $c7f4
 asl
 sta $9f20
 lda $0263
 sta $9f21
 lda #$10
 sta $9f22
 lda $9f23
 rts
 pha
 tya
 sec
 rol
 bra $c81d
 pha
 tya
 cmp $0386
 bcc $c81c
 sec
 sbc $0386
 asl
 sta $9f20
 lda $0263
 adc #$01
 bne $c823
 asl
 sta $9f20
 lda $0263
 sta $9f21
 lda #$10
 sta $9f22
 pla
 sta $9f23
 rts
 jsr $c806
 stx $9f23
 rts
 jsr $c7d8
 ldx $9f23
 rts
 lda $88
 pha
 lda $89
 pha
 lda #$00
 sta $88
 stx $89
 lda #$10
 sta $9f22
 lda $0262
 sta $9f20
 lda $0263
 sta $9f21
 lda #$01
 sta $9f25
 lda #$10
 sta $9f22
 lda $88
 sta $9f20
 lda $89
 sta $9f21
 lda #$00
 sta $9f25
 ldy $0386
 dey
 lda $9f24
 sta $9f23
 lda $9f24
 sta $9f23
 dey
 bpl $c878
 pla
 sta $89
 pla
 sta $88
 rts
 ldy $0386
 jsr $c7cc
 lda $0262
 sta $9f20
 lda $0263
 sta $9f21
 lda #$10
 sta $9f22
 lda #$20
 sta $9f23
 lda $0376
 sta $9f23
 dey
 bne $c8a5
 rts
 plx
 ply
 lda $9f25
 pha
 stz $9f25
 lda $9f20
 pha
 lda $9f21
 pha
 lda $9f22
 pha
 phy
 phx
 rts
 plx
 ply
 pla
 sta $9f22
 pla
 sta $9f21
 pla
 sta $9f20
 pla
 sta $9f25
 phy
 phx
 rts
 jsr $c94b
 cmp #$00
 beq $c8f5
 cmp #$01
 beq $c918
 cmp #$02
 beq $c921
 cmp #$03
 beq $c936
 rts
 stx $80
 sty $81
 ldx #$08
 ldy #$00
 lda #$80
 sta $03af
 phx
 ldx #$06
 jsr $dfae
 eor $0384
 sta $9f23
 iny
 bne $c903
 inc $81
 plx
 dex
 bne $c902
 rts
 lda #$c8
 sta $81
 ldx #$08
 jmp $c8fb
 lda #$c0
 sta $81
 ldx #$04
 jsr $c8fb
 dec $0384
 lda #$c0
 sta $81
 ldx #$04
 jmp $c8fb
 lda #$c4
 sta $81
 ldx #$04
 jsr $c8fb
 dec $0384
 lda #$c4
 sta $81
 ldx #$04
 jmp $c8fb
 phx
 ldx #$00
 stx $9f20
 ldx #$f8
 stx $9f21
 ldx #$10
 stx $9f22
 plx
 stz $0384
 stz $80
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 lda #$00
 sta $a00a
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 lda $a00a
 beq $c9ca
 php
 sei
 ldy $a000
 ldx #$00
 lda $a001,x
 sta $a000,x
 inx
 cpx $a00a
 bne $c9b9
 dec $a00a
 plp
 tya
 clc
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 stx $a00b
 ldx $a00a
 cpx #$0a
 bcs $ca09
 sta $a000,x
 inc $a00a
 ldx $a00b
 pha
 cmp #$03
 bne $ca15
 lda #$ff
 bra $ca17
 lda #$00
 sta $a00b
 pla
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 lda $a00b
 eor #$ff
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 lda $a00c
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 ldx #$01
 jsr $ca9b
 dex
 lda $9f72,x
 ora #$03
 sta $9f72,x
 lda $9f70,x
 and #$fd
 ora #$01
 sta $9f70,x
 rts
 lda $9f72,x
 and #$fc
 sta $9f72,x
 lda #$03
 ldy #$50
 dey
 beq $cb0b
 bit $9f70,x
 bne $caba
 lda #$02
 bit $9f70,x
 beq $cac4
 ldy #$09
 bit $9f70,x
 bne $cacb
 lda $9f70,x
 and #$01
 cmp #$01
 ror $a00d
 lda #$02
 bit $9f70,x
 beq $cadc
 dey
 bne $cacb
 rol $a00d
 bit $9f70,x
 bne $cae7
 bit $9f70,x
 beq $caec
 jsr $ca9b
 lda $a00d
 php
 lsr
 bcc $cafc
 iny
 cmp #$00
 bne $caf8
 tya
 plp
 adc #$01
 lsr
 lda $a00d
 ldy #$01
 rts
 jsr $ca9b
 clc
 lda #$00
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 jsr $cb74
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 jsr $cbe9
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 cmp #$ff
 bne $cb7b
 lda $a010
 pha
 bit $0372
 bvs $cb85
 ldy #$00
 bra $cb87
 ldy #$02
 lda #$00
 sta $80
 lda #$c0
 sta $81
 lda #$80
 sta $03af
 ldx #$01
 jsr $dfae
 pha
 iny
 ldx #$01
 jsr $dfae
 sta $81
 pla
 sta $80
 pla
 sta $a010
 asl
 asl
 asl
 asl
 tay
 ldx #$01
 jsr $dfae
 beq $cba6
 ldx #$00
 phx
 ldx #$01
 jsr $dfae
 plx
 sta $a011,x
 inx
 iny
 cpx #$10
 bne $cbb7
 rts
 ldx $a010
 inx
 txa
 jsr $cb74
 lda #$8d
 jsr $c9e1
 ldx #$00
 lda $a011,x
 beq $cbe4
 jsr $c9e1
 inx
 cpx #$06
 bne $cbd7
 lda #$8d
 jmp $c9e1
 jsr $cca1
 beq $cc5a
 tay
 cpx #$00
 bne $cc39
 cpy #$01
 beq $cbc8
 cmp #$83
 bne $cbfe
 lda #$02
 tay
 cmp #$0e
 bcc $cc06
 cmp #$68
 bcc $cc0a
 ldx #$08
 bne $cc20
 ldx #$00
 lda $a00c
 cmp #$06
 bne $cc17
 ldx #$06
 bne $cc20
 lsr
 bcs $cc20
 inx
 inx
 cpx #$08
 bne $cc17
 lda $a017,x
 sta $84
 lda $a018,x
 sta $85
 ldx #$01
 lda #$84
 sta $03af
 jsr $dfae
 beq $cc5a
 jmp $c9e1
 cpx #$e1
 beq $cc63
 cmp #$4a
 bne $cc45
 lda #$2f
 bne $cc6b
 cmp #$5a
 beq $cc5f
 cpy #$6c
 beq $cc5b
 cmp #$68
 bcc $cc5a
 cmp #$80
 bcs $cc5a
 lda $cc9c,y
 bne $cc6b
 rts
 ldx #$26
 bra $cc65
 ldx #$1a
 bra $cc65
 ldx #$06
 lda $a00c
 lsr
 txa
 ror
 jmp $c9e1
 ldx #$01
 jsr $caae
 bcs $cc77
 bne $cc7a
 lda #$00
 rts
 cmp #$e0
 beq $cc82
 cmp #$e1
 bne $cc87
 sta $a00e
 beq $cc6e
 cmp #$f0
 bne $cc90
 rol $a00f
 bne $cc6e
 pha
 lsr $a00f
 ldx $a00e
 lda #$00
 sta $a00e
 sta $a00f
 pla
 rts
 jsr $cc6e
 beq $ccc5
 jsr $d09b
 php
 jsr $ccc6
 bcc $ccc2
 plp
 bcc $ccb9
 eor #$ff
 and $a00c
 bra $ccbc
 ora $a00c
 sta $a00c
 lda #$00
 rts
 plp
 bcs $ccbf
 rts
 cpx #$e1
 beq $ccea
 cmp #$11
 bne $ccda
 cpx #$e0
 bne $ccd6
 lda #$06
 bra $ccd8
 lda #$02
 sec
 rts
 cmp #$14
 beq $ccfc
 cpx #$00
 bne $ccec
 cmp #$12
 beq $cd00
 cmp #$59
 beq $cd00
 clc
 rts
 cmp #$1f
 beq $ccf4
 cmp #$27
 bne $ccea
 lda #$08
 bra $cd02
 lda #$02
 bra $cd02
 lda #$04
 bra $cd02
 lda #$01
 sec
 rts
 brk
 brk
 brk
 sta $0000,x
 brk
 brk
 sty $14,x
 ora ($00),y
 ora $0091,x
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 nop
 brk
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 jsr $cd4d
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 lda #$00
 sta $a022
 sta $a023
 sta $a026
 sta $a027
 lda #$80
 sta $a024
 lda #$02
 sta $a025
 lda #$e0
 sta $a028
 lda #$01
 sta $a029
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 jsr $cda1
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 pha
 lda $a024
 ora $a025
 ora $a028
 ora $a029
 bne $cdb3
 jsr $cd1c
 pla
 cpx #$00
 beq $cdbb
 stx $a021
 cmp #$00
 bne $cddc
 lda $a021
 and #$7f
 sta $a021
 lda $03
 pha
 lda $04
 pha
 lda #$ff
 sta $03
 inc
 jsr $f9bd
 pla
 sta $04
 pla
 sta $03
 rts
 cmp #$ff
 beq $ce16
 lda $02
 pha
 lda $03
 pha
 lda $04
 pha
 lda $05
 pha
 lda #$a6
 sta $02
 lda #$cf
 sta $03
 lda #$c6
 sta $04
 lda #$cf
 sta $05
 lda #$01
 sta $06
 ldx #$10
 ldy #$10
 lda #$00
 sec
 jsr $f923
 pla
 sta $05
 pla
 sta $04
 pla
 sta $03
 pla
 sta $02
 lda $a021
 ora #$80
 sta $a021
 jmp $cf08
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 jsr $ce52
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 bit $a021
 bpl $ce60
 ldx #$00
 jsr $caae
 bcs $ce60
 bne $ce61
 rts
 sta $a02e
 ldx #$00
 jsr $caae
 clc
 adc $a02a
 sta $a02a
 lda $a02e
 and #$10
 beq $ce79
 lda #$ff
 adc $a02b
 sta $a02b
 ldx #$00
 jsr $caae
 clc
 adc $a02c
 sta $a02c
 lda $a02e
 and #$20
 beq $ce94
 lda #$ff
 adc $a02d
 sta $a02d
 lda $a02e
 and #$07
 sta $a02e
 ldy $a022
 ldx $a023
 lda $a02b
 bmi $ceb9
 cpx $a02b
 bne $ceb5
 cpy $a02a
 bcc $cebf
 beq $cebf
 sty $a02a
 stx $a02b
 ldy $a024
 ldx $a025
 cpx $a02b
 bne $cecd
 cpy $a02a
 bcs $ced5
 sty $a02a
 stx $a02b
 ldy $a026
 ldx $a027
 lda $a02d
 bmi $ceec
 cpx $a02d
 bne $cee8
 cpy $a02c
 bcc $cef2
 beq $cef2
 sty $a02c
 stx $a02d
 ldy $a028
 ldx $a029
 cpx $a02d
 bne $cf00
 cpy $a02c
 bcs $cf08
 sty $a02c
 stx $a02d
 jsr $c8b4
 lda $02
 pha
 lda $03
 pha
 lda $04
 pha
 lda $05
 pha
 lda $a021
 and #$7f
 cmp #$02
 beq $cf32
 lda $a02a
 ldx $a02b
 sta $02
 stx $03
 lda $a02c
 ldx $a02d
 bra $cf48
 lda $a02b
 lsr
 tax
 lda $a02a
 ror
 sta $02
 stx $03
 lda $a02d
 lsr
 tax
 lda $a02c
 ror
 sta $04
 stx $05
 lda #$00
 jsr $f9bd
 pla
 sta $05
 pla
 sta $04
 pla
 sta $03
 pla
 sta $02
 jsr $c8cc
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 lda $a02a
 sta $00,x
 lda $a02b
 sta $01,x
 lda $a02c
 sta $02,x
 lda $a02d
 sta $03,x
 lda $a02e
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 cpy #$00
 ldy #$00
 bcc $cfac
 dey
 brk
 sty $00
 .byte $82,$00
 sta ($00,x)
 bra $cf36
 bra $cff8
 nop
 cpx #$92
 brk
 lda #$00
 cmp #$00
 sty $80
 tsb $80
 nop
 bra $cf87
 brk
 cpx #$00
 beq $cfcc
 sed
 brk
 .byte $fc,$00,$fe
 brk
 bbs7 $00,$cfd4
 bra $cfd6
 cpy #$ff
 cpx #$fe
 brk
 bbs6 $00,$cfae
 brk
 smb0 $80
 rmb0 $80
 nop
 bra $cfef
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 lda #$af
 sta $9f73
 lda #$00
 sta $9f71
 lda #$08
 sta $9f71
 lda #$00
 sta $9f71
 ldx #$00
 ldy #$08
 lda $9f71
 cmp #$40
 rol $a034,x
 and #$10
 cmp #$10
 rol $a031,x
 lda #$20
 sta $9f71
 lda #$00
 sta $9f71
 dey
 bne $d016
 inx
 cpx #$03
 bne $d014
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 tax
 bne $d07c
 lda $a031
 ldx $a032
 ldy $a033
 beq $d085
 lda $a030
 ldx #$01
 ldy #$00
 bra $d085
 lda $a034
 ldx $a035
 ldy $a036
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 ldy $a030
 bne $d0a3
 dec $a030
 pha
 php
 cpx #$00
 bne $d0c9
 cmp #$14
 bne $d0b1
 lda #$80
 bne $d0eb
 cmp #$11
 bne $d0b9
 lda #$40
 bne $d0eb
 cmp #$29
 bne $d0c1
 lda #$20
 bne $d0eb
 cmp #$5a
 bne $d0d5
 lda #$10
 bne $d0eb
 cpx #$e0
 bne $d108
 cmp #$6b
 bne $d0d5
 lda #$02
 bne $d0eb
 cmp #$74
 bne $d0dd
 lda #$01
 bne $d0eb
 cmp #$75
 bne $d0e5
 lda #$08
 bne $d0eb
 cmp #$72
 bne $d108
 lda #$04
 plp
 php
 bcc $d0fa
 sta $a02f
 lda $a030
 ora $a02f
 bra $d105
 eor #$ff
 sta $a02f
 lda $a030
 and $a02f
 sta $a030
 plp
 pla
 rts
 jsr $df4d
 and $02c0
 rts
 bit $0267
 bpl $d121
 jsr $d1bc
 jsr $df4d
 brk
 cpy #$02
 rts
 jmp $d2cf
 bit $0267
 bvc $d130
 jsr $df4d
 nop
 cpy #$02
 rts
 jmp $d2de
 bit $0267
 bvc $d13f
 jsr $df4d
 asl $c0
 .byte $02,$60
 jmp $d32f
 bit $0267
 bpl $d14e
 jsr $df4d
 ora #$c0
 .byte $02,$60
 jmp $d2f5
 bit $0267
 bvc $d15d
 jsr $df4d
 tsb $02c0
 rts
 jmp $d30a
 bit $0267
 bpl $d16c
 jsr $df4d
 bbr0 $c0,$d16d
 rts
 jmp $d31a
 pha
 jsr $df4d
 ora ($c0)
 .byte $02,$b0
 asl
 lda $0267
 ora #$80
 sta $0267
 pla
 rts
 lda $0267
 and #$7f
 sta $0267
 pla
 jmp $d21b
 pha
 jsr $df4d
 ora $c0,x
 .byte $02,$b0
 asl
 lda $0267
 ora #$40
 sta $0267
 pla
 rts
 lda $0267
 and #$bf
 sta $0267
 pla
 jmp $d217
 bit $0267
 bvs $d1b4
 sec
 rts
 jsr $df4d
 nop
 cpy #$02
 clc
 rts
 pha
 and #$f0
 cmp #$e0
 beq $d1c5
 pla
 rts
 ldx #$02
 lda $00,x
 pha
 inx
 cpx #$09
 bne $d1c7
 jsr $dbca
 lda $02
 bne $d1d9
 dec
 bra $d1dc
 sec
 sbc #$50
 sta $02
 jsr $df4d
 bmi $d1a3
 .byte $02,$a2
 php
 pla
 sta $00,x
 dex
 cpx #$01
 bne $d1e6
 pla
 rts
 lda $0267
 bit #$20
 beq $d20d
 pha
 and #$f0
 sta $0267
 pla
 inc
 and #$0f
 ora $0267
 sta $0267
 and #$08
 sta $9fbf
 rts
 lda $0267
 and #$10
 sta $9fbf
 rts
 bra $d221
 rti
 bra $d21d
 ora #$20
 pha
 bit $025c
 bpl $d230
 sec
 ror $025e
 jsr $d251
 lsr $025c
 lsr $025e
 pla
 sta $025d
 sei
 jsr $d3bb
 cmp #$3f
 bne $d23f
 jsr $d3a9
 lda $d216
 ora #$08
 sta $d216
 sei
 jsr $d3b2
 jsr $d3bb
 jsr $d3d7
 sei
 jsr $d3bb
 jsr $d3cd
 bcs $d2c2
 jsr $d3a9
 bit $025e
 bpl $d26c
 jsr $d3cd
 bcc $d262
 jsr $d3cd
 bcs $d267
 jsr $d3cd
 bcc $d26c
 jsr $d3b2
 lda #$08
 sta $0260
 lda $d216
 cmp $d216
 bne $d279
 asl
 bcc $d2c6
 ror $025d
 bcs $d28e
 jsr $d3c4
 bne $d291
 jsr $d3bb
 jsr $d3a9
 nop
 nop
 nop
 nop
 lda $d216
 and #$df
 ora #$10
 sta $d216
 dec $0260
 bne $d279
 lda #$04
 sta $9f69
 lda #$19
 sta $ffff
 lda $ffff
 lda $ffff
 and #$02
 bne $d2c6
 jsr $d3cd
 bcs $d2b4
 cli
 rts
 lda #$80
 bra $d2c8
 lda #$03
 jsr $d6b7
 cli
 clc
 bcc $d31f
 sta $025d
 jsr $d247
 lda $d216
 and #$f7
 sta $d216
 rts
 sta $025d
 jsr $d247
 sei
 jsr $d3c4
 jsr $d2d5
 jsr $d3a9
 jsr $d3cd
 bmi $d2ee
 cli
 rts
 bit $025c
 bmi $d300
 sec
 ror $025c
 bne $d305
 pha
 jsr $d251
 pla
 sta $025d
 clc
 rts
 sei
 jsr $d3b2
 lda $d216
 ora #$08
 sta $d216
 lda #$5f
 bra $d31c
 lda #$3f
 jsr $d21d
 jsr $d2d5
 txa
 ldx #$0a
 dex
 bne $d325
 tax
 jsr $d3a9
 jmp $d3bb
 sei
 lda #$00
 sta $0260
 jsr $d3a9
 jsr $d3cd
 bpl $d338
 lda #$01
 sta $9f69
 lda #$19
 sta $ffff
 jsr $d3bb
 lda $ffff
 lda $ffff
 and #$02
 bne $d35b
 jsr $d3cd
 bmi $d34d
 bpl $d375
 lda $0260
 beq $d365
 lda #$02
 jmp $d2c8
 jsr $d3c4
 jsr $d3a9
 lda #$40
 jsr $d6b7
 inc $0260
 bne $d33d
 lda #$08
 sta $0260
 lda $d216
 cmp $d216
 bne $d37a
 asl
 bpl $d37a
 ror $025f
 lda $d216
 cmp $d216
 bne $d388
 asl
 bmi $d388
 dec $0260
 bne $d37a
 jsr $d3c4
 bit $0286
 bvc $d3a3
 jsr $d322
 lda $025f
 cli
 clc
 rts
 lda $d216
 and #$ef
 sta $d216
 rts
 lda $d216
 ora #$10
 sta $d216
 rts
 lda $d216
 and #$df
 sta $d216
 rts
 lda $d216
 ora #$20
 sta $d216
 rts
 lda $d216
 cmp $d216
 bne $d3cd
 asl
 rts
 txa
 ldx #$b8
 dex
 bne $d3da
 tax
 rts
 ldx $03
 phx
 ldx $05
 beq $d3f2
 ldy #$00
 sta ($02),y
 iny
 bne $d3e8
 inc $03
 dex
 bne $d3e8
 ldy $04
 beq $d3fd
 dey
 sta ($02),y
 cpy #$00
 bne $d3f6
 plx
 stx $03
 rts
 lda $06
 ora $07
 beq $d43e
 lda $02
 pha
 lda $05
 pha
 lda $03
 cmp $05
 bne $d417
 lda $02
 cmp $04
 bcc $d43f
 ldy #$00
 ldx $07
 beq $d42d
 lda ($02),y
 sta ($04),y
 iny
 bne $d41f
 inc $03
 inc $05
 dex
 bne $d41f
 cpy $06
 beq $d438
 lda ($02),y
 sta ($04),y
 iny
 bra $d42d
 pla
 sta $05
 pla
 sta $02
 rts
 lda $07
 clc
 adc $03
 sta $03
 lda $07
 clc
 adc $05
 sta $05
 ldx $07
 ldy $06
 beq $d45b
 dey
 lda ($02),y
 sta ($04),y
 tya
 bne $d453
 dec $03
 dec $05
 txa
 beq $d438
 dey
 lda ($02),y
 sta ($04),y
 tya
 bne $d462
 dex
 bra $d45b
 lda #$ff
 sta $06
 sta $07
 lda $03
 pha
 lda $05
 beq $d48e
 pha
 ldy #$00
 lda ($02),y
 jsr $d4a0
 iny
 bne $d47d
 inc $03
 dec $05
 bne $d47d
 pla
 sta $05
 ldy $04
 beq $d49c
 dey
 lda ($02),y
 jsr $d4a0
 cpy #$00
 bne $d492
 pla
 sta $03
 rts
 eor $07
 sta $07
 lsr
 lsr
 lsr
 lsr
 tax
 asl
 eor $06
 sta $06
 txa
 eor $07
 sta $07
 asl
 asl
 asl
 tax
 asl
 asl
 eor $07
 sta $07
 txa
 rol
 eor $06
 ldx $07
 sta $07
 stx $06
 rts
 ldx #$e3
 ldy #$d4
 clc
 stx $80
 sty $81
 ldy #$1f
 lda $0314,y
 bcs $d4da
 lda ($80),y
 sta ($80),y
 sta $0314,y
 dey
 bpl $d4d3
 rts
 bit $e0,x
 ora ($e0)
 asl
 cpx #$c0
 cld
 bne $d4c4
 nop
 smb0 $8a
 smb0 $a5
 cld
 cmp $d6,x
 ora ($d7),y
 stz $db,x
 ldx $a0d6,y
 cld
 ora ($e0)
 bvc $d4da
 smb0 $da
 bcc $d50e
 ldx $0259
 ldy $025a
 lda $025b
 sta $025b
 stx $0259
 sty $025a
 rts
 bcc $d520
 ldx $0257
 ldy $0258
 stx $0257
 sty $0258
 rts
 ldx #$60
 ldy #$9f
 rts
 lda $06
 pha
 lda $07
 pha
 ldy #$00
 sty $0253
 jsr $d625
 pha
 and #$18
 beq $d56d
 cmp #$18
 bcc $d55a
 jsr $d5fa
 adc #$02
 cmp #$12
 bcc $d55d
 jsr $d625
 sbc #$ee
 jmp $d55d
 jsr $d621
 tay
 bcs $d560
 lsr
 lsr
 lsr
 tax
 bcs $d554
 txa
 beq $d564
 iny
 jsr $d614
 dex
 bne $d564
 dey
 bne $d564
 pla
 pha
 asl
 bcs $d586
 asl
 bcs $d57e
 ldx #$ff
 jsr $d5e9
 ora #$e0
 bne $d599
 rol
 rol
 and #$01
 eor #$ff
 bne $d595
 asl
 bcs $d590
 jsr $d5e9
 adc #$de
 bne $d595
 bmi $d59f
 jsr $d625
 tax
 jsr $d625
 sta $0255
 stx $0256
 clc
 lda $04
 adc $0255
 sta $06
 lda $0256
 adc $05
 sta $07
 pla
 and #$07
 adc #$01
 cmp #$09
 bcc $d5c5
 jsr $d5fa
 adc #$08
 cmp #$18
 bcc $d5c5
 jsr $d625
 sbc #$e8
 tax
 bcc $d5ce
 beq $d5f3
 jsr $d621
 tay
 txa
 beq $d5d2
 iny
 lda ($06)
 jsr $d617
 inc $06
 beq $d5e4
 dex
 bne $d5d2
 dey
 bne $d5d2
 jmp $d537
 inc $07
 jmp $d5db
 eor #$80
 asl
 php
 jsr $d5fa
 plp
 rol
 rts
 pla
 sta $07
 pla
 sta $06
 rts
 lda $0254
 lsr $0253
 bcc $d605
 and #$0f
 rts
 inc $0253
 jsr $d625
 sta $0254
 lsr
 lsr
 lsr
 lsr
 sec
 rts
 jsr $d625
 sta ($04)
 inc $04
 beq $d61e
 rts
 inc $05
 rts
 jsr $d625
 tax
 lda ($02)
 inc $02
 beq $d62c
 rts
 inc $03
 rts
 clc
 rts
 clc
 rts
 sta $028b
 clc
 rts
 sta $028a
 clc
 rts
 rts
 rts
 ora $2f49
 bbr4 $20,$d68a
 eor ($52)
 bbr4 $52,$d66a
 nop
 ora $4553
 eor ($52,x)
 nop
 pha
 eor #$4e
 rmb0 $a0
 lsr $4f
 eor ($a0)
 jsr $5246
 bbr4 $4d,$d680
 ldy $20
 .byte $54,$4f
 jsr $0da4
 jmp $414f
 .byte $44,$49
 lsr $0dc7
 nop
 eor ($56,x)
 eor #$4e
 rmb0 $a0
 ora $4556
 eor ($49)
 lsr $59
 eor #$4e
 smb0 $0d
 lsr $4f
 eor $4e,x
 .byte $44,$a0
 ora $4b4f
 sta $8c2c
 .byte $02,$10
 ora $3fb9
 dec $08,x
 and #$7f
 jsr $ffd2
 iny
 plp
 bpl $d690
 clc
 rts
 sta $028e
 stx $8c
 sty $8d
 rts
 sta $028f
 stx $0291
 sty $0290
 rts
 sta $028c
 lda $0286
 ora $0286
 sta $0286
 rts
 lda $028a
 bne $d6c6
 jmp $c995
 cmp #$02
 bne $d6e9
 sty $0288
 jsr $d63e
 ldy $0288
 clc
 rts
 lda $028a
 bne $d6e9
 lda $0380
 sta $037a
 lda $0383
 sta $0379
 jmp $c156
 cmp #$03
 bne $d6f9
 sta $037f
 lda $0382
 sta $0378
 jmp $c156
 bcs $d701
 cmp #$02
 beq $d70d
 sec
 rts
 lda $0286
 beq $d70a
 lda #$0d
 clc
 rts
 jmp $d133
 jsr $d6ca
 brk
 pha
 lda $028b
 cmp #$03
 bne $d71d
 pla
 jmp $c28c
 bcc $d723
 pla
 jmp $d142
 lsr
 pla
 sta $028d
 txa
 pha
 tya
 pha
 bcc $d73d
 bcs $d731
 clc
 pla
 tay
 pla
 tax
 lda $028d
 bcc $d73c
 lda #$00
 rts
 jsr $d63d
 jmp $d730
 jsr $d816
 beq $d74b
 jmp $db8a
 jsr $d828
 lda $0291
 beq $d76a
 cmp #$03
 beq $d76a
 bcs $d76f
 cmp #$02
 bne $d760
 jmp $d638
 ldx $0290
 cpx #$60
 beq $d76a
 jmp $db96
 sta $028a
 clc
 rts
 tax
 jsr $d18e
 lda $0290
 bpl $d77e
 jsr $d2e4
 jmp $d781
 jsr $d124
 txa
 bit $0286
 bpl $d76a
 jmp $db92
 jsr $d816
 beq $d792
 jmp $db8a
 jsr $d828
 lda $0291
 bne $d79d
 jmp $db9a
 cmp #$03
 beq $d7b1
 bcs $d7b6
 cmp #$02
 bne $d7aa
 jmp $d633
 ldx $0290
 cpx #$60
 beq $d79a
 sta $028b
 clc
 rts
 tax
 jsr $d16f
 lda $0290
 bpl $d7c4
 jsr $d2d5
 bne $d7c7
 jsr $d112
 txa
 bit $0286
 bpl $d7b1
 jmp $db92
 jsr $d81c
 beq $d7d7
 clc
 rts
 jsr $d828
 txa
 pha
 lda $0291
 beq $d7f5
 cmp #$03
 beq $d7f5
 bcs $d7f2
 cmp #$02
 bne $d7d5
 pla
 jsr $d7f6
 jmp $d631
 jsr $db31
 pla
 tax
 dec $0289
 cpx $0289
 beq $d814
 ldy $0289
 lda $0268,y
 sta $0268,x
 lda $0272,y
 sta $0272,x
 lda $027c,y
 sta $027c,x
 clc
 rts
 lda #$00
 sta $0286
 txa
 ldx $0289
 dex
 bmi $d83a
 cmp $0268,x
 bne $d81f
 rts
 lda $0268,x
 sta $028f
 lda $0272,x
 sta $0291
 lda $027c,x
 sta $0290
 rts
 sta $0291
 cmp $028b
 bne $d84a
 lda #$03
 sta $028b
 bra $d84d
 cmp $028a
 bne $d854
 lda #$00
 sta $028a
 lda $0291
 ldx $0289
 dex
 bmi $d86a
 cmp $0272,x
 bne $d85a
 lda $0268,x
 jsr $ffc3
 bcc $d854
 rts
 tya
 ldx $0289
 dex
 bmi $d883
 cmp $027c,x
 bne $d86f
 jsr $d88d
 tax
 lda $028f
 ldy $0290
 clc
 rts
 sec
 rts
 tax
 jsr $d816
 beq $d877
 bne $d883
 lda $0268,x
 sta $028f
 lda $027c,x
 sta $0290
 lda $0272,x
 sta $0291
 rts
 lda #$00
 sta $0289
 ldx #$03
 cpx $028b
 bcs $d8af
 jsr $d160
 cpx $028a
 bcs $d8b7
 jsr $d151
 stx $028b
 lda #$00
 sta $028a
 rts
 ldx $028f
 bne $d8c8
 jmp $db96
 jsr $d816
 bne $d8d0
 jmp $db86
 ldx $0289
 cpx #$0a
 bcc $d8da
 jmp $db82
 inc $0289
 lda $028f
 sta $0268,x
 lda $0290
 ora #$60
 sta $0290
 sta $027c,x
 lda $0291
 sta $0272,x
 beq $d90b
 cmp #$03
 beq $d90b
 bcc $d901
 jsr $d90d
 bcc $d90b
 cmp #$02
 bne $d908
 jmp $d62f
 jmp $dba2
 clc
 rts
 lda $0290
 bmi $d90b
 ldy $028e
 beq $d90b
 lda #$00
 sta $0286
 lda $0291
 jsr $d16f
 lda $0290
 ora #$f0
 jsr $d112
 lda $0286
 bpl $d934
 pla
 pla
 jmp $db92
 lda $028e
 beq $d946
 ldy #$00
 lda ($8c),y
 jsr $d142
 iny
 cpy $028e
 bne $d93b
 jmp $db46
 stx $8e
 sty $8f
 jmp ($0330)
 and #$1f
 sta $0287
 dec $0287
 lda #$00
 sta $0286
 lda $0291
 bne $d968
 jmp $dba2
 jmp $db8e
 cmp #$04
 bcc $d962
 ldy $028e
 bne $d97a
 ldx #$c3
 ldy #$da
 lda #$02
 jsr $d69f
 ldx $0290
 jsr $da55
 lda #$60
 sta $0290
 jsr $d90d
 lda $0291
 jsr $d18e
 lda $0290
 jsr $d124
 jsr $d133
 sta $8a
 lda $0286
 lsr
 lsr
 bcs $d965
 jsr $d133
 sta $8b
 txa
 bne $d9b0
 lda $8e
 sta $8a
 lda $8f
 sta $8b
 jsr $da7c
 ldy $0287
 beq $d9ef
 bpl $d9dc
 jsr $ffe1
 beq $d9fc
 ldx $8a
 ldy $8b
 lda #$00
 jsr $d1ad
 bcs $d9ef
 txa
 clc
 adc $8a
 sta $8a
 tya
 adc $8b
 sta $8b
 bit $0286
 bvc $d9ba
 bra $da31
 dey
 tya
 and #$01
 ora #$10
 sta $9f22
 lda $8a
 sta $9f20
 lda $8b
 sta $9f21
 lda #$fd
 and $0286
 sta $0286
 jsr $ffe1
 bne $d9ff
 jmp $db22
 jsr $d133
 tax
 lda $0286
 lsr
 lsr
 bcs $d9ef
 txa
 ldy $0287
 bmi $da22
 beq $da17
 sta $9f23
 bne $da26
 cmp ($8a),y
 beq $da26
 lda #$10
 jsr $d6b7
 bra $da26
 ldy #$00
 sta ($8a),y
 inc $8a
 bne $da2c
 inc $8b
 bit $0286
 bvc $d9ef
 jsr $d151
 jsr $db31
 jsr $dab5
 lda $0287
 clc
 bmi $da4e
 beq $da4e
 ldx $9f20
 ldy $9f21
 lda $9f22
 and #$01
 rts
 ldx $8a
 ldy $8b
 lda #$00
 rts
 lda $028c
 bpl $da7b
 ldy #$0c
 jsr $d690
 lda $028e
 beq $da7b
 ldy #$17
 jsr $d690
 ldy $028e
 beq $da7b
 ldy #$00
 lda ($8c),y
 jsr $ffd2
 iny
 cpy $028e
 bne $da70
 rts
 ldy #$27
 lda $0287
 bne $da85
 ldy #$37
 jsr $d68b
 bit $028c
 bpl $dab4
 lda $0287
 beq $dab4
 ldy #$1b
 jsr $d690
 lda $8b
 jsr $da9e
 lda $8a
 tax
 lsr
 lsr
 lsr
 lsr
 jsr $daa9
 txa
 and #$0f
 cmp #$0a
 bcc $daaf
 adc #$06
 adc #$30
 jmp $c28c
 rts
 bit $028c
 bpl $dab4
 lda $0287
 beq $dab4
 ldy #$22
 bne $da94
 dec
 rol
 stx $8a
 sty $8b
 tax
 lda $00,x
 sta $0292
 lda $01,x
 sta $0293
 jmp ($0332)
 lda $0291
 bne $dadf
 jmp $dba2
 cmp #$03
 beq $dadc
 bcc $dadc
 lda #$61
 sta $0290
 ldy $028e
 bne $daf2
 jmp $db9e
 jsr $d90d
 jsr $db4b
 lda $0291
 jsr $d16f
 lda $0290
 jsr $d112
 ldy #$00
 jsr $db58
 lda $88
 jsr $d142
 lda $89
 jsr $d142
 jsr $db63
 bcs $db2e
 lda ($88),y
 jsr $d142
 jsr $ffe1
 bne $db29
 jsr $db31
 lda #$00
 sec
 rts
 jsr $db6d
 bne $db13
 jsr $d160
 bit $0290
 bmi $db49
 lda $0291
 jsr $d16f
 lda $0290
 and #$ef
 ora #$e0
 jsr $d112
 jsr $d160
 clc
 rts
 lda $028c
 bpl $db4a
 ldy #$2f
 jsr $d690
 jmp $da69
 lda $0293
 sta $89
 lda $0292
 sta $88
 rts
 sec
 lda $88
 sbc $8a
 lda $89
 sbc $8b
 rts
 inc $88
 bne $db73
 inc $89
 rts
 jsr $ca31
 bne $db81
 php
 jsr $ffcc
 jsr $c962
 plp
 rts
 lda #$01
 bra $dba4
 lda #$02
 bra $dba4
 lda #$03
 bra $dba4
 lda #$04
 bra $dba4
 lda #$05
 bra $dba4
 lda #$06
 bra $dba4
 lda #$07
 bra $dba4
 lda #$08
 bra $dba4
 lda #$09
 pha
 jsr $ffcc
 ldy #$00
 bit $028c
 bvc $dbb9
 jsr $d690
 pla
 pha
 ora #$30
 jsr $ffd2
 pla
 sec
 rts
 jsr $dbde
 lda #$3c
 jsr $dc8d
 bne $dbc9
 jmp $dd71
 rts
 php
 sei
 jsr $ddf2
 jsr $dced
 plp
 rts
 php
 sei
 jsr $de2f
 jsr $dd2f
 plp
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 inc $a039
 bne $dc03
 inc $a038
 bne $dc03
 inc $a037
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 php
 sei
 lda $a039
 ldx $a038
 ldy $a037
 plp
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 php
 sei
 sta $a039
 stx $a038
 sty $a037
 plp
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 inc $a03d
 cmp $a03d
 bne $dcd7
 stz $a03d
 inc $a03c
 lda $a03c
 cmp #$3c
 bne $dcd7
 stz $a03c
 inc $a03b
 lda $a03b
 cmp #$3c
 bne $dcd7
 stz $a03b
 inc $a03a
 lda $a03a
 cmp #$18
 bne $dcd7
 stz $a03a
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 lda $a03a
 sta $05
 lda $a03b
 sta $06
 lda $a03c
 sta $07
 lda $a03d
 sta $08
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 lda $05
 sta $a03a
 lda $06
 sta $a03b
 lda $07
 sta $a03c
 lda $08
 sta $a03d
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 lda $a040
 ora $a03f
 ora $a03e
 beq $ddd0
 ldy $a03f
 lda $dde5,y
 cpy #$02
 bne $ddb1
 tay
 lda $a03e
 and #$03
 bne $ddb0
 lda $a03e
 beq $ddb0
 cmp #$c8
 beq $ddb0
 iny
 tya
 cmp $a040
 beq $ddbb
 inc $a040
 bra $ddd0
 ldy #$01
 sty $a040
 inc $a03f
 lda $a03f
 cmp #$0d
 bne $ddb1
 sty $a03f
 inc $a03e
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 bbr1 $1c,$de08
 asl $1e1f,x
 bbr1 $1f,$de0d
 bbr1 $1e,$de11
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 lda $a03e
 sta $02
 lda $a03f
 sta $03
 lda $a040
 sta $04
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 lda $02
 sta $a03e
 lda $03
 sta $a03f
 lda $04
 sta $a040
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 lda #$ff
 sta $9f64
 sta $9f65
 lda #$40
 sta $9f6b
 rts
 lda $9f65
 tax
 adc $9f64
 tay
 lda $9f64
 rts
 ldx #$ff
 sei
 txs
 jsr $de9b
 jsr $ded6
 jsr $d4c8
 jsr $c02b
 cli
 sec
 jmp $dff2
 jsr $dec9
 jsr $ca95
 jsr $de6c
 jsr $d3b2
 lda #$01
 sta $9f26
 rts
 lda #$01
 sta $9f27
 rts
 lda $9fbe
 cmp #$31
 bne $dec6
 lda $9fbf
 cmp #$36
 bne $dec6
 lda $9fbd
 bra $dec8
 lda #$00
 rts
 lda #$2a
 sta $9f20
 lda $9f20
 cmp #$2a
 bne $dec9
 rts
 lda #$ff
 sta $9f63
 sta $9f62
 ldx #$00
 stz $00,x
 stz $0200,x
 stz $0300,x
 inx
 bne $dee0
 ldx #$ef
 stz $a000,x
 dex
 bne $deed
 ldx #$20
 lda $fcda,x
 sta $02c3,x
 dex
 bne $def5
 ldx #$3f
 lda $fcfa,x
 sta $038a,x
 dex
 bne $df00
 stz $9f61
 ldx $a000
 inx
 lda #$01
 sta $9f61
 ldy $a000
 stx $a000
 stz $9f61
 cpx $a000
 sta $9f61
 sty $a000
 beq $df2c
 asl
 bne $df12
 tay
 stz $9f61
 dex
 stx $a000
 tya
 ldx #$00
 ldy #$9f
 clc
 jsr $d503
 ldx #$00
 ldy #$08
 clc
 jsr $d518
 lda #$01
 sta $9f61
 jmp $d10b
 pha
 php
 pha
 phx
 phy
 tsx
 lda $0106,x
 sta $82
 clc
 adc #$03
 sta $0106,x
 lda $0107,x
 sta $83
 adc #$00
 sta $0107,x
 ldy #$01
 lda ($82),y
 sta $02e2
 iny
 lda ($82),y
 sta $02e3
 cmp #$c0
 bcc $df89
 lda $9f60
 sta $0105,x
 iny
 lda ($82),y
 and #$07
 ply
 plx
 jmp $02c4
 lda $9f61
 sta $0105,x
 iny
 lda ($82),y
 sta $9f61
 ply
 plx
 pla
 plp
 jsr $02e1
 php
 pha
 phx
 tsx
 lda $0104,x
 sta $9f61
 plx
 pla
 plp
 plp
 rts
 sta $03af
 lda $9f61
 pha
 lda $9f60
 pha
 txa
 sta $9f61
 plx
 and #$07
 php
 sei
 jsr $03ab
 plp
 plx
 stx $9f61
 ora #$00
 rts
 sta $03b5
 lda $9f61
 pha
 stx $9f61
 jmp $03b4
 pha
 lda $9f61
 pha
 txa
 sta $9f61
 and #$07
 ldx $9f60
 jmp $03bd
 pla
 tax
 pla
 sta $9f61
 txa
 pha
 plp
 rts
 bcc $dffa
 jsr $df4d
 brk
 cpy #$04
 jsr $df4d
 nop
 cpy #$04
 jsr $df4d
 brk
 cpy #$05
 sei
 jmp ($0318)
 pha
 phx
 phy
 jsr $ffe1
 bne $e01f
 jsr $d4c8
 jsr $de9b
 jsr $c02b
 clc
 jmp $dff2
 ply
 plx
 pla
 rti
 pha
 phx
 phy
 tsx
 lda $0104,x
 and #$10
 beq $e031
 jmp ($0316)
 jmp ($0314)
 jsr $ce21
 jsr $cfe6
 jsr $dbbc
 jsr $c66b
 jsr $cb43
 jsr $d1f0
 jsr $dead
 ply
 plx
 pla
 rti
 lda #$03
 sta $028b
 lda #$00
 sta $028a
 jmp $c6f1
 pha
 txa
 pha
 tya
 pha
 ldy #$00
 tsx
 inc $0104,x
 bne $e06a
 inc $0105,x
 lda $0104,x
 sta $82
 lda $0105,x
 sta $83
 lda ($82),y
 beq $e07d
 jsr $ffd2
 bcc $e061
 pla
 tay
 pla
 tax
 pla
 rts
 lda $02
 ora $03
 bne $e091
 lda #$01
 sta $02
 lda #$fa
 sta $03
 ldy #$1b
 lda ($02),y
 sta $02e4,y
 dey
 bpl $e093
 jsr $fef6
 jsr $e116
 lda #$00
 ldx #$0a
 ldy #$01
 jsr $e18e
 jsr $e0b0
 jmp $ee9d
 lda $0264
 pha
 lda $0265
 pha
 lda $0266
 sta $0264
 sta $0265
 lda $029f
 sta $02
 lda $02a0
 sta $03
 lda $029b
 sta $04
 stz $05
 lda $02a1
 sta $06
 lda $02a2
 sta $07
 lda $06
 sec
 sbc $02
 sta $06
 lda $07
 sbc $03
 sta $07
 inc $06
 bne $e0ef
 inc $07
 lda $029d
 sta $08
 stz $09
 lda $08
 sec
 sbc $04
 sta $08
 lda $09
 sbc $05
 sta $09
 inc $08
 bne $e109
 inc $09
 sec
 jsr $e40b
 pla
 sta $0265
 pla
 sta $0264
 rts
 jsr $fef9
 lda $02
 sta $06
 lda $03
 sta $07
 lda $04
 sta $08
 lda $05
 sta $09
 lda #$00
 sta $02
 sta $03
 sta $04
 sta $05
 lda $02
 ora $03
 ora $04
 ora $05
 ora $06
 ora $07
 ora $08
 ora $09
 beq $e116
 lda $02
 sta $029f
 lda $03
 sta $02a0
 lda $04
 sta $029b
 lda $05
 sta $029c
 lda $02
 clc
 adc $06
 sta $02a1
 lda $03
 adc $07
 sta $02a2
 lda $02a1
 bne $e170
 dec $02a2
 dec $02a1
 lda $04
 clc
 adc $08
 sta $029d
 lda $05
 adc $09
 sta $029e
 lda $029d
 bne $e18a
 dec $029e
 dec $029d
 rts
 sta $0264
 stx $0265
 sty $0266
 rts
 lda $05
 cmp $09
 bne $e1a2
 lda $04
 cmp $08
 bne $e1a7
 jmp $e364
 lda $03
 cmp $07
 bne $e1b1
 lda $02
 cmp $06
 bne $e1b6
 jmp $e3c8
 php
 stz $11
 lda $08
 sec
 sbc $04
 sta $10
 bcs $e1c9
 lda #$00
 sec
 sbc $10
 sta $10
 lda $06
 sec
 sbc $02
 sta $1a
 lda $07
 sbc $03
 sta $1b
 ldx #$1a
 jsr $e34c
 lda $1b
 cmp $11
 bne $e1e5
 lda $1a
 cmp $10
 bcs $e1ea
 jmp $e297
 lda $10
 asl
 sta $14
 lda $11
 rol
 sta $15
 lda $14
 sec
 sbc $1a
 sta $12
 lda $15
 sbc $1b
 sta $13
 lda $10
 sec
 sbc $1a
 sta $16
 lda $11
 sbc $1b
 sta $17
 asl $16
 rol $17
 lda #$ff
 sta $1c
 lda $03
 cmp $07
 bne $e220
 lda $02
 cmp $06
 bcc $e242
 lda $04
 cmp $08
 bcc $e22c
 lda #$01
 sta $1c
 ldy $03
 ldx $02
 lda $06
 sta $02
 lda $07
 sta $03
 sty $07
 stx $06
 lda $08
 sta $04
 bra $e24c
 ldy $08
 cpy $04
 bcc $e24c
 lda #$01
 sta $1c
 lda $0264
 plp
 php
 jsr $feff
 lda $0264
 jsr $ff0b
 lda $03
 cmp $07
 bne $e264
 lda $02
 cmp $06
 bcs $e295
 inc $02
 bne $e26c
 inc $03
 bit $13
 bpl $e27f
 lda $14
 clc
 adc $12
 sta $12
 lda $15
 adc $13
 sta $13
 bra $e24c
 lda $1c
 clc
 adc $04
 sta $04
 lda $16
 clc
 adc $12
 sta $12
 lda $17
 adc $13
 sta $13
 bra $e24c
 plp
 rts
 lda $1a
 asl
 sta $14
 lda $1b
 rol
 sta $15
 lda $14
 sec
 sbc $10
 sta $12
 lda $15
 sbc $11
 sta $13
 lda $1a
 sec
 sbc $10
 sta $16
 lda $1b
 sbc $11
 sta $17
 asl $16
 rol $17
 lda #$ff
 sta $1c
 sta $1d
 lda $04
 cmp $08
 bcc $e2f1
 lda $03
 cmp $07
 bne $e2d5
 lda $02
 cmp $06
 bcc $e2df
 lda #$01
 sta $1c
 lda #$00
 sta $1d
 lda $06
 sta $02
 lda $07
 sta $03
 ldx $04
 lda $08
 sta $04
 stx $08
 bra $e305
 lda $03
 cmp $07
 bne $e2fb
 lda $02
 cmp $06
 bcs $e305
 lda #$01
 sta $1c
 lda #$00
 sta $1d
 lda $0264
 plp
 php
 jsr $feff
 lda $0264
 jsr $ff0b
 lda $04
 cmp $08
 bcs $e34a
 inc $04
 bit $13
 bpl $e32e
 lda $14
 clc
 adc $12
 sta $12
 lda $15
 adc $13
 sta $13
 bra $e305
 lda $1c
 clc
 adc $02
 sta $02
 lda $1d
 adc $03
 sta $03
 lda $16
 clc
 adc $12
 sta $12
 lda $17
 adc $13
 sta $13
 bra $e305
 plp
 rts
 lda $01,x
 bmi $e351
 rts
 lda $01,x
 eor #$ff
 sta $01,x
 lda $00,x
 eor #$ff
 sta $00,x
 inc $00,x
 bne $e363
 inc $01,x
 rts
 lda $06
 sec
 sbc $02
 lda $07
 sbc $03
 bcs $e37f
 lda $02
 ldx $06
 stx $02
 sta $06
 lda $03
 ldx $07
 stx $03
 sta $07
 jsr $feff
 lda $06
 sta $20
 lda $07
 sta $21
 lda $20
 sec
 sbc $02
 sta $20
 lda $21
 sbc $03
 sta $21
 inc $20
 bne $e39d
 inc $21
 lda $02
 pha
 lda $03
 pha
 lda $04
 pha
 lda $05
 pha
 lda $20
 sta $02
 lda $21
 sta $03
 stz $04
 stz $05
 lda $0264
 jsr $ff17
 pla
 sta $05
 pla
 sta $04
 pla
 sta $03
 pla
 sta $02
 rts
 lda $08
 cmp $04
 bcs $e3d4
 ldx $04
 stx $08
 sta $04
 lda $08
 sec
 sbc $04
 tax
 inx
 beq $e40a
 jsr $feff
 lda $02
 pha
 lda $03
 pha
 lda $04
 pha
 lda $05
 pha
 lda #$40
 sta $04
 lda #$01
 sta $05
 stx $02
 stz $03
 lda $0264
 jsr $ff17
 pla
 sta $05
 pla
 sta $04
 pla
 sta $03
 pla
 sta $02
 rts
 php
 lda $06
 ora $07
 bne $e414
 plp
 rts
 lda $08
 ora $09
 beq $e412
 plp
 bcc $e473
 lda $04
 pha
 lda $05
 pha
 lda $08
 pha
 lda $09
 pha
 jsr $feff
 lda $02
 pha
 lda $03
 pha
 lda $04
 pha
 lda $05
 pha
 lda $06
 sta $02
 lda $07
 sta $03
 stz $04
 stz $05
 lda $0265
 jsr $ff17
 pla
 sta $05
 pla
 sta $04
 pla
 sta $03
 pla
 sta $02
 jsr $ff02
 lda $08
 bne $e45f
 dec $09
 dec $08
 lda $08
 ora $09
 bne $e42c
 pla
 sta $09
 pla
 sta $08
 pla
 sta $05
 pla
 sta $04
 lda $06
 pha
 lda $07
 pha
 lda $08
 pha
 lda $09
 pha
 lda $02
 clc
 adc $06
 sta $06
 lda $03
 adc $07
 sta $07
 lda $06
 bne $e492
 dec $07
 dec $06
 lda $04
 clc
 adc $08
 sta $08
 lda $05
 adc $09
 sta $09
 lda $08
 bne $e4a7
 dec $09
 dec $08
 jsr $e364
 lda $04
 pha
 lda $08
 sta $04
 jsr $e364
 pla
 sta $04
 lda $02
 pha
 lda $03
 pha
 jsr $e3c8
 lda $06
 sta $02
 lda $07
 sta $03
 jsr $e3c8
 pla
 sta $03
 pla
 sta $02
 pla
 sta $09
 pla
 sta $08
 pla
 sta $07
 pla
 sta $06
 rts
 lda $02
 pha
 lda $03
 pha
 lda $04
 pha
 lda $05
 pha
 lda $0a
 pha
 lda $0b
 pha
 jsr $feff
 lda $06
 sta $02
 lda $07
 sta $03
 lda $08
 sta $04
 lda $09
 sta $05
 jsr $ff0e
 lda $0a
 bne $e50e
 dec $0b
 dec $0a
 lda $08
 clc
 adc $02
 sta $02
 lda $09
 adc $03
 sta $03
 jsr $ff02
 lda $0a
 ora $0b
 bne $e505
 pla
 sta $0b
 pla
 sta $0a
 pla
 sta $05
 pla
 sta $04
 pla
 sta $03
 pla
 sta $02
 rts
 lda $09
 cmp $05
 bne $e543
 lda $08
 cmp $04
 bcc $e587
 lda $0c
 clc
 adc $04
 sta $04
 lda $0d
 adc $05
 sta $05
 lda $0c
 clc
 adc $08
 sta $08
 lda $0d
 adc $09
 sta $09
 inc $0c
 bne $e565
 inc $0d
 jsr $ff1d
 lda $04
 bne $e56e
 dec $05
 dec $04
 lda $08
 bne $e576
 dec $09
 dec $08
 lda $0c
 bne $e57e
 dec $0d
 dec $0c
 lda $0c
 ora $0d
 bne $e565
 rts
 jsr $ff1d
 inc $04
 bne $e590
 inc $05
 inc $08
 bne $e596
 inc $09
 lda $0c
 bne $e59c
 dec $0d
 dec $0c
 lda $0c
 ora $0d
 bne $e587
 rts
 brk
 brk
 ora ($03,x)
 nop
 asl $07
 rmb0 $07
 tsb $0f0d
 bbr0 $0e,$e5c3
 bbr0 $0f,$e5cf
 ora $1b1b,y
 asl $1f1f,x
 bbr1 $1c,$e5dd
 bbr1 $1f,$e5e1
 bbr1 $1f,$e5e5
 bmi $e5f9
 nop
 nop
 rol $37,x
 rmb0 $37
 bit $3f3d,x
 bbr3 $3e,$e613
 bbr3 $3f,$e60f
 and $3b3b,y
 rol $3f3f,x
 bbr3 $3c,$e61d
 bbr3 $3f,$e621
 bbr3 $3f,$e625
 rts
 adc ($63,x)
 nop
 ror $67
 rmb0 $67
 jmp ($6f6d)
 adc $7b7b,y
 ror $7f7f,x
 nop
 nop
 ror $77,x
 rmb0 $77
 jmp ($7f7d,x)
 adc $7b7b,y
 ror $7f7f,x
 cpy #$c1
 nop
 nop
 dec $c7
 smb0 $c7
 cpy $cfcd
 bbs4 $ce,$e603
 bbs4 $cf,$e60f
 cmp $dbdb,y
 dec $dfdf,x
 bbs5 $dc,$e61d
 bbs5 $df,$e621
 bbs5 $df,$e625
 beq $e639
 nop
 nop
 inc $f7,x
 smb0 $f7
 .byte $fc,$fd,$ff
 sbc $fbfb,y
 inc $ffff,x
 cpx #$e1
 nop
 nop
 inc $e7
 smb0 $e7
 cpx $efed
 bbs6 $ee,$e663
 bbs6 $ef,$e66f
 sbc $fbfb,y
 inc $ffff,x
 beq $e679
 nop
 nop
 inc $f7,x
 smb0 $f7
 .byte $fc,$fd,$ff
 sbc $fbfb,y
 inc $ffff,x
 cmp #$20
 bcc $e6bb
 cmp #$80
 bcc $e6b2
 cmp #$a0
 bcc $e6bb
 jsr $e6eb
 phx
 phy
 plx
 ply
 clc
 rts
 cmp #$04
 bne $e6c5
 txa
 ora #$80
 tax
 sec
 rts
 cmp #$06
 bne $e6cf
 txa
 ora #$40
 tax
 sec
 rts
 cmp #$0b
 bne $e6d9
 txa
 ora #$10
 tax
 sec
 rts
 cmp #$0c
 bne $e6e3
 txa
 ora #$08
 tax
 sec
 rts
 cmp #$92
 bne $e6e9
 ldx #$00
 sec
 rts
 sec
 sbc #$20
 jsr $e82d
 tay
 txa
 ldx $0297
 pha
 and #$40
 beq $e6fc
 iny
 pla
 and #$08
 beq $e70c
 inx
 inx
 iny
 iny
 lda $0294
 clc
 adc #$02
 rts
 lda $0294
 rts
 ldy $05
 iny
 sty $02ab
 sta $0c
 ldx #$00
 clc
 adc #$20
 jsr $e6eb
 tya
 pha
 lda $0c
 asl
 tay
 lda ($90),y
 sta $06
 and #$07
 sta $02b9
 lda $06
 and #$f8
 sta $08
 iny
 lda ($90),y
 sta $07
 pla
 clc
 adc $06
 sta $0f
 clc
 sbc $08
 lsr
 lsr
 lsr
 sta $09
 tax
 cpx #$03
 bcc $e74f
 ldx #$03
 lda $e825,x
 sta $1c
 lda $e829,x
 sta $1d
 lda $06
 lsr $07
 ror
 lsr $07
 ror
 lsr $07
 ror
 clc
 adc $0298
 sta $06
 lda $07
 adc $0299
 sta $07
 ldy $02b9
 lda $eb3f,y
 eor #$ff
 sta $02b8
 ldy $0f
 dey
 tya
 and #$07
 tay
 lda $eb47,y
 eor #$ff
 sta $11
 lda $029a
 tax
 and #$08
 beq $e794
 lda #$80
 sta $13
 lda $0c
 clc
 adc #$20
 jsr $e6eb
 sta $0d
 lda $05
 sec
 sbc $0d
 sta $05
 stx $17
 tya
 pha
 lda $19
 bmi $e7bd
 lda $02a2
 cmp $19
 bne $e7bb
 lda $02a1
 cmp $18
 lda $029a
 and #$10
 bne $e7c5
 tax
 txa
 lsr
 lsr
 sta $08
 clc
 adc $18
 sta $02b6
 lda $19
 adc #$00
 sta $02b7
 pla
 sta $02b4
 clc
 adc $02b6
 sta $18
 lda #$00
 adc $02b7
 sta $19
 bmi $e818
 lda $02a0
 cmp $19
 bne $e7f6
 lda $029f
 cmp $18
 bcs $e818
 jsr $e841
 ldx #$00
 lda $029a
 and #$20
 beq $e805
 dex
 stx $16
 clc
 rts
 pla
 sta $02b4
 clc
 adc $18
 sta $18
 bcc $e823
 inc $19
 sec
 rts
 lda $18
 sec
 sbc $08
 sta $18
 bcs $e823
 dec $19
 sec
 rts
 rol $5a3e
 sei
 cpx $ecec
 cpx $5fc9
 beq $e83d
 asl
 tay
 iny
 iny
 lda ($90),y
 dey
 dey
 sec
 sbc ($90),y
 rts
 lda $02b4
 rts
 lda $02b6
 ldx $02b7
 bmi $e853
 cpx $02a0
 bne $e851
 cmp $029f
 bcs $e859
 ldx $02a0
 lda $029f
 pha
 and #$f8
 sta $0a
 tay
 lda $04
 pha
 lda $05
 pha
 sty $02
 stx $03
 lda $05
 sta $04
 stz $05
 jsr $feff
 pla
 sta $05
 pla
 sta $04
 lda $02b7
 sta $08
 lsr $08
 lda $02b6
 ror
 lsr $08
 ror
 lsr $08
 ror
 sta $10
 lda $02a0
 lsr
 lda $029f
 ror
 lsr
 lsr
 sec
 sbc $10
 bpl $e89c
 lda #$00
 sta $02b5
 lda $02b6
 and #$07
 sta $10
 pla
 and #$07
 tay
 lda $eb3f,y
 sta $08
 eor #$ff
 sta $14
 ldy $18
 dey
 ldx $02a2
 lda $02a1
 cpx $19
 bne $e8c2
 cmp $18
 bcs $e8c5
 tay
 tya
 and #$07
 tax
 lda $eb47,x
 sta $0b
 eor #$ff
 sta $15
 tya
 sec
 sbc $0a
 bpl $e8da
 lda #$00
 lsr
 lsr
 lsr
 clc
 adc $02b5
 sta $12
 cmp $09
 bcs $e8e9
 lda $09
 cmp #$03
 bcs $e913
 cmp #$02
 bne $e8f3
 lda #$01
 asl
 asl
 asl
 asl
 sta $1a
 lda $10
 sec
 sbc $02b9
 clc
 adc #$08
 clc
 adc $1a
 tax
 lda $e91d,x
 clc
 adc #$4f
 tay
 lda #$00
 adc #$eb
 bne $e917
 lda #$eb
 ldy #$cb
 sta $1b
 sty $1a
 clc
 rts
 dec $3f3e,x
 rti
 eor ($42,x)
 nop
 .byte $44,$07
 asl $05
 tsb $03
 .byte $02,$01
 brk
 dec $4f48,x
 lsr $5d,x
 stz $6b
 adc ($3b)
 bit $2d,x
 rol $1f
 clc
 ora ($0a),y
 lda $029a
 bpl $e955
 ldy $05
 cpy $02ab
 beq $e94f
 dey
 cpy $02ab
 bne $e955
 lda $16
 eor #$ff
 sta $16
 lda $029a
 and #$10
 beq $e91b
 lda $17
 lsr
 bcs $e97c
 lsr
 bcs $e97c
 ldx $02b6
 bne $e96c
 dec $02b7
 dex
 stx $02b6
 ldx $18
 bne $e976
 dec $19
 dex
 stx $18
 jsr $e841
 lda $02a2
 cmp $02b7
 bne $e98a
 lda $02a1
 cmp $02b6
 bcc $e999
 lda $02a0
 cmp $19
 bne $e998
 lda $029f
 cmp $18
 rts
 sec
 rts
 ldx $02b5
 cpx $12
 beq $e9ba
 bcs $e9c1
 lda $14
 jsr $eafc
 inx
 cpx $12
 beq $e9b5
 lda #$ff
 jsr $eafc
 bra $e9a9
 lda $15
 jmp $eafc
 lda $14
 and $15
 jmp $eafc
 rts
 ldx $12
 lda #$00
 sta $02ac,x
 dex
 bpl $e9c6
 lda $13
 and #$7f
 bne $e9e3
 jsr $ea4a
 ldx $12
 lda $02ac,x
 sta $02a3,x
 dex
 bpl $e9d7
 inc $13
 rts
 cmp #$01
 beq $e9f7
 ldy $17
 dey
 beq $e9d2
 dey
 php
 jsr $ea4a
 jsr $ea1a
 plp
 beq $ea0f
 jsr $ea1a
 jsr $eb32
 jsr $ea4a
 lda $06
 sec
 sbc $0295
 sta $06
 lda $07
 sbc $0296
 sta $07
 jsr $eb32
 jsr $ea4a
 jsr $ea2a
 bra $e9d5
 lda $0295
 clc
 adc $06
 sta $06
 lda $0296
 adc $07
 sta $07
 rts
 ldy #$ff
 iny
 ldx #$07
 lda $02a3,y
 and $eb37,x
 beq $ea42
 lda $eb37,x
 eor #$ff
 and $02ac,y
 sta $02ac,y
 dex
 bpl $ea2f
 cpy $12
 bne $ea2c
 rts
 jsr $ea9b
 ldy #$ff
 iny
 ldx #$07
 lda $02a3,y
 and $eb37,x
 lda $02ac,y
 ora $eb37,x
 sta $02ac,y
 inx
 cpx #$08
 bne $ea72
 lda $02ab,y
 ora #$01
 sta $02ab,y
 bne $ea7b
 lda $02ac,y
 ora $eb37,x
 sta $02ac,y
 dex
 dex
 bpl $ea89
 lda $02ad,y
 ora #$80
 sta $02ad,y
 bne $ea92
 lda $02ac,y
 ora $eb37,x
 sta $02ac,y
 inx
 dex
 bpl $ea52
 cpy $12
 bne $ea4f
 rts
 lsr $02a3
 ror $02a4
 ror $02a5
 ror $02a6
 ror $02a7
 ror $02a8
 ror $02a9
 ror $02aa
 rts
 tay
 lda $05
 pha
 tya
 jsr $e710
 clc
 lda $029a
 and #$90
 beq $eac9
 jsr $e93d
 php
 jsr $eb32
 bit $13
 bpl $ead8
 jsr $e9c2
 bra $eadb
 jsr $ea1a
 plp
 lda $05
 cmp $029b
 bcc $eaef
 cmp $029d
 bcc $eaec
 bne $eaef
 jsr $e99b
 jsr $ff02
 inc $05
 dec $17
 bne $eabe
 pla
 sta $05
 rts
 ldy $02a3,x
 sty $02
 bit $16
 bmi $eb26
 lsr $029a
 php
 rol $029a
 plp
 bcs $eb1a
 phx
 ldx $0264
 and $02
 jsr $ff11
 plx
 rts
 ldy $0266
 phx
 ldx $0264
 jsr $ff14
 plx
 rts
 ldy $0265
 phx
 ldx $0264
 jsr $ff14
 plx
 rts
 ldy #$00
 jmp ($001c)
 ora ($02,x)
 tsb $08
 bpl $eb5d
 rti
 bra $eb40
 bra $eb02
 cpx #$f0
 sed
 .byte $fc,$fe,$7f
 bbr3 $1f,$eb5a
 rmb0 $03
 ora ($00,x)
 lsr
 lsr
 lsr
 lsr
 lsr
 lsr
 lsr
 jmp $ec0a
 lsr
 ror $02a4
 ror $02a5
 lsr
 ror $02a4
 ror $02a5
 lsr
 ror $02a4
 ror $02a5
 lsr
 ror $02a4
 ror $02a5
 lsr
 ror $02a4
 ror $02a5
 lsr
 ror $02a4
 ror $02a5
 lsr
 ror $02a4
 ror $02a5
 jmp $ec0a
 asl
 asl
 asl
 asl
 asl
 asl
 asl
 jmp $ec0a
 asl $02a5
 rol $02a4
 rol
 asl $02a5
 rol $02a4
 rol
 asl $02a5
 rol $02a4
 rol
 asl $02a5
 rol $02a4
 rol
 asl $02a5
 rol $02a4
 rol
 asl $02a5
 rol $02a4
 rol
 asl $02a5
 rol $02a4
 rol
 jmp $ec0a
 sta $02a3
 lda $10
 sec
 sbc $02b9
 beq $ebdf
 bcc $ebe5
 tay
 jsr $ea9b
 dey
 bne $ebd9
 lda $02a3
 jmp $ec0a
 lda $02b9
 sec
 sbc $10
 tay
 asl $02aa
 rol $02a9
 rol $02a8
 rol $02a7
 rol $02a6
 rol $02a5
 rol $02a4
 rol $02a3
 dey
 bne $ebec
 lda $02a3
 sta $02a3
 bit $029a
 bvc $ec2d
 lda #$00
 pha
 ldy #$ff
 iny
 ldx $02a3,y
 pla
 ora $e5a6,x
 sta $02a3,y
 txa
 lsr
 lda #$00
 ror
 pha
 cpy $12
 bne $ec17
 pla
 rts
 sty $02a4
 sty $02a5
 lda ($06),y
 and $02b8
 and $11
 jmp ($001a)
 sty $02a5
 sty $02a6
 lda ($06),y
 and $02b8
 sta $02a3
 iny
 lda ($06),y
 and $11
 sta $02a4
 lda $02a3
 jmp ($001a)
 sty $02a6
 sty $02a7
 lda ($06),y
 and $02b8
 sta $02a3
 iny
 lda ($06),y
 sta $02a4
 iny
 lda ($06),y
 and $11
 sta $02a5
 bra $ec54
 lda ($06),y
 and $02b8
 sta $02a3
 iny
 cpy $09
 beq $ec8c
 lda ($06),y
 sta $02a3,y
 bra $ec80
 lda ($06),y
 and $11
 sta $02a3,y
 lda #$00
 sta $02a4,y
 sta $02a5,y
 beq $ec54
 sta $0264
 clc
 rts
 tax
 lda $06
 pha
 lda $07
 pha
 lda $0e
 pha
 lda $0f
 pha
 lda $10
 pha
 lda $11
 pha
 lda $18
 pha
 lda $19
 pha
 lda $05
 pha
 lda $02
 sta $18
 lda $03
 sta $19
 lda $04
 sta $05
 txa
 jsr $ecf6
 lda $18
 sta $02
 lda $19
 sta $03
 lda $05
 sta $04
 pla
 sta $05
 pla
 sta $19
 pla
 sta $18
 pla
 sta $11
 pla
 sta $10
 pla
 sta $0f
 pla
 sta $0e
 pla
 sta $07
 pla
 sta $06
 rts
 cmp #$20
 bcs $ed09
 asl
 tay
 lda $ed7e,y
 ldx $ed7f,y
 beq $ec9d
 jsr $ed77
 clc
 rts
 cmp #$80
 bcc $ed20
 cmp #$a0
 bcs $ed20
 asl
 tay
 lda $edbe,y
 ldx $edbf,y
 beq $ec9d
 jsr $ed77
 clc
 rts
 cmp #$ff
 bne $ed26
 lda #$80
 pha
 ldy $19
 sty $1d
 ldy $18
 sty $1c
 ldx $029a
 jsr $e6eb
 dey
 tya
 clc
 adc $1c
 sta $1c
 bcc $ed40
 inc $1d
 lda $02a2
 cmp $1d
 bne $ed4c
 lda $02a1
 cmp $1c
 bcc $ed74
 lda $02a0
 cmp $19
 bne $ed5a
 lda $029f
 cmp $18
 beq $ed5e
 bcs $ed67
 pla
 sec
 sbc #$20
 jsr $eab4
 clc
 rts
 lda $1c
 clc
 adc #$01
 sta $18
 lda $1d
 adc #$00
 sta $19
 pla
 sec
 rts
 sta $1c
 stx $1d
 jmp ($001c)
 inc $ffed,x
 sbc $edfe
 inc $0ced,x
 inc $0001
 ora $ee,x
 inc $1eed,x
 inc $ee3c
 eor ($ee)
 and $46ee,x
 inc $ee4f
 inc $feed,x
 sbc $edfe
 .byte $5c,$ee,$65
 inc $ee71
 asl $feee,x
 sbc $edfe
 inc $feed,x
 sbc $edfe
 inc $feed,x
 sbc $0002
 sta $ee
 ora $00
 asl $00
 inc $08ed,x
 brk
 inc $feed,x
 sbc $edfe
 inc $feed,x
 sbc $edfe
 inc $feed,x
 sbc $edfe
 inc $feed,x
 sbc $ee4f
 inc $feed,x
 sbc $0000
 txa
 inc $ee93
 ror $feee
 sbc $0009
 asl
 brk
 nop
 brk
 tsb $0d00
 brk
 asl $0f00
 brk
 tsb $00
 asl $07ee,x
 brk
 nop
 brk
 rts
 lda $0264
 ldx $0265
 stx $0264
 sta $0265
 rts
 lda #$80
 ora $029a
 sta $029a
 rts
 lda #$40
 ora $029a
 sta $029a
 rts
 lda $18
 sec
 sbc $02b4
 sta $18
 bcs $ee2a
 dec $19
 lda $18
 pha
 lda $19
 pha
 lda #$7f
 jsr $eab4
 pla
 sta $19
 pla
 sta $18
 rts
 rts
 lda #$10
 ora $029a
 sta $029a
 rts
 lda #$08
 ora $029a
 sta $029a
 rts
 stz $029a
 lda $029f
 sta $18
 lda $02a0
 sta $19
 lda $05
 sec
 adc $0297
 sta $05
 rts
 lda #$20
 ora $029a
 sta $029a
 rts
 jsr $e0b0
 lda $029f
 sta $18
 lda $02a0
 sta $19
 lda $029b
 clc
 adc $0297
 sta $05
 rts
 lda #$20
 jmp $ecf6
 lda $05
 sec
 sbc $0297
 sta $05
 rts
 stz $029a
 rts
 lda $02
 ora $03
 bne $eea5
 lda #$f3
 sta $02
 lda #$ee
 sta $03
 ldy #$00
 lda ($02),y
 sta $0294
 iny
 lda ($02),y
 sta $0295
 iny
 lda ($02),y
 sta $0296
 iny
 lda ($02),y
 sta $0297
 iny
 lda ($02),y
 sta $90
 iny
 lda ($02),y
 sta $91
 iny
 lda ($02),y
 sta $0298
 iny
 lda ($02),y
 sta $0299
 lda $02
 clc
 adc $90
 sta $90
 lda $03
 adc $91
 sta $91
 lda $02
 clc
 adc $0298
 sta $0298
 lda $03
 adc $0299
 sta $0299
 rts
 asl $3e
 brk
 ora #$08
 brk
 cpy $0000
 brk
 nop
 brk
 ora $00
 ora #$00
 bbr0 $00,$ef1b
 brk
 asl $2500,x
 brk
 rmb0 $00
 nop
 brk
 nop
 nop
 nop
 brk
 nop
 brk
 and $4100,x
 brk
 nop
 brk
 eor #$00
 lsr $5100
 brk
 lsr $00,x
 nop
 brk
 rts
 brk
 adc $00
 ror
 brk
 brk
 adc $7b00,y
 brk
 ror $8400,x
 brk
 txa
 brk
 bcc $ef3b
 sta $00,x
 sta $a300,x
 brk
 lda #$00
 nop
 nop
 nop
 brk
 tsx
 brk
 nop
 nop
 nop
 brk
 wai
 brk
 cmp $d200
 brk
 cld
 brk
 cmp $e500,x
 brk
 nop
 brk
 sbc ($00),y
 inc $00,x
 .byte $fc,$00,$02
 ora ($08,x)
 ora ($0e,x)
 ora ($14,x)
 ora ($1a,x)
 ora ($24,x)
 ora ($2a,x)
 ora ($30,x)
 ora ($35,x)
 ora ($38,x)
 ora ($3e,x)
 ora ($41,x)
 ora ($47,x)
 ora ($4d,x)
 ora ($50,x)
 ora ($55,x)
 ora ($5a,x)
 ora ($5f,x)
 ora ($64,x)
 ora ($69,x)
 ora ($6e,x)
 ora ($73,x)
 ora ($78,x)
 ora ($7a,x)
 ora ($7d,x)
 ora ($82,x)
 ora ($84,x)
 ora ($8c,x)
 ora ($91,x)
 ora ($96,x)
 ora ($9b,x)
 ora ($a0,x)
 ora ($a5,x)
 ora ($aa,x)
 ora ($ae,x)
 ora ($b3,x)
 ora ($b9,x)
 ora ($c1,x)
 ora ($c7,x)
 ora ($cd,x)
 ora ($d2,x)
 ora ($d6,x)
 ora ($d8,x)
 ora ($dc,x)
 ora ($e2,x)
 ora ($e4,x)
 ora ($f0,x)
 ora ($0a,x)
 sty $21,x
 php
 .byte $42,$28
 jsr $0000
 tya
 tya
 .byte $c2,$79
 stz $0063,x
 brk
 brk
 bmi $efb3
 bbs0 $1c,$efb9
 dec $2872,x
 eor ($42),y
 asl
 rmb0 $38
 smb0 $8e
 adc $5114,x
 trb $51
 nop
 eor ($88,x)
 .byte $02,$02
 brk
 bpl $eff9
 php
 lsr
 bpl $eff1
 brk
 brk
 brk
 php
 brk
 brk
 brk
 brk
 ora $40
 asl $0c
 asl
 sty $72,x
 bcc $efa4
 .byte $44,$f8
 brk
 ora ($25,x)
 lda $26
 .byte $42,$42
 sty $80,x
 brk
 brk
 eor #$10
 dey
 ldx #$92
 bpl $efa0
 plp
 eor ($43)
 nop
 plp
 lda $14
 eor ($11),y
 trb $51
 ora ($8a)
 asl
 jsr $0188
 .byte $82,$00
 bpl $f03b
 php
 .byte $02,$10
 brk
 brk
 brk
 brk
 php
 brk
 brk
 brk
 brk
 ora #$20
 rmb0 $1c
 asl
 ldx $a0aa,y
 ldx #$82
 jsr $0180
 bit $84
 rol $73
 sty $94
 ldy $10
 bpl $f060
 adc #$48
 ldy #$8a
 bpl $efd6
 plp
 .byte $54,$43
 nop
 plp
 lda $14
 bvc $f06e
 trb $4a
 ldx #$8a
 ora ($20)
 sty $00,x
 nop
 sty $3873
 inc $574a
 rmb0 $19
 smb0 $59
 cmp $a028,x
 ldx #$8b
 cmp #$20
 nop
 clv
 php
 trb $61
 plp
 iny
 .byte $82,$50
 bra $f084
 bit $88
 dex
 lsr
 .byte $44,$64
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 cpy $a922
 nop
 nop
 nop
 stz $e89b
 cli
 .byte $42,$aa
 tay
 lda $17
 stx $1211
 txa
 lda ($04,x)
 .byte $02,$10
 sty $00,x
 asl
 eor ($94)
 sta ($29),y
 lsr
 sty $94,x
 lda $29
 .byte $62,$09
 and $15
 trb $50
 bit #$23
 eor ($b0,x)
 php
 rol $5530,x
 plp
 .byte $82,$03
 nop
 sty $24
 .byte 0,0,0,0,0,0,0,0
 .byte 0,0,0,0,0,0,0,0
 .byte 0,0,0,0,0,0,0,0
 .byte 0,0,0,0,0,0,0,0
 bcc $f0f2
 asl
 pha
 nop
 sta ($c0,x)
 nop
 .byte $22,$53
 inx
 ldy #$8a
 bpl $f05a
 plp
 .byte $54,$42
 tax
 pla
 lda $8114,y
 ora ($12),y
 txa
 ldx #$84
 .byte $22,$08
 ldx #$00
 dec
 bvc $f07b
 sta ($29),y
 nop
 trb $94
 lda $29
 eor ($89,x)
 and $15
 php
 eor ($11),y
 ora $80,x
 ldy #$00
 trb $a8
 sta $10,x
 .byte $82,$00
 bra $f102
 bit $a1
 .byte $22,$4a
 pha
 sty $80,x
 rmb0 $cc
 ora ($02,x)
 plp
 ldx #$92
 bpl $f098
 rol
 eor ($42)
 lsr
 pla
 lda ($14,x)
 eor ($11),y
 ora ($84)
 .byte $42,$84
 .byte $22,$08
 bra $f11f
 lsr
 eor ($94)
 ora ($29),y
 lsr
 sty $94,x
 lda $29
 rti
 eor #$22
 asl
 trb $22
 ora #$20
 nop
 clv
 php
 trb $71
 php
 inx
 .byte $82,$00
 dey
 plp
 clc
 ldy $31c2,x
 dey
 nop
 bit $10
 bpl $f166
 .byte $e2,$2f
 trb $d0e3
 adc ($29)
 sta ($7a),y
 asl
 rmb0 $20
 cpx $4e
 bpl $f137
 tsb $44
 .byte $44,$7a
 tsb $80
 brk
 nop
 sty $9073
 sbc #$4a
 .byte $54,$94
 sta $43c7,y
 sty $e2
 asl
 .byte $22,$23
 cmp #$20
 nop
 clc
 brk
 brk
 jsr $0000
 .byte $44,$00
 php
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 tsb $00
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 rti
 brk
 brk
 brk
 brk
 brk
 brk
 .byte $82,$00
 bra $f193
 brk
 brk
 brk
 brk
 jsr $0008
 brk
 ora ($01,x)
 brk
 brk
 brk
 brk
 brk
 jsr $2009
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 plp
 brk
 bpl $f1b8
 brk
 brk
 brk
 brk
 brk
 brk
 php
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 bmi $f1d0
 brk
 brk
 brk
 brk
 brk
 nop
 ora ($80,x)
 brk
 brk
 brk
 brk
 brk
 cpy #$10
 brk
 brk
 ora ($01,x)
 brk
 brk
 brk
 brk
 brk
 cpy #$05
 rti
 brk
 brk
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 jsr $e133
 lda #$0f
 jsr $ffd2
 stz $a0e2
 stz $a091
 stz $a0e3
 stz $a0e5
 stz $a0e6
 stz $02
 stz $03
 jsr $f245
 lda #$93
 clc
 jsr $f283
 lda #$92
 clc
 jsr $f283
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 lda $02
 sta $a0ed
 lda $03
 sta $a0ee
 stz $a0eb
 stz $a0ec
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 php
 cmp #$0d
 bne $f2a7
 lda #$92
 jsr $f283
 lda #$0a
 ldy $a0e2
 sta $a041,y
 inc $a0e2
 plp
 bcc $f2d6
 cmp #$20
 beq $f2d6
 cmp #$0a
 beq $f2d6
 cmp #$0d
 beq $f2d6
 clc
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 lda $02
 pha
 lda $03
 pha
 lda $04
 pha
 lda $05
 pha
 lda $a0e7
 sta $02
 lda $a0e8
 sta $03
 ldy #$00
 lda $a041,y
 cmp #$20
 beq $f312
 phy
 ldx $029a
 jsr $e6a6
 ply
 bcc $f301
 bra $f312
 stx $04
 stz $05
 lda $04
 clc
 adc $02
 sta $02
 lda $05
 adc $03
 sta $03
 iny
 cpy $a0e2
 bne $f2ee
 lda $02a1
 sta $04
 lda $02a2
 sta $05
 inc $04
 bne $f328
 inc $05
 lda $03
 cmp $05
 bne $f332
 lda $02
 cmp $04
 bcc $f34d
 lda $a0e7
 sta $02
 lda $a0e8
 sta $03
 lda $a0e9
 sta $04
 lda $a0ea
 sta $05
 jsr $f3c6
 bra $f361
 lda $a0e7
 sta $02
 lda $a0e8
 sta $03
 lda $a0e9
 sta $04
 lda $a0ea
 sta $05
 lda $a0e2
 beq $f379
 ldy #$00
 lda $a041,y
 phy
 jsr $f3af
 ply
 iny
 cpy $a0e2
 bne $f368
 stz $a0e2
 lda $02
 sta $a0e7
 lda $03
 sta $a0e8
 lda $04
 sta $a0e9
 lda $05
 sta $a0ea
 pla
 sta $05
 pla
 sta $04
 pla
 sta $03
 pla
 sta $02
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 cmp #$0a
 beq $f3c6
 cmp #$0d
 beq $f3c6
 pha
 jsr $eca2
 bcs $f3bf
 pla
 rts
 jsr $f3c6
 pla
 jmp $eca2
 jsr $f776
 iny
 tya
 pha
 sec
 sbc $a0e5
 lda #$00
 sbc $a0e6
 bcc $f3dd
 sty $a0e5
 stz $a0e6
 lda $04
 pha
 lda $05
 pha
 lda #$0a
 jsr $eca2
 pla
 sta $05
 pla
 sta $04
 lda $a0e5
 clc
 adc $04
 sta $04
 lda $a0e6
 adc $05
 sta $05
 lda $a0e5
 clc
 adc $a0eb
 sta $a0eb
 lda $a0e6
 adc $a0ec
 sta $a0ec
 stz $a0e5
 stz $a0e6
 lda $029d
 sta $1c
 lda $029e
 sta $1d
 lda $1c
 sec
 sbc $029b
 sta $1c
 lda $1d
 sbc $029c
 sta $1d
 pla
 stz $1b
 asl
 rol $1b
 asl
 rol $1b
 sta $1a
 lda $1c
 sec
 sbc $1a
 sta $1c
 lda $1d
 sbc $1b
 sta $1d
 lda $a0ec
 cmp $1d
 bne $f453
 lda $a0eb
 cmp $1c
 bcc $f45e
 stz $a0eb
 stz $a0ec
 jsr $f5c0
 lda $02
 sta $a0e7
 lda $03
 sta $a0e8
 lda $04
 sta $a0e9
 lda $05
 sta $a0ea
 jsr $f48a
 lda $a0e7
 sta $02
 lda $a0e8
 sta $03
 lda $a0e9
 sta $04
 lda $a0ea
 sta $05
 rts
 jsr $f776
 iny
 sty $1e
 stz $1f
 lda $029d
 sta $20
 lda $029e
 sta $21
 lda $20
 sec
 sbc $1e
 sta $20
 lda $21
 sbc $1f
 sta $21
 lda $a0ea
 cmp $21
 bne $f4b5
 lda $a0e9
 cmp $20
 bcs $f4b8
 rts
 lda $06
 pha
 lda $07
 pha
 lda $1e
 sta $0e
 lda $1f
 sta $0f
 lda $0e
 clc
 adc #$02
 sta $0e
 bcc $f4d1
 inc $0f
 lda $029f
 sta $02
 lda $02a0
 sta $03
 lda $029b
 clc
 adc $0e
 sta $04
 lda $029c
 adc $0f
 sta $05
 lda $029f
 sta $06
 lda $02a0
 sta $07
 lda $029b
 sta $08
 lda $029c
 sta $09
 lda $02a1
 sta $0a
 lda $02a2
 sta $0b
 lda $0a
 sec
 sbc $029f
 sta $0a
 lda $0b
 sbc $02a0
 sta $0b
 inc $0a
 bne $f51d
 inc $0b
 lda $0a
 pha
 lda $0b
 pha
 lda $029d
 sta $0c
 lda $029e
 sta $0d
 lda $0c
 sec
 sbc $029b
 sta $0c
 lda $0d
 sbc $029c
 sta $0d
 lda $0c
 sec
 sbc $0e
 sta $0c
 lda $0d
 sbc $0f
 sta $0d
 inc $0c
 bne $f54f
 inc $0d
 jsr $e539
 lda $029f
 sta $02
 lda $02a0
 sta $03
 lda $029d
 sta $04
 lda $029e
 sta $05
 lda $04
 sec
 sbc $0e
 sta $04
 lda $05
 sbc $0f
 sta $05
 inc $04
 bne $f579
 inc $05
 pla
 sta $07
 pla
 sta $06
 lda $0e
 sta $08
 lda $0f
 sta $09
 stz $0a
 stz $0b
 lda $0264
 pha
 lda $0265
 pha
 lda $0266
 sta $0264
 sta $0265
 sec
 jsr $e40b
 pla
 sta $0265
 pla
 sta $0264
 lda $a0e9
 sec
 sbc $0e
 sta $a0e9
 lda $a0ea
 sbc $0f
 sta $a0ea
 pla
 sta $07
 pla
 sta $06
 rts
 lda $a0ed
 ora $a0ee
 bne $f5c9
 rts
 lda $0264
 pha
 lda $0265
 pha
 lda $02
 pha
 lda $03
 pha
 lda $04
 pha
 lda $05
 pha
 lda $06
 pha
 lda $07
 pha
 lda $08
 pha
 lda $09
 pha
 lda $0a
 pha
 lda $0b
 pha
 lda $a0ed
 sta $20
 lda $a0ee
 sta $21
 lda $029a
 pha
 stz $029a
 ldy #$00
 lda ($20),y
 beq $f60e
 phy
 jsr $f3af
 ply
 iny
 bne $f602
 pla
 sta $029a
 jsr $c995
 beq $f612
 lda $02
 sta $06
 lda $03
 sta $07
 lda $06
 sec
 sbc $029f
 sta $06
 lda $07
 sbc $02a0
 sta $07
 lda $029f
 sta $02
 lda $02a0
 sta $03
 inc $02
 bne $f63e
 inc $03
 jsr $f776
 sta $a0e4
 lda $04
 sec
 sbc $a0e4
 sta $04
 bcs $f651
 dec $a0e5
 iny
 tya
 sta $08
 stz $09
 stz $0a
 stz $0b
 lda $0266
 sta $0264
 sta $0265
 sec
 jsr $e40b
 pla
 sta $0b
 pla
 sta $0a
 pla
 sta $09
 pla
 sta $08
 pla
 sta $07
 pla
 sta $06
 pla
 sta $05
 pla
 sta $04
 pla
 sta $03
 pla
 sta $02
 lda $029f
 sta $02
 lda $02a0
 sta $03
 pla
 sta $0265
 pla
 sta $0264
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 lda $a0e7
 clc
 adc $04
 sta $20
 lda $a0e8
 adc $05
 sta $21
 lda $20
 bne $f6c6
 dec $21
 dec $20
 lda $21
 cmp $02a2
 bne $f6d4
 lda $20
 cmp $02a1
 bcc $f6dd
 beq $f6dd
 lda #$0a
 jsr $f283
 lda #$00
 clc
 jsr $f283
 lda $06
 sta $1e
 lda $07
 sta $1f
 lda $02
 pha
 lda $03
 pha
 lda $04
 pha
 lda $05
 pha
 jsr $f492
 pla
 sta $05
 pla
 sta $04
 pla
 sta $03
 pla
 sta $02
 lda $06
 sta $a0e5
 lda $07
 sta $a0e6
 lda $06
 sta $0a
 lda $07
 sta $0b
 lda $04
 sta $08
 lda $05
 sta $09
 lda $02
 sta $06
 lda $03
 sta $07
 lda $a0e7
 sta $02
 lda $a0e8
 sta $03
 lda $a0e9
 sta $04
 lda $a0ea
 sta $05
 jsr $f776
 sta $0c
 lda $04
 sec
 sbc $0c
 sta $04
 bcs $f74c
 dec $05
 jsr $e4e0
 lda $08
 clc
 adc $a0e7
 sta $a0e7
 lda $09
 adc $a0e8
 sta $a0e8
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 ldx #$00
 lda #$20
 jsr $e6a6
 rts
 php
 sei
 sta $0251
 pla
 sta $0252
 lda $9f61
 pha
 stz $9f61
 lda $0252
 pha
 lda $0251
 plp
 lda $a091
 beq $f79e
 jmp $f89e
 lda #$92
 clc
 jsr $f283
 jsr $f776
 sta $a0e4
 tya
 inc
 asl
 sta $02
 ldx #$20
 stz $a091,x
 dex
 bpl $f7b1
 ldx #$00
 lda #$80
 sta $a0b1,x
 inx
 stz $a0b1,x
 inx
 cpx $02
 bne $f7bb
 cpx #$20
 bcs $f7d1
 stz $a0b1,x
 inx
 bra $f7c7
 lda #$91
 sta $02
 lda #$a0
 sta $03
 lda #$b1
 sta $04
 lda #$a0
 sta $05
 lda #$01
 sta $06
 ldx #$10
 ldy #$10
 lda #$01
 sec
 jsr $f923
 lda $a0e7
 sta $02
 lda $a0e8
 sta $03
 lda $a0e9
 sta $04
 lda $a0ea
 sta $05
 lda $02
 pha
 lda $03
 pha
 lda $04
 pha
 lda $05
 pha
 inc $02
 bne $f815
 inc $03
 lda $04
 sec
 sbc $a0e4
 sta $04
 lda $05
 sbc #$00
 sta $05
 lda #$01
 jsr $f9bd
 pla
 sta $05
 pla
 sta $04
 pla
 sta $03
 pla
 sta $02
 jsr $c995
 beq $f834
 cmp #$08
 beq $f841
 cmp #$14
 bne $f844
 jmp $f8c9
 cmp #$0a
 beq $f886
 cmp #$0d
 beq $f886
 cmp #$20
 bcc $f834
 cmp #$80
 bcc $f858
 cmp #$a0
 bcc $f834
 ldx $a0e3
 cpx #$50
 beq $f834
 pha
 jsr $eca2
 lda $02
 sta $a0e7
 lda $03
 sta $a0e8
 lda $04
 sta $a0e9
 lda $05
 sta $a0ea
 pla
 bcs $f834
 ldx $a0e3
 sta $a091,x
 inc $a0e3
 jmp $f7ef
 ldx $a0e3
 lda #$0d
 sta $a091,x
 stz $a0e3
 clc
 jsr $f283
 lda #$ff
 sta $03
 lda #$01
 jsr $f9bd
 ldx $a0e3
 lda $a091,x
 cmp #$0d
 bne $f8b0
 stz $a0e3
 stz $a091
 bra $f8b3
 inc $a0e3
 php
 sei
 sta $0251
 pla
 sta $0252
 pla
 sta $9f61
 lda $0252
 pha
 lda $0251
 plp
 rts
 ldx $a0e3
 bne $f8d1
 jmp $f834
 dex
 stx $a0e3
 lda $a091,x
 pha
 ldx #$00
 jsr $e6a6
 stx $06
 lda $02
 sec
 sbc $06
 sta $02
 lda $03
 sbc #$00
 sta $03
 plx
 lda $02
 pha
 lda $03
 pha
 lda $0264
 pha
 lda $0266
 sta $0264
 txa
 jsr $eca2
 pla
 sta $0264
 pla
 sta $03
 pla
 sta $02
 lda $02
 sta $a0e7
 lda $03
 sta $a0e8
 lda $04
 sta $a0e9
 lda $05
 sta $a0ea
 jmp $f7ef
 pha
 php
 asl
 asl
 asl
 asl
 clc
 adc #$78
 sta $9f21
 lda #$00
 sta $9f20
 lda #$10
 sta $9f22
 plp
 bcc $f94f
 cpx #$10
 bne $f94f
 cpy #$10
 bne $f94f
 lda $06
 cmp #$01
 bne $f94f
 jsr $f985
 bra $f951
 sec
 rts
 pla
 pha
 asl
 asl
 asl
 sta $9f20
 lda #$fc
 sta $9f21
 lda #$11
 sta $9f22
 pla
 lsr
 pha
 lda #$00
 ror
 clc
 adc #$c0
 sta $9f23
 pla
 adc #$83
 sta $9f23
 lda $9f20
 clc
 adc #$05
 sta $9f20
 lda #$50
 sta $9f23
 clc
 rts
 lda $07
 pha
 ldy #$00
 lda #$08
 sta $07
 lda ($02),y
 tax
 lda ($04),y
 asl
 bcs $f9a0
 stz $9f23
 pha
 txa
 asl
 tax
 pla
 bra $f9b0
 pha
 txa
 asl
 tax
 bcc $f9aa
 lda #$01
 bra $f9ac
 lda #$10
 sta $9f23
 pla
 dec $07
 bne $f993
 iny
 cpy #$20
 bne $f98a
 pla
 sta $07
 rts
 ldx #$fc
 stx $9f21
 ldx #$11
 stx $9f22
 and #$07
 asl
 asl
 asl
 clc
 ldx $03
 bpl $f9da
 adc #$06
 sta $9f20
 stz $9f23
 rts
 adc #$02
 sta $9f20
 lda $02
 sta $9f23
 lda $03
 sta $9f23
 lda $04
 sta $9f23
 lda $05
 sta $9f23
 lda #$0c
 sta $9f23
 lda $9f29
 ora #$40
 sta $9f29
 rts
 ora $3efa,x
 plx
 eor ($fa),y
 eor ($fa)
 txa
 plx
 ldx #$fa
 bbs4 $fa,$f9ae
 plx
 ldx $fa
 .byte $fc,$fa,$1d
 nop
 lsr
 nop
 ldy $49fb
 .byte $fc,$07,a9
 sta $9f2d
 stz $9f31
 lda #$80
 sta $9f2f
 lda $9f29
 ora #$10
 sta $9f29
 stz $9f25
 lda #$40
 sta $9f2a
 sta $9f2b
 rts
 lda #$40
 sta $02
 lda #$01
 sta $03
 lda #$c8
 sta $04
 lda #$00
 sta $05
 lda #$08
 rts
 rts
 stz $87
 lda $04
 asl
 rol $87
 asl
 rol $87
 asl
 rol $87
 asl
 rol $87
 asl
 rol $87
 asl
 rol $87
 sta $86
 lda $04
 clc
 adc $87
 sta $87
 lda #$11
 sta $9f22
 lda $02
 clc
 adc $86
 sta $86
 sta $9f20
 lda $03
 adc $87
 sta $87
 sta $9f21
 rts
 lda #$40
 clc
 adc $86
 sta $86
 sta $9f20
 lda #$01
 adc $87
 sta $87
 sta $9f21
 rts
 sta $9f23
 rts
 lda $9f23
 rts
 lda $03
 pha
 lda $05
 pha
 lda $05
 beq $fabb
 ldx #$00
 jsr $fabd
 inc $03
 dec $05
 bne $fab2
 ldx $04
 ldy #$00
 lda ($02),y
 sta $9f23
 iny
 dex
 bne $fabf
 pla
 sta $05
 pla
 sta $03
 rts
 lda $03
 pha
 lda $05
 pha
 jsr $fadf
 pla
 sta $05
 pla
 sta $03
 rts
 lda $05
 beq $faee
 ldx #$00
 jsr $faf0
 inc $03
 dec $05
 bne $fae5
 ldx $04
 ldy #$00
 lda $9f23
 sta ($02),y
 iny
 dex
 bne $faf2
 rts
 sec
 rol
 bcs $fb15
 inc $9f20
 bne $fb08
 inc $9f21
 asl
 bcs $fb15
 inc $9f20
 bne $fb08
 inc $9f21
 bra $fb08
 beq $fb1c
 stx $9f23
 bra $fb08
 rts
 sec
 rol
 bcc $fb3d
 beq $fb49
 asl $02
 bcs $fb38
 sty $9f23
 asl
 bcc $fb3d
 beq $fb49
 asl $02
 bcs $fb38
 sty $9f23
 bra $fb2a
 stx $9f23
 bra $fb2a
 asl $02
 inc $9f20
 bne $fb2a
 inc $9f21
 bra $fb2a
 rts
 ldx $05
 bne $fb9b
 ldx $04
 cpx #$02
 bcs $fb9b
 ldx $03
 beq $fb60
 ldy #$20
 jsr $fb7f
 dex
 bne $fb5a
 pha
 lda $02
 lsr
 lsr
 lsr
 beq $fb6e
 tay
 pla
 jsr $fb7f
 pha
 lda $02
 and #$07
 beq $fb7d
 tay
 pla
 sta $9f23
 dey
 bne $fb76
 rts
 pla
 rts
 sta $9f23
 sta $9f23
 sta $9f23
 sta $9f23
 sta $9f23
 sta $9f23
 sta $9f23
 sta $9f23
 dey
 bne $fb7f
 rts
 ldx #$71
 stx $9f22
 ldx $02
 sta $9f23
 inc $9f21
 dex
 bne $fba2
 rts
 lda #$4c
 sta $1f
 lda $04
 sta $20
 lda $05
 sta $21
 lda $9f20
 ldx $9f21
 inc $9f25
 sta $9f20
 stx $9f21
 lda #$11
 sta $9f22
 stz $9f25
 sta $9f22
 ldx $03
 beq $fbde
 ldy #$20
 jsr $fbfd
 dex
 bne $fbd8
 lda $02
 lsr
 lsr
 lsr
 beq $fbe9
 tay
 jsr $fbfd
 lda $02
 and #$07
 beq $fbfc
 tay
 lda $9f23
 jsr $001f
 sta $9f24
 dey
 bne $fbf0
 rts
 lda $9f23
 jsr $001f
 sta $9f24
 lda $9f23
 jsr $001f
 sta $9f24
 lda $9f23
 jsr $001f
 sta $9f24
 lda $9f23
 jsr $001f
 sta $9f24
 lda $9f23
 jsr $001f
 sta $9f24
 lda $9f23
 jsr $001f
 sta $9f24
 lda $9f23
 jsr $001f
 sta $9f24
 lda $9f23
 jsr $001f
 sta $9f24
 dey
 bne $fbfd
 rts
 lda #$01
 sta $9f25
 jsr $fa52
 stz $9f25
 lda $02
 pha
 lda $03
 pha
 lda $04
 pha
 lda $05
 pha
 lda $06
 sta $02
 lda $07
 sta $03
 lda $08
 sta $04
 lda $09
 sta $05
 jsr $fa52
 pla
 sta $05
 pla
 sta $04
 pla
 sta $03
 pla
 sta $02
 ldx $0b
 beq $fc8b
 ldy #$20
 jsr $fca7
 dex
 bne $fc85
 lda $0a
 lsr
 lsr
 lsr
 beq $fc96
 tay
 jsr $fca7
 lda $0a
 and #$07
 beq $fca6
 tay
 lda $9f24
 sta $9f23
 dey
 bne $fc9d
 rts
 lda $9f24
 sta $9f23
 lda $9f24
 sta $9f23
 lda $9f24
 sta $9f23
 lda $9f24
 sta $9f23
 lda $9f24
 sta $9f23
 lda $9f24
 sta $9f23
 lda $9f24
 sta $9f23
 lda $9f24
 sta $9f23
 dey
 bne $fca7
 rts
 sta $9f60
 pla
 plp
 jsr $02e1
 php
 pha
 phx
 tsx
 lda $0104,x
 sta $9f60
 lda $0103,x
 sta $0104,x
 plx
 pla
 plp
 plp
 rts
 jmp $ffff
 pha
 phx
 lda $9f60
 pha
 lda #$00
 sta $9f60
 lda #$03
 pha
 lda #$a4
 pha
 tsx
 lda $0106,x
 pha
 jmp ($fffe)
 pla
 sta $9f60
 plx
 pla
 rti
 sta $9f60
 lda ($ff),y
 stx $9f60
 rts
 lda #$ff
 sta ($ff),y
 plx
 stx $9f61
 rts
 sta $9f60
 pla
 cmp ($ff),y
 php
 stx $9f60
 jmp $dfe8
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 tax
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 brk
 jmp $e000
 jmp $de7a
 jmp $c9e1
 jmp $f245
 jmp $f699
 jmp $f1ed
 jmp $f283
 jmp $f77e
 jmp $d3df
 jmp $d401
 jmp $d46d
 jmp $d52c
 jmp $f923
 jmp $f9bd
 jmp ($02e4)
 jmp ($02e6)
 jmp ($02e8)
 jmp ($02ea)
 jmp ($02ec)
 jmp ($02ee)
 jmp ($02f0)
 jmp ($02f2)
 jmp ($02f4)
 jmp ($02f6)
 jmp ($02f8)
 jmp ($02fa)
 jmp ($02fc)
 jmp ($02fe)
 jmp $e083
 jmp $e0b0
 jmp $e133
 jmp $e18e
 jmp $e198
 jmp $e40b
 jmp $e539
 jmp $e5a5
 jmp $e4e0
 jmp $ee97
 jmp $e6a6
 jmp $eca2
 jmp $d1ad
 jmp $dff2
 jmp $d83b
 jmp $dbd4
 jmp $dbca
 jmp $cfe6
 jmp $d04d
 jmp $d885
 jmp $d86b
 jmp $c757
 jmp $c8e1
 brk
 brk
 brk
 jmp $cd70
 jmp $cf61
 jmp $df4d
 jmp $ce21
 jmp $dfab
 jmp $dfca
 jmp $dfd7
 jmp $e05a
 phx
 jmp $c02b
 jmp $de9b
 jmp $ded6
 jmp $d4c8
 jmp $d4cd
 jmp $d6b1
 jmp $d112
 jmp $d124
 jmp $d503
 jmp $d518
 jmp $cb43
 jmp $d6bd
 jmp $d133
 jmp $d142
 jmp $d151
 jmp $d160
 jmp $d16f
 jmp $d18e
 jmp $d6b4
 jmp $d6a7
 jmp $d69f
 jmp ($031a)
 jmp ($031c)
 jmp ($031e)
 jmp ($0320)
 jmp ($0322)
 jmp ($0324)
 jmp ($0326)
 jmp $d949
 jmp $dac5
 jmp $dc53
 jmp $dc19
 jmp ($0328)
 jmp ($032a)
 jmp ($032c)
 jmp $dbbc
 jmp $c000
 jmp $c007
 jmp $d527
 eor $5349
 .byte $54,$06
 cpx #$86
 dec $e023,x
